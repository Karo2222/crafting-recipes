import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' as foundation;
import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/environment.dart';
import 'package:craftingrecipes/helpers/localstorage/app_util.dart';
import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/offline_mutation_queue.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import 'package:craftingrecipes/helpers/localstorage/key_value.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as s;

class SupabaseToDrift {
  static Future<void>? _activeSync;
  static Future<void>? _activeChatRefresh;
  static const String _initialSyncCursor = '1900-03-01T00:00:00.000';

  static String _accountCursorKey(KeyValueEnum cursor) =>
      '${cursor.key}_${currentAccount ?? 'signed_out'}';

  static Future<List<Map<String, dynamic>>> _excludePendingLocalRows(
    String mutationType,
    List<Map<String, dynamic>> rows,
  ) async {
    final pendingIds = await OfflineMutationQueue.instance
        .pendingRowIdsForMutation(mutationType);
    if (pendingIds.isEmpty) return rows;
    final protectedRows = rows.where((row) {
      final id = row[Const.id.key];
      return id is num && pendingIds.contains(id.toInt());
    }).length;
    if (protectedRows > 0) {
      logger.i(
        'Kept $protectedRows local $mutationType row(s) while upload is '
        'pending.',
      );
    }
    return rows.where((row) {
      final id = row[Const.id.key];
      return id is! num || !pendingIds.contains(id.toInt());
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> _includeMissingVisibleRows({
    required String tableName,
    required List<dynamic> changedRows,
    required Set<int> visibleIds,
    required Set<int> localIds,
  }) async {
    final rowsById = <int, Map<String, dynamic>>{
      for (final row in changedRows)
        (row[Const.id.key] as num).toInt():
            Map<String, dynamic>.from(row as Map),
    };
    final missingIds = visibleIds.difference(localIds).difference(
          rowsById.keys.toSet(),
        );
    final missingIdList = missingIds.toList();
    for (var offset = 0; offset < missingIdList.length; offset += 200) {
      final end = offset + 200 < missingIdList.length
          ? offset + 200
          : missingIdList.length;
      final missingRows = await supabase
          .from(tableName)
          .select('*')
          .inFilter(Const.id.key, missingIdList.sublist(offset, end));
      for (final row in missingRows) {
        rowsById[(row[Const.id.key] as num).toInt()] =
            Map<String, dynamic>.from(row);
      }
    }
    return rowsById.values.toList();
  }

  static String _nextSyncCursor(
    String previousCursor,
    List<dynamic> rows,
  ) {
    var cursor = DateTime.parse(previousCursor).toUtc();
    for (final row in rows) {
      final updatedAt = DateTime.tryParse(
        row[Const.updatedAt.key]?.toString() ?? '',
      )?.toUtc();
      if (updatedAt != null && updatedAt.isAfter(cursor)) {
        cursor = updatedAt;
      }
    }
    return cursor.toIso8601String();
  }

  static Future<void> _reconcileRemoteRecipeDeletions() async {
    const pageSize = 1000;
    var offset = 0;
    final remoteIds = <int>{};
    while (true) {
      final page = await supabase
          .from('recipe')
          .select(Const.id.key)
          .order(Const.id.key)
          .range(offset, offset + pageSize - 1);
      remoteIds.addAll(
        page.map<int>((row) => (row[Const.id.key] as num).toInt()),
      );
      if (page.length < pageSize) break;
      offset += pageSize;
    }
    await Singleton().getDatabase().retainRemoteRecipes(remoteIds);
  }

  static Future<Set<int>> _getVisibleRemoteIds(String tableName) async {
    const pageSize = 1000;
    var offset = 0;
    final remoteIds = <int>{};
    while (true) {
      final page = await supabase
          .from(tableName)
          .select(Const.id.key)
          .order(Const.id.key)
          .range(offset, offset + pageSize - 1);
      remoteIds.addAll(
        page.map<int>((row) => (row[Const.id.key] as num).toInt()),
      );
      if (page.length < pageSize) break;
      offset += pageSize;
    }
    return remoteIds;
  }

  /// Parses an optional timestamp column such as `deleted_at`.
  static DateTime? _dateOrNull(Object? value) =>
      value == null ? null : DateTime.tryParse('$value');

  /// Rows of [table] changed after the stored cursor [cursor], plus the
  /// cursor to store once the rows were saved.
  static Future<(List<Map<String, dynamic>>, String)> _changedRows(
    String table,
    KeyValueEnum cursor, {
    String? orderBy,
  }) async {
    final since =
        await KeyValue.getValue(cursor.key) ?? _initialSyncCursor;
    var query = supabase.from(table).select().gt('updated_at', since);
    final rows = orderBy == null
        ? await query
        : await query.order(orderBy, ascending: true);
    return (rows, _nextSyncCursor(since, rows));
  }

  /// Converts downloaded [rows] one by one while updating the progress shown
  /// on the sync page and stopping early if the user cancels the sync.
  static Future<List<T>> _convertRows<T>(
    String label,
    List<dynamic> rows,
    Future<T> Function(Map<String, dynamic> row, int index) convert,
  ) async {
    final progress = ProgressFraction(0, rows.length, label);
    Singleton().addAndUpdate(progress);
    final converted = <T>[];
    for (final (index, row) in rows.indexed) {
      converted.add(await convert(row as Map<String, dynamic>, index));
      progress.synced++;
      Singleton().updateNotifier();
      checkCancellation();
    }
    return converted;
  }

  /// Caches the first few images of a table locally so they work offline.
  static Future<void> _cacheImageIfWanted({
    required Object? url,
    required int ownerId,
    required int index,
    required int limit,
    required String folder,
  }) async {
    final image = url?.toString().trim() ?? '';
    if (foundation.kIsWeb || image.isEmpty || index >= limit) return;
    await _downloadImages(id: ownerId, url: image, folderName: folder);
  }

  static Future<bool> isDeviceRegistrated(String deviceId) async {
    final result = await supabase
        .from('device')
        .select('device_id')
        .eq('device_id', deviceId)
        .count(s.CountOption.exact);
    return result.count == 1;
  }

  static Future<bool> hostCodeIsValid(String hostCode) async {
    final data = await supabase.rpc(
      'validate_host_code',
      params: {'p_code': hostCode.trim()},
    );
    return data == true;
  }

  static Future<bool> accountNameIsRegistered(String accountName) async {
    final data = await supabase.rpc(
      'account_name_is_available',
      params: {'p_account_name': accountName.trim()},
    );
    return data != true;
  }

  static Future<int?> getCurrentAccountId() async {
    final data = await supabase.rpc('current_account_id');
    return data == null ? null : (data as num).toInt();
  }

  static Future<Map<String, dynamic>> completeAccountRegistration() async {
    final data = await supabase.rpc('complete_account_registration');
    return Map<String, dynamic>.from(data as Map);
  }

  static Future<String?> getAccountRoleName(int accountId) async {
    final data = await supabase
        .from('account')
        .select('role_info:${Const.roleId.key}(${Const.name.key})')
        .eq(Const.id.key, accountId)
        .isFilter(Const.deletedAt.key, null)
        .maybeSingle();
    final roleInfo = data?['role_info'] as Map<String, dynamic>?;
    return roleInfo?[Const.name.key];
  }

  static Future<String?> getProfileRoleName({
    required int profileId,
    required int accountId,
  }) async {
    final data = await supabase
        .from('profiles')
        .select('role_info:${Const.roleId.key}(${Const.name.key})')
        .eq(Const.id.key, profileId)
        .eq(Const.accountId.key, accountId)
        .isFilter(Const.deletedAt.key, null)
        .maybeSingle();
    final roleInfo = data?['role_info'] as Map<String, dynamic>?;
    return roleInfo?[Const.name.key];
  }

  static Future<String> getRoles() async {
    var lastSynced = await KeyValue.getValue(KeyValueEnum.role.key);
    var newLastSynced = lastSynced;
    final data = await supabase.from('roles').select('*');
    newLastSynced = _nextSyncCursor(lastSynced!, data);

    List<Insertable<Role>> rolesBatch = [];
    ProgressFraction progress = ProgressFraction(0, data.length, "Roles");
    Singleton().addAndUpdate(progress);

    for (int i = 0; i < data.length; i++) {
      var role = data[i];
      rolesBatch.add(RolesCompanion.insert(
        id: Value(role[Const.id.key]),
        name: role[Const.name.key],
        createdAt: DateTime.parse(role[Const.createdAt.key]),
        createdBy: role[Const.createdBy.key],
        updatedAt: DateTime.parse(role[Const.updatedAt.key]),
        updatedBy: role[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(role[Const.deletedAt.key] ?? "")),
        deletedBy: Value(role[Const.deletedBy.key]),
      ));

      progress.synced += 1;
      Singleton().updateNotifier();

      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleRoles(rolesBatch);
    return newLastSynced;
  }

  static Future<int?> getMainProfileIdForAccount(int accountId) async {
    final data = await supabase
        .from('profiles')
        .select(Const.id.key)
        .eq(Const.accountId.key, accountId)
        .eq(Const.name.key, 'main')
        .isFilter(Const.deletedAt.key, null)
        .maybeSingle();
    return data?[Const.id.key];
  }

  static Future<String> getProfiles() async {
    final lastSynced = await KeyValue.getValue(KeyValueEnum.profile.key);
    final data = await supabase.from('profiles').select('*');
    final batch = <Insertable<Profile>>[];
    final progress = ProgressFraction(0, data.length, 'Profiles');
    Singleton().addAndUpdate(progress);

    for (final profile in data) {
      batch.add(ProfilesCompanion.insert(
        id: Value(profile[Const.id.key]),
        accountId: profile[Const.accountId.key],
        name: profile[Const.name.key],
        roleId: profile[Const.roleId.key],
        createdAt: DateTime.parse(profile[Const.createdAt.key]),
        createdBy: profile[Const.createdBy.key],
        updatedAt: DateTime.parse(profile[Const.updatedAt.key]),
        updatedBy: profile[Const.updatedBy.key],
        deletedAt: Value(
          DateTime.tryParse(profile[Const.deletedAt.key] ?? ''),
        ),
        deletedBy: Value(profile[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleProfiles(batch);
    final idsByAccount = <int, Set<int>>{};
    for (final profile in data) {
      final accountId = (profile[Const.accountId.key] as num).toInt();
      final profileId = (profile[Const.id.key] as num).toInt();
      idsByAccount.putIfAbsent(accountId, () => <int>{}).add(profileId);
    }
    final activeAccountId = currentAccount;
    if (activeAccountId != null) {
      idsByAccount.putIfAbsent(activeAccountId, () => <int>{});
    }
    for (final entry in idsByAccount.entries) {
      await Singleton().getDatabase().retainRemoteProfilesForAccount(
            entry.key,
            entry.value,
          );
    }
    return _nextSyncCursor(lastSynced!, data);
  }

  static Future<List<Map<String, dynamic>>> getProfilesForAccount(
      int accountId) async {
    try {
      await refreshProfiles();
    } catch (error) {
      logger.w('Could not refresh profiles; using the offline cache: $error');
    }
    return Singleton().getDatabase().getProfilesForAccount(accountId);
  }

  static Future<String> getAllRecipes() async {
    final (rows, cursor) =
        await _changedRows('recipe', KeyValueEnum.recipe, orderBy: 'id');
    final recipes = await _convertRows('Recipes', rows, (row, index) async {
      final image = row[Const.image.key]?.toString().trim() ?? '';
      await _cacheImageIfWanted(
        url: image,
        ownerId: row[Const.id.key],
        index: index,
        limit: Environment.numberOfRecipeImagesToDownload,
        folder: Const.recipeImagesFolderName.key,
      );
      return RecipesCompanion.insert(
        id: Value(row[Const.id.key]),
        title: row[Const.title.key],
        image: Value(image.isEmpty ? null : image),
        description: Value(row[Const.description.key]),
        notes: Value(row[Const.notes.key]),
        totalTimeMinutes: Value(row[Const.totalTimeMinutes.key]),
        servings: Value(row[Const.servings.key]),
        revision: Value(row[Const.revision.key] ?? 1),
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      );
    });
    await Singleton().getDatabase().insertMultipleRecipes(recipes);
    await _reconcileRemoteRecipeDeletions();
    return cursor;
  }

  /// Downloads [url] into the local media folder of [id], replacing an older
  /// image of the same owner. Network problems are logged and ignored.
  static Future<void> _downloadImages({
    required int id,
    required String url,
    required String folderName,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return;
    try {
      final folder =
          await AppUtil.createFolderInAppDocDir('$id', folderName);
      final target = File(join(folder, AppUtil.getFileName(url)));
      if (await target.exists()) return;

      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode ~/ 100 != 2) {
        logger.w('Image download failed (${response.statusCode}): $url');
        return;
      }
      await AppUtil.deleteFolderContent(folder);
      await target.writeAsBytes(response.bodyBytes, flush: true);
    } catch (error) {
      logger.w('Skipped image download: $error');
    }
  }

  static Future<String> getAllRecipeSteps() async {
    final (rows, cursor) = await _changedRows('recipe_step', KeyValueEnum.steps);
    final steps = await _convertRows('Recipe steps', rows, (row, index) async {
      final image = row[Const.image.key]?.toString().trim() ?? '';
      await _cacheImageIfWanted(
        url: image,
        ownerId: row[Const.id.key],
        index: index,
        limit: Environment.numberOfStepImagesToDownload,
        folder: Const.recipeStepsImagesFolderName.key,
      );
      return RecipeStepsCompanion.insert(
        id: Value(row[Const.id.key]),
        recipeId: row[Const.recipeId.key],
        stepNr: row[Const.stepNr.key],
        description: row[Const.description.key],
        image: Value(image.isEmpty ? null : image),
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      );
    });
    await Singleton().getDatabase().insertMultipleRecipeSteps(steps);
    return cursor;
  }

  static Future<String> getAllIngredients() async {
    var lastSynced = await KeyValue.getValue(KeyValueEnum.ingredient.key);
    var newLastSynced = lastSynced;

    final data = await supabase
        .from('ingredient')
        .select('*')
        .gt('updated_at', lastSynced!);
    newLastSynced = _nextSyncCursor(lastSynced, data);

    ProgressFraction progress = ProgressFraction(0, data.length, "Ingredients");
    Singleton().addAndUpdate(progress);

    List<Insertable<Ingredient>> ingredientBatch = [];
    for (int i = 0; i < data.length; i++) {
      final ingredient = data[i];
      ingredientBatch.add(IngredientsCompanion.insert(
        id: Value(ingredient[Const.id.key]),
        name: ingredient[Const.name.key],
        shoppingCategoryCode: Value(ingredient[Const.shoppingCategoryCode.key]),
        createdAt: DateTime.parse(ingredient[Const.createdAt.key]),
        createdBy: ingredient[Const.createdBy.key],
        updatedAt: DateTime.parse(ingredient[Const.updatedAt.key]),
        updatedBy: ingredient[Const.updatedBy.key],
        deletedAt:
            Value(DateTime.tryParse(ingredient[Const.deletedAt.key] ?? "")),
        deletedBy: Value(ingredient[Const.deletedBy.key]),
      ));

      progress.synced += 1;
      Singleton().updateNotifier();

      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleIngredients(ingredientBatch);
    return newLastSynced;
  }

  static Future<String> getMeasurementUnits() async {
    var lastSynced = await KeyValue.getValue(KeyValueEnum.unit.key);
    var newLastSynced = lastSynced;
    final data = await supabase
        .from('unit')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced!);
    newLastSynced = _nextSyncCursor(lastSynced, data);

    final progress = ProgressFraction(0, data.length, 'Units');
    Singleton().addAndUpdate(progress);
    final unitBatch = <Insertable<MeasurementUnit>>[];
    for (final unit in data) {
      unitBatch.add(MeasurementUnitsCompanion.insert(
        code: unit[Const.code.key],
        nameEn: unit[Const.nameEn.key],
        nameDe: unit[Const.nameDe.key],
        sortOrder: unit[Const.sortOrder.key],
        selectable: unit[Const.selectable.key],
        createdAt: DateTime.parse(unit[Const.createdAt.key]),
        createdBy: unit[Const.createdBy.key],
        updatedAt: DateTime.parse(unit[Const.updatedAt.key]),
        updatedBy: unit[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(unit[Const.deletedAt.key] ?? '')),
        deletedBy: Value(unit[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleMeasurementUnits(unitBatch);
    return newLastSynced;
  }

  static Future<String> getAllRecipeIngredients() async {
    var lastSynced = await KeyValue.getValue(KeyValueEnum.recipeIngredient.key);
    var newLastSynced = lastSynced;

    final data = await supabase
        .from('recipe_ingredient')
        .select('*')
        .gt('updated_at', lastSynced!);
    newLastSynced = _nextSyncCursor(lastSynced, data);

    ProgressFraction progress =
        ProgressFraction(0, data.length, "Recipe ingredients");
    Singleton().addAndUpdate(progress);

    List<Insertable<RecipeIngredient>> recipeIngredientBatch = [];
    for (int i = 0; i < data.length; i++) {
      final ingredient = data[i];
      recipeIngredientBatch.add(RecipeIngredientsCompanion.insert(
        recipeId: ingredient[Const.recipeId.key],
        ingredientId: ingredient[Const.ingredientId.key],
        amount: Value(
          (ingredient[Const.amount.key] as num?)?.toDouble(),
        ),
        unit: Value(ingredient[Const.unit.key]?.toString()),
        quantityNote: Value(
          ingredient[Const.quantityNote.key]?.toString(),
        ),
        sectionName: Value(
          ingredient[Const.sectionName.key]?.toString(),
        ),
        sortOrder: Value(
          (ingredient[Const.sortOrder.key] as num?)?.toInt() ?? i,
        ),
        createdAt: DateTime.parse(ingredient[Const.createdAt.key]),
        createdBy: ingredient[Const.createdBy.key],
        updatedAt: DateTime.parse(ingredient[Const.updatedAt.key]),
        updatedBy: ingredient[Const.updatedBy.key],
        deletedAt:
            Value(DateTime.tryParse(ingredient[Const.deletedAt.key] ?? "")),
        deletedBy: Value(ingredient[Const.deletedBy.key]),
      ));

      progress.synced += 1;
      Singleton().updateNotifier();

      checkCancellation();
    }
    await Singleton()
        .getDatabase()
        .insertMultipleRecipeIngredients(recipeIngredientBatch);
    return newLastSynced;
  }

  static Future<String> getAllRecipeStepIngredients() async {
    var lastSynced =
        await KeyValue.getValue(KeyValueEnum.recipeStepIngredient.key);
    var newLastSynced = lastSynced;

    final data = await supabase
        .from('recipe_step_ingredient')
        .select('*')
        .gt('updated_at', lastSynced!);
    newLastSynced = _nextSyncCursor(lastSynced, data);

    ProgressFraction progress =
        ProgressFraction(0, data.length, "Step ingredients");
    Singleton().addAndUpdate(progress);

    List<Insertable<RecipeStepIngredient>> stepIngredientBatch = [];
    for (int i = 0; i < data.length; i++) {
      final ingredient = data[i];
      stepIngredientBatch.add(RecipeStepIngredientsCompanion.insert(
        recipeStepId: ingredient[Const.recipeStepId.key],
        ingredientId: ingredient[Const.ingredientId.key],
        createdAt: DateTime.parse(ingredient[Const.createdAt.key]),
        createdBy: ingredient[Const.createdBy.key],
        updatedAt: DateTime.parse(ingredient[Const.updatedAt.key]),
        updatedBy: ingredient[Const.updatedBy.key],
        deletedAt:
            Value(DateTime.tryParse(ingredient[Const.deletedAt.key] ?? "")),
        deletedBy: Value(ingredient[Const.deletedBy.key]),
      ));

      progress.synced += 1;
      Singleton().updateNotifier();

      checkCancellation();
    }
    await Singleton()
        .getDatabase()
        .insertMultipleRecipeStepIngredients(stepIngredientBatch);
    return newLastSynced;
  }

  static Future<String> getAllCategories() async {
    final (rows, cursor) =
        await _changedRows('category', KeyValueEnum.category);
    final categories = await _convertRows(
      'Categories',
      rows,
      (row, _) async => CategoriesCompanion.insert(
        id: Value(row[Const.id.key]),
        name: row[Const.name.key],
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      ),
    );
    await Singleton().getDatabase().insertMultipleCategories(categories);
    return cursor;
  }

  /// Downloads which recipe/step each account last opened. Local changes are
  /// uploaded first so they are not overwritten by older server data.
  static Future<String> getHistory() async {
    final (rows, cursor) = await _changedRows('history', KeyValueEnum.history);
    await DriftToSupabase.uploadHistory(rows);
    final db = Singleton().getDatabase();
    await _convertRows(
      'History',
      rows,
      (row, _) => db.createOrUpdateHistory(HistoriesCompanion.insert(
        accountId: row[Const.accountId.key],
        recipeId: row[Const.recipeId.key],
        stepNr: Value(row[Const.stepNr.key]),
        open: row[Const.open.key],
        additionalData: Value(jsonEncode(row[Const.additionalData.key])),
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      )),
    );
    return cursor;
  }

  static Future<String> getRecipesCategories() async {
    final (rows, cursor) =
        await _changedRows('recipe_category', KeyValueEnum.recipeCategory);
    final links = await _convertRows(
      'Recipe-Category',
      rows,
      (row, _) async => RecipesCategoriesCompanion.insert(
        recipeId: row[Const.recipeId.key],
        categoryId: row[Const.categoryId.key],
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      ),
    );
    await Singleton().getDatabase().insertMultipleRecipeCategories(links);
    return cursor;
  }

  static Future<String> getComments() async {
    final (rows, cursor) = await _changedRows('comment', KeyValueEnum.comment);
    final db = Singleton().getDatabase();
    await _convertRows(
      'Comments',
      rows,
      (row, _) => db.createOrUpdateComment(CommentsCompanion.insert(
        id: Value(row[Const.id.key]),
        recipeId: row[Const.recipeId.key],
        accountId: row[Const.accountId.key],
        message: row[Const.message.key],
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      )),
    );
    return cursor;
  }

  /// Public account data comes from an RPC because the table itself is
  /// protected by row-level security.
  static Future<String> getAccounts() async {
    final since =
        await KeyValue.getValue(KeyValueEnum.account.key) ?? _initialSyncCursor;
    final rows = await supabase.rpc('get_public_accounts') as List<dynamic>;
    final accounts = await _convertRows(
      'Accounts',
      rows,
      (row, _) async => AccountsCompanion.insert(
        id: Value(row[Const.id.key]),
        accountName: row[Const.accountName.key],
        profileImage: Value(row[Const.profileImage.key]),
        bio: Value(row[Const.bio.key]),
        roleId: row[Const.roleId.key],
        hostCode: row[Const.hostCode.key] ?? '',
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      ),
    );
    await Singleton().getDatabase().insertMultipleAccounts(accounts);
    return _nextSyncCursor(since, rows);
  }

  static Future<String> getAccountFollows() async {
    var lastSynced = await KeyValue.getValue(KeyValueEnum.accountFollow.key);
    var newLastSynced = lastSynced;
    final data = await supabase
        .from('account_follow')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced!);
    newLastSynced = _nextSyncCursor(lastSynced, data);

    final progress = ProgressFraction(0, data.length, 'Account Follows');
    Singleton().addAndUpdate(progress);
    final followsBatch = <Insertable<AccountFollow>>[];

    for (final follow in data) {
      followsBatch.add(AccountFollowsCompanion.insert(
        followerAccountId: follow[Const.followerAccountId.key],
        followedAccountId: follow[Const.followedAccountId.key],
        createdAt: DateTime.parse(follow[Const.createdAt.key]),
        createdBy: follow[Const.createdBy.key],
        updatedAt: DateTime.parse(follow[Const.updatedAt.key]),
        updatedBy: follow[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(follow[Const.deletedAt.key] ?? '')),
        deletedBy: Value(follow[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleAccountFollows(followsBatch);
    return newLastSynced;
  }

  static Future<String> getAccountFriends() async {
    final lastSynced = await KeyValue.getValue(KeyValueEnum.accountFriend.key);
    final data = await supabase
        .from('account_friend')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced!);
    final progress = ProgressFraction(0, data.length, 'Friends');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<AccountFriend>>[];
    for (final friend in data) {
      batch.add(AccountFriendsCompanion.insert(
        firstAccountId: friend[Const.firstAccountId.key],
        secondAccountId: friend[Const.secondAccountId.key],
        requestedBy: friend[Const.requestedBy.key],
        status: Value(friend[Const.invitationStatus.key] ?? 'pending'),
        createdAt: DateTime.parse(friend[Const.createdAt.key]),
        createdBy: friend[Const.createdBy.key],
        updatedAt: DateTime.parse(friend[Const.updatedAt.key]),
        updatedBy: friend[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(friend[Const.deletedAt.key] ?? '')),
        deletedBy: Value(friend[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleAccountFriends(batch);
    return _nextSyncCursor(lastSynced, data);
  }

  static Future<String> getChatConversations() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.chatConversation);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    final data = await supabase
        .from('chat_conversation')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    final progress = ProgressFraction(0, data.length, 'Chats');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ChatConversation>>[];
    for (final item in data) {
      batch.add(ChatConversationsCompanion.insert(
        firstAccountId: item[Const.firstAccountId.key],
        secondAccountId: item[Const.secondAccountId.key],
        createdAt: DateTime.parse(item[Const.createdAt.key]),
        createdBy: item[Const.createdBy.key],
        updatedAt: DateTime.parse(item[Const.updatedAt.key]),
        updatedBy: item[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(item[Const.deletedAt.key] ?? '')),
        deletedBy: Value(item[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleChatConversations(batch);
    final nextCursor = _nextSyncCursor(lastSynced, data);
    await KeyValue.setNewValue(cursorKey, nextCursor);
    return nextCursor;
  }

  static Future<String> getChatMessages() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.chatMessage);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    final data = await supabase
        .from('chat_message')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    final progress = ProgressFraction(0, data.length, 'Messages');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ChatMessage>>[];
    for (final item in data) {
      batch.add(ChatMessagesCompanion.insert(
        id: Value(item[Const.id.key]),
        firstAccountId: item[Const.firstAccountId.key],
        secondAccountId: item[Const.secondAccountId.key],
        senderAccountId: item[Const.senderAccountId.key],
        message: Value(item[Const.message.key]),
        recipeId: Value(item[Const.recipeId.key]),
        recipeTitleSnapshot: Value(
          item[Const.recipeTitleSnapshot.key],
        ),
        shoppingListId: Value(item[Const.shoppingListId.key]),
        shoppingListNameSnapshot: Value(
          item[Const.shoppingListNameSnapshot.key],
        ),
        replyToMessageId: Value(item[Const.replyToMessageId.key]),
        replyMessageSnapshot: Value(
          item[Const.replyMessageSnapshot.key],
        ),
        readAt: Value(
          DateTime.tryParse(item['read_at']?.toString() ?? ''),
        ),
        createdAt: DateTime.parse(item[Const.createdAt.key]),
        createdBy: item[Const.createdBy.key],
        updatedAt: DateTime.parse(item[Const.updatedAt.key]),
        updatedBy: item[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(item[Const.deletedAt.key] ?? '')),
        deletedBy: Value(item[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleChatMessages(batch);
    final nextCursor = _nextSyncCursor(lastSynced, data);
    await KeyValue.setNewValue(cursorKey, nextCursor);
    return nextCursor;
  }

  static Future<String> getChatMessageReactions() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.chatMessageReaction);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    final data = await supabase
        .from('chat_message_reaction')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    final progress = ProgressFraction(0, data.length, 'Reactions');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ChatMessageReaction>>[];
    for (final item in data) {
      batch.add(ChatMessageReactionsCompanion.insert(
        messageId: item['message_id'],
        accountId: item[Const.accountId.key],
        reaction: item[Const.reaction.key],
        createdAt: DateTime.parse(item[Const.createdAt.key]),
        createdBy: item[Const.createdBy.key],
        updatedAt: DateTime.parse(item[Const.updatedAt.key]),
        updatedBy: item[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(item[Const.deletedAt.key] ?? '')),
        deletedBy: Value(item[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleChatMessageReactions(batch);
    final nextCursor = _nextSyncCursor(lastSynced, data);
    await KeyValue.setNewValue(cursorKey, nextCursor);
    return nextCursor;
  }

  static Future<String> getRecipeLikes() async {
    final lastSynced = await KeyValue.getValue(KeyValueEnum.recipeLike.key);
    final data = await supabase
        .from('recipe_like')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced!);
    final newLastSynced = _nextSyncCursor(lastSynced, data);

    final progress = ProgressFraction(0, data.length, 'Recipe Likes');
    Singleton().addAndUpdate(progress);
    final likes = <Insertable<RecipeLike>>[];

    for (final like in data) {
      likes.add(RecipeLikesCompanion.insert(
        accountId: like[Const.accountId.key],
        recipeId: like[Const.recipeId.key],
        createdAt: DateTime.parse(like[Const.createdAt.key]),
        createdBy: like[Const.createdBy.key],
        updatedAt: DateTime.parse(like[Const.updatedAt.key]),
        updatedBy: like[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(like[Const.deletedAt.key] ?? '')),
        deletedBy: Value(like[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleRecipeLikes(likes);
    return newLastSynced;
  }

  static Future<String> getShoppingLists() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.shoppingList);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    var data = await supabase
        .from('shopping_list')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    final visibleIds = await _getVisibleRemoteIds('shopping_list');
    data = await _includeMissingVisibleRows(
      tableName: 'shopping_list',
      changedRows: data,
      visibleIds: visibleIds,
      localIds: await Singleton().getDatabase().getShoppingListIds(),
    );
    final newLastSynced = _nextSyncCursor(lastSynced, data);
    data = await _excludePendingLocalRows('shopping_list_upsert', data);
    final progress = ProgressFraction(0, data.length, 'Shopping lists');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ShoppingList>>[];

    for (final list in data) {
      batch.add(ShoppingListsCompanion.insert(
        id: Value(list[Const.id.key]),
        accountId: list[Const.accountId.key],
        name: list[Const.name.key],
        createdAt: DateTime.parse(list[Const.createdAt.key]),
        createdBy: list[Const.createdBy.key],
        updatedAt: DateTime.parse(list[Const.updatedAt.key]),
        updatedBy: list[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(list[Const.deletedAt.key] ?? '')),
        deletedBy: Value(list[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleShoppingLists(batch);
    await Singleton().getDatabase().retainAccessibleShoppingLists(visibleIds);
    await KeyValue.setNewValue(cursorKey, newLastSynced);
    return newLastSynced;
  }

  static Future<String> getShoppingListMembers() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.shoppingListMember);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    final data = await supabase
        .from('shopping_list_member')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    final progress = ProgressFraction(0, data.length, 'Shopping list members');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ShoppingListMember>>[];
    for (final member in data) {
      batch.add(ShoppingListMembersCompanion.insert(
        shoppingListId: member[Const.shoppingListId.key],
        accountId: member[Const.accountId.key],
        permission: member[Const.permission.key],
        status: Value(member[Const.invitationStatus.key] ?? 'accepted'),
        createdAt: DateTime.parse(member[Const.createdAt.key]),
        createdBy: member[Const.createdBy.key],
        updatedAt: DateTime.parse(member[Const.updatedAt.key]),
        updatedBy: member[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(member[Const.deletedAt.key] ?? '')),
        deletedBy: Value(member[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleShoppingListMembers(batch);
    final nextCursor = _nextSyncCursor(lastSynced, data);
    await KeyValue.setNewValue(cursorKey, nextCursor);
    return nextCursor;
  }

  static Future<String> getShoppingCategories() async {
    final lastSynced =
        await KeyValue.getValue(KeyValueEnum.shoppingCategory.key);
    final data = await supabase
        .from('shopping_category')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced!);
    final newLastSynced = _nextSyncCursor(lastSynced, data);
    final progress = ProgressFraction(0, data.length, 'Shopping categories');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ShoppingCategory>>[];

    for (final category in data) {
      batch.add(ShoppingCategoriesCompanion.insert(
        code: category[Const.code.key],
        nameEn: category[Const.nameEn.key],
        nameDe: category[Const.nameDe.key],
        sortOrder: category[Const.sortOrder.key],
        createdAt: DateTime.parse(category[Const.createdAt.key]),
        createdBy: category[Const.createdBy.key],
        updatedAt: DateTime.parse(category[Const.updatedAt.key]),
        updatedBy: category[Const.updatedBy.key],
        deletedAt:
            Value(DateTime.tryParse(category[Const.deletedAt.key] ?? '')),
        deletedBy: Value(category[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleShoppingCategories(batch);
    return newLastSynced;
  }

  static Future<List<ShoppingCategory>> ensureShoppingCategoriesLoaded() async {
    final database = Singleton().getDatabase();
    var categories = await database.getShoppingCategories();
    if (categories.isNotEmpty) return categories;

    final data = await supabase
        .from('shopping_category')
        .select('*')
        .isFilter(Const.deletedAt.key, null)
        .order(Const.sortOrder.key);
    final batch = <Insertable<ShoppingCategory>>[];
    for (final category in data) {
      batch.add(_shoppingCategoryCompanion(category));
    }
    await database.insertMultipleShoppingCategories(batch);
    await KeyValue.setNewValue(
      KeyValueEnum.shoppingCategory.key,
      DateTime.now().toUtc().toIso8601String(),
    );
    categories = await database.getShoppingCategories();
    return categories;
  }

  static ShoppingCategoriesCompanion _shoppingCategoryCompanion(
    Map<String, dynamic> category,
  ) {
    return ShoppingCategoriesCompanion.insert(
      code: category[Const.code.key],
      nameEn: category[Const.nameEn.key],
      nameDe: category[Const.nameDe.key],
      sortOrder: category[Const.sortOrder.key],
      createdAt: DateTime.parse(category[Const.createdAt.key]),
      createdBy: category[Const.createdBy.key],
      updatedAt: DateTime.parse(category[Const.updatedAt.key]),
      updatedBy: category[Const.updatedBy.key],
      deletedAt: Value(DateTime.tryParse(category[Const.deletedAt.key] ?? '')),
      deletedBy: Value(category[Const.deletedBy.key]),
    );
  }

  static Future<String> getShoppingListSections() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.shoppingListSection);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    var data = await supabase
        .from('shopping_list_section')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    data = await _includeMissingVisibleRows(
      tableName: 'shopping_list_section',
      changedRows: data,
      visibleIds: await _getVisibleRemoteIds('shopping_list_section'),
      localIds: await Singleton().getDatabase().getShoppingListSectionIds(),
    );
    final newLastSynced = _nextSyncCursor(lastSynced, data);
    data = await _excludePendingLocalRows('shopping_list_section_upsert', data);
    final progress = ProgressFraction(0, data.length, 'Shopping list sections');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ShoppingListSection>>[];

    for (final section in data) {
      batch.add(ShoppingListSectionsCompanion.insert(
        id: Value(section[Const.id.key]),
        shoppingListId: section[Const.shoppingListId.key],
        name: section[Const.name.key],
        sortOrder: Value(section[Const.sortOrder.key] ?? 0),
        createdAt: DateTime.parse(section[Const.createdAt.key]),
        createdBy: section[Const.createdBy.key],
        updatedAt: DateTime.parse(section[Const.updatedAt.key]),
        updatedBy: section[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(section[Const.deletedAt.key] ?? '')),
        deletedBy: Value(section[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleShoppingListSections(batch);
    await KeyValue.setNewValue(cursorKey, newLastSynced);
    return newLastSynced;
  }

  static Future<String> getShoppingListItems() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.shoppingListItem);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    var data = await supabase
        .from('shopping_list_item')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    data = await _includeMissingVisibleRows(
      tableName: 'shopping_list_item',
      changedRows: data,
      visibleIds: await _getVisibleRemoteIds('shopping_list_item'),
      localIds: await Singleton().getDatabase().getShoppingListItemIds(),
    );
    final newLastSynced = _nextSyncCursor(lastSynced, data);
    data = await _excludePendingLocalRows('shopping_list_item_upsert', data);
    final progress = ProgressFraction(0, data.length, 'Shopping list items');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<ShoppingListItem>>[];

    for (final item in data) {
      batch.add(ShoppingListItemsCompanion.insert(
        id: Value(item[Const.id.key]),
        shoppingListId: item[Const.shoppingListId.key],
        sectionId: Value(item[Const.sectionId.key]),
        ingredientId: Value(item[Const.ingredientId.key]),
        name: item[Const.name.key],
        amount: Value((item[Const.amount.key] as num?)?.toDouble()),
        unit: Value(item[Const.unit.key]),
        note: Value(item[Const.note.key]),
        shoppingCategoryCode:
            Value(item[Const.shoppingCategoryCode.key] ?? 'other'),
        checked: item[Const.checked.key],
        createdAt: DateTime.parse(item[Const.createdAt.key]),
        createdBy: item[Const.createdBy.key],
        updatedAt: DateTime.parse(item[Const.updatedAt.key]),
        updatedBy: item[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(item[Const.deletedAt.key] ?? '')),
        deletedBy: Value(item[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleShoppingListItems(batch);
    await KeyValue.setNewValue(cursorKey, newLastSynced);
    return newLastSynced;
  }

  static Future<String> getMealPlanEntries() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.mealPlanEntry);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    var data = await supabase
        .from('meal_plan_entry')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    data = await _includeMissingVisibleRows(
      tableName: 'meal_plan_entry',
      changedRows: data,
      visibleIds: await _getVisibleRemoteIds('meal_plan_entry'),
      localIds: await Singleton().getDatabase().getMealPlanEntryIds(),
    );
    final newLastSynced = _nextSyncCursor(lastSynced, data);
    final progress = ProgressFraction(0, data.length, 'Meal plan entries');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<MealPlanEntry>>[];

    for (final entry in data) {
      batch.add(MealPlanEntriesCompanion.insert(
        id: Value(entry[Const.id.key]),
        mealPlanId: entry[Const.mealPlanId.key],
        plannedDate: DateTime.parse(entry[Const.plannedDate.key]),
        mealSlot: entry[Const.mealSlot.key],
        recipeId: Value(entry[Const.recipeId.key]),
        recipeTitleSnapshot: Value(
          entry[Const.recipeTitleSnapshot.key],
        ),
        customTitle: Value(entry[Const.customTitle.key]),
        note: Value(entry[Const.note.key]),
        servings: Value(entry[Const.servings.key]),
        sortOrder: Value(entry[Const.sortOrder.key] ?? 0),
        createdAt: DateTime.parse(entry[Const.createdAt.key]),
        createdBy: entry[Const.createdBy.key],
        updatedAt: DateTime.parse(entry[Const.updatedAt.key]),
        updatedBy: entry[Const.updatedBy.key],
        deletedAt: Value(
          DateTime.tryParse(entry[Const.deletedAt.key] ?? ''),
        ),
        deletedBy: Value(entry[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }

    await Singleton().getDatabase().insertMultipleMealPlanEntries(batch);
    await KeyValue.setNewValue(cursorKey, newLastSynced);
    return newLastSynced;
  }

  static Future<String> getMealPlans() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.mealPlan);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    var data = await supabase
        .from('meal_plan')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    final visibleIds = await _getVisibleRemoteIds('meal_plan');
    data = await _includeMissingVisibleRows(
      tableName: 'meal_plan',
      changedRows: data,
      visibleIds: visibleIds,
      localIds: await Singleton().getDatabase().getMealPlanIds(),
    );
    final progress = ProgressFraction(0, data.length, 'Meal plans');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<MealPlan>>[];
    for (final plan in data) {
      batch.add(MealPlansCompanion.insert(
        id: Value(plan[Const.id.key]),
        accountId: plan[Const.accountId.key],
        name: plan[Const.name.key],
        createdAt: DateTime.parse(plan[Const.createdAt.key]),
        createdBy: plan[Const.createdBy.key],
        updatedAt: DateTime.parse(plan[Const.updatedAt.key]),
        updatedBy: plan[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(plan[Const.deletedAt.key] ?? '')),
        deletedBy: Value(plan[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleMealPlans(batch);
    await Singleton().getDatabase().retainAccessibleMealPlans(visibleIds);
    final nextCursor = _nextSyncCursor(lastSynced, data);
    await KeyValue.setNewValue(cursorKey, nextCursor);
    return nextCursor;
  }

  static Future<String> getMealPlanMembers() async {
    final cursorKey = _accountCursorKey(KeyValueEnum.mealPlanMember);
    final lastSynced = await KeyValue.getValue(cursorKey) ?? _initialSyncCursor;
    final data = await supabase
        .from('meal_plan_member')
        .select('*')
        .gt(Const.updatedAt.key, lastSynced);
    final progress = ProgressFraction(0, data.length, 'Meal plan members');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<MealPlanMember>>[];
    for (final member in data) {
      batch.add(MealPlanMembersCompanion.insert(
        mealPlanId: member[Const.mealPlanId.key],
        accountId: member[Const.accountId.key],
        permission: member[Const.permission.key],
        status: Value(member[Const.invitationStatus.key] ?? 'accepted'),
        createdAt: DateTime.parse(member[Const.createdAt.key]),
        createdBy: member[Const.createdBy.key],
        updatedAt: DateTime.parse(member[Const.updatedAt.key]),
        updatedBy: member[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(member[Const.deletedAt.key] ?? '')),
        deletedBy: Value(member[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleMealPlanMembers(batch);
    final nextCursor = _nextSyncCursor(lastSynced, data);
    await KeyValue.setNewValue(cursorKey, nextCursor);
    return nextCursor;
  }

  static Future<String> getMealPlanTemplates() async {
    final lastSynced =
        await KeyValue.getValue(KeyValueEnum.mealPlanTemplate.key);
    final accountId = currentAccount;
    if (accountId == null) return lastSynced!;
    final data = await supabase
        .from('meal_plan_template')
        .select('*')
        .eq(Const.accountId.key, accountId)
        .gt(Const.updatedAt.key, lastSynced!);
    final progress = ProgressFraction(0, data.length, 'Meal plan templates');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<MealPlanTemplate>>[];
    for (final template in data) {
      batch.add(MealPlanTemplatesCompanion.insert(
        id: Value(template[Const.id.key]),
        accountId: template[Const.accountId.key],
        name: template[Const.name.key],
        createdAt: DateTime.parse(template[Const.createdAt.key]),
        createdBy: template[Const.createdBy.key],
        updatedAt: DateTime.parse(template[Const.updatedAt.key]),
        updatedBy: template[Const.updatedBy.key],
        deletedAt: Value(
          DateTime.tryParse(template[Const.deletedAt.key] ?? ''),
        ),
        deletedBy: Value(template[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton().getDatabase().insertMultipleMealPlanTemplates(batch);
    return _nextSyncCursor(lastSynced, data);
  }

  static Future<String> getMealPlanTemplateEntries() async {
    final lastSynced =
        await KeyValue.getValue(KeyValueEnum.mealPlanTemplateEntry.key);
    final accountId = currentAccount;
    if (accountId == null) return lastSynced!;
    final templates = await supabase
        .from('meal_plan_template')
        .select(Const.id.key)
        .eq(Const.accountId.key, accountId);
    final templateIds = templates
        .map<int>((template) => (template[Const.id.key] as num).toInt())
        .toList();
    if (templateIds.isEmpty) {
      Singleton().addAndUpdate(
        ProgressFraction(0, 0, 'Meal plan template entries'),
      );
      return lastSynced!;
    }
    final data = await supabase
        .from('meal_plan_template_entry')
        .select('*')
        .inFilter(Const.templateId.key, templateIds)
        .gt(Const.updatedAt.key, lastSynced!);
    final progress =
        ProgressFraction(0, data.length, 'Meal plan template entries');
    Singleton().addAndUpdate(progress);
    final batch = <Insertable<MealPlanTemplateEntry>>[];
    for (final entry in data) {
      batch.add(MealPlanTemplateEntriesCompanion.insert(
        id: Value(entry[Const.id.key]),
        templateId: entry[Const.templateId.key],
        dayOffset: entry[Const.dayOffset.key],
        mealSlot: entry[Const.mealSlot.key],
        recipeId: Value(entry[Const.recipeId.key]),
        recipeTitleSnapshot: Value(
          entry[Const.recipeTitleSnapshot.key],
        ),
        customTitle: Value(entry[Const.customTitle.key]),
        note: Value(entry[Const.note.key]),
        servings: Value(entry[Const.servings.key]),
        sortOrder: Value(entry[Const.sortOrder.key] ?? 0),
        createdAt: DateTime.parse(entry[Const.createdAt.key]),
        createdBy: entry[Const.createdBy.key],
        updatedAt: DateTime.parse(entry[Const.updatedAt.key]),
        updatedBy: entry[Const.updatedBy.key],
        deletedAt: Value(DateTime.tryParse(entry[Const.deletedAt.key] ?? '')),
        deletedBy: Value(entry[Const.deletedBy.key]),
      ));
      progress.synced += 1;
      Singleton().updateNotifier();
      checkCancellation();
    }
    await Singleton()
        .getDatabase()
        .insertMultipleMealPlanTemplateEntries(batch);
    return _nextSyncCursor(lastSynced, data);
  }

  static Future<void> refreshAccounts() async {
    final value = await getAccounts();
    await KeyValue.setNewValue(KeyValueEnum.account.key, value);
  }

  static Future<void> refreshProfiles() async {
    final value = await getProfiles();
    await KeyValue.setNewValue(KeyValueEnum.profile.key, value);
  }

  static Future<void> refreshAccountFollows() async {
    final value = await getAccountFollows();
    await KeyValue.setNewValue(KeyValueEnum.accountFollow.key, value);
  }

  static Future<void> initializeAccounts() async {
    await _runDownloadStep(KeyValueEnum.role, getRoles);
    await _runDownloadStep(KeyValueEnum.account, getAccounts);
    await _runDownloadStep(KeyValueEnum.profile, getProfiles);
    await _runDownloadStep(KeyValueEnum.accountFollow, getAccountFollows);
    await _runDownloadStep(KeyValueEnum.accountFriend, getAccountFriends);
    await refreshCurrentAccountRealtimeData();
    await _runDownloadStep(KeyValueEnum.unit, getMeasurementUnits);
  }

  static Future<void> refreshCurrentAccountRealtimeData() async {
    await refreshChatData();
    await _runDownloadStep(KeyValueEnum.shoppingList, getShoppingLists);
    await _runDownloadStep(
      KeyValueEnum.shoppingListMember,
      getShoppingListMembers,
    );
    await _runDownloadStep(KeyValueEnum.mealPlan, getMealPlans);
    await _runDownloadStep(KeyValueEnum.mealPlanMember, getMealPlanMembers);
  }

  static Future<void> refreshChatData({bool resetCursor = false}) async {
    final runningRefresh = _activeChatRefresh;
    if (runningRefresh != null) {
      await runningRefresh;
      if (!resetCursor) return;
    }

    final refresh = _refreshChatData(resetCursor: resetCursor);
    _activeChatRefresh = refresh;
    try {
      await refresh;
    } finally {
      if (identical(_activeChatRefresh, refresh)) {
        _activeChatRefresh = null;
      }
    }
  }

  static Future<void> _refreshChatData({required bool resetCursor}) async {
    if (currentAccount == null) return;
    if (resetCursor) {
      for (final cursor in const [
        KeyValueEnum.chatConversation,
        KeyValueEnum.chatMessage,
        KeyValueEnum.chatMessageReaction,
      ]) {
        await KeyValue.setNewValue(
          _accountCursorKey(cursor),
          _initialSyncCursor,
        );
      }
    }

    await getChatConversations();
    await getChatMessages();
    await getChatMessageReactions();
  }

  static Future<void> initializeSettings() =>
      _runDownloadStep(KeyValueEnum.setting, getSettings);

  static Future<String> getSettings() async {
    final (rows, cursor) = await _changedRows('setting', KeyValueEnum.setting);
    final db = Singleton().getDatabase();
    await _convertRows(
      'Settings',
      rows,
      (row, _) => db.createOrUpdateSetting(SettingsCompanion.insert(
        accountId: Value(row[Const.accountId.key]),
        language: row[Const.language.key],
        realtime: row[Const.realtime.key],
        lightmode: row[Const.lightmode.key],
        createdAt: DateTime.parse(row[Const.createdAt.key]),
        createdBy: row[Const.createdBy.key],
        updatedAt: DateTime.parse(row[Const.updatedAt.key]),
        updatedBy: row[Const.updatedBy.key],
        deletedAt: Value(_dateOrNull(row[Const.deletedAt.key])),
        deletedBy: Value(row[Const.deletedBy.key]),
      )),
    );
    return cursor;
  }

  static Future<void> waitForActiveSync() async {
    final runningSync = _activeSync;
    if (runningSync == null) return;
    try {
      await runningSync;
    } catch (_) {
      // The sync owner records and presents the error. Callers continue with
      // the cached data instead of opening a partially downloaded snapshot.
    }
  }

  static Future<bool> ensureRecipeDetailsLoaded(int recipeId) async {
    await waitForActiveSync();
    final database = Singleton().getDatabase();
    if (await database.hasCompleteRecipeGraph(recipeId)) return true;

    await sync();
    return database.hasCompleteRecipeGraph(recipeId);
  }

  /// Runs a full sync, or waits for the one already running.
  static Future<void> sync() async {
    final running = _activeSync;
    if (running != null) return running;

    final cancel = Singleton().getCancelToken();
    Singleton().setLastSyncError(null);
    final current = syncAll();
    _activeSync = current;
    try {
      await current;
    } catch (error, stackTrace) {
      if (cancel.isCancellationRequested) {
        cancel.reset();
        await KeyValue.saveSyncStatus(SyncStatus.cancelledSync);
        logger.i('Sync cancelled by the user');
      } else {
        Singleton().setLastSyncError('$error');
        await KeyValue.saveSyncStatus(SyncStatus.pendingSync);
        logger.w('Sync interrupted; local data stays usable',
            error: error, stackTrace: stackTrace);
      }
    } finally {
      _activeSync = null;
    }
  }

  static void checkCancellation() =>
      Singleton().getCancelToken().throwIfCancellationRequested();

  static Future<void> _runDownloadStep(
    KeyValueEnum key,
    Future<String> Function() download,
  ) async {
    final cursor = await download();
    await KeyValue.setNewValue(key.key, cursor);
  }

  static Future<void> syncAll() async {
    if (!Singleton().getSyncing()) {
      await DriftToSupabase.flushPendingMutations();
      final deferRecipeDownloads =
          await OfflineMutationQueue.instance.hasPendingRecipeMutations();
      final deferFriendDownloads = await OfflineMutationQueue.instance
          .hasPendingMutationsWithPrefix('account_friend_');
      final deferShoppingDownloads = await OfflineMutationQueue.instance
          .hasPendingMutationsWithPrefix('shopping_list_');
      final deferMealPlanDownloads = await OfflineMutationQueue.instance
          .hasPendingMutationsWithPrefix('meal_plan_');
      final deferChatDownloads = await OfflineMutationQueue.instance
          .hasPendingMutationsWithPrefix('chat_');
      Singleton().resetNumberOfSyncedTables();
      Singleton().resetPercentageOfSyncedEntries();
      await KeyValue.saveSyncStatus(SyncStatus.runningSync);

      final syncSteps = <Future<void> Function()>[
        () => _runDownloadStep(KeyValueEnum.role, getRoles),
        () => _runDownloadStep(KeyValueEnum.account, getAccounts),
        () => _runDownloadStep(KeyValueEnum.profile, getProfiles),
        () => _runDownloadStep(KeyValueEnum.accountFollow, getAccountFollows),
        if (!deferFriendDownloads)
          () => _runDownloadStep(
                KeyValueEnum.accountFriend,
                getAccountFriends,
              ),
        if (!deferChatDownloads)
          () => _runDownloadStep(
                KeyValueEnum.chatConversation,
                getChatConversations,
              ),
        if (!deferChatDownloads)
          () => _runDownloadStep(KeyValueEnum.chatMessage, getChatMessages),
        if (!deferChatDownloads)
          () => _runDownloadStep(
                KeyValueEnum.chatMessageReaction,
                getChatMessageReactions,
              ),
        () => _runDownloadStep(KeyValueEnum.recipeLike, getRecipeLikes),
        if (!deferShoppingDownloads)
          () => _runDownloadStep(KeyValueEnum.shoppingList, getShoppingLists),
        if (!deferShoppingDownloads)
          () => _runDownloadStep(
                KeyValueEnum.shoppingListMember,
                getShoppingListMembers,
              ),
        if (!deferShoppingDownloads)
          () => _runDownloadStep(
                KeyValueEnum.shoppingListSection,
                getShoppingListSections,
              ),
        () => _runDownloadStep(
              KeyValueEnum.shoppingCategory,
              getShoppingCategories,
            ),
        () => _runDownloadStep(KeyValueEnum.unit, getMeasurementUnits),
        if (!deferRecipeDownloads)
          () async {
            logger.i("Syncing recipes");
            await _runDownloadStep(KeyValueEnum.recipe, getAllRecipes);
          },
        if (!deferRecipeDownloads)
          () => _runDownloadStep(KeyValueEnum.steps, getAllRecipeSteps),
        () => _runDownloadStep(KeyValueEnum.ingredient, getAllIngredients),
        if (!deferShoppingDownloads)
          () => _runDownloadStep(
                KeyValueEnum.shoppingListItem,
                getShoppingListItems,
              ),
        if (!deferMealPlanDownloads)
          () => _runDownloadStep(KeyValueEnum.mealPlan, getMealPlans),
        if (!deferMealPlanDownloads)
          () => _runDownloadStep(
                KeyValueEnum.mealPlanMember,
                getMealPlanMembers,
              ),
        if (!deferMealPlanDownloads)
          () => _runDownloadStep(
                KeyValueEnum.mealPlanEntry,
                getMealPlanEntries,
              ),
        if (!deferMealPlanDownloads)
          () => _runDownloadStep(
                KeyValueEnum.mealPlanTemplate,
                getMealPlanTemplates,
              ),
        if (!deferMealPlanDownloads)
          () => _runDownloadStep(
                KeyValueEnum.mealPlanTemplateEntry,
                getMealPlanTemplateEntries,
              ),
        if (!deferRecipeDownloads)
          () => _runDownloadStep(
                KeyValueEnum.recipeIngredient,
                getAllRecipeIngredients,
              ),
        if (!deferRecipeDownloads)
          () => _runDownloadStep(
                KeyValueEnum.recipeStepIngredient,
                getAllRecipeStepIngredients,
              ),
        () => _runDownloadStep(KeyValueEnum.category, getAllCategories),
        () => _runDownloadStep(KeyValueEnum.history, getHistory),
        if (!deferRecipeDownloads)
          () => _runDownloadStep(
                KeyValueEnum.recipeCategory,
                getRecipesCategories,
              ),
        () async {
          await DriftToSupabase.uploadComments();
          final cursor = await getComments();
          await KeyValue.setNewValue(KeyValueEnum.comment.key, cursor);
        },
        () async {
          await DriftToSupabase.uploadSettings();
          final cursor = await getSettings();
          await KeyValue.setNewValue(KeyValueEnum.setting.key, cursor);
        },
      ];

      Singleton().setNumberOfSyncSteps(numberOfSyncSteps: syncSteps.length);

      for (final syncStep in syncSteps) {
        await syncStep();
        Singleton().incrementNumberOfSyncedTables();
      }

      await KeyValue.saveSyncStatus(
        deferRecipeDownloads ||
                deferShoppingDownloads ||
                deferMealPlanDownloads ||
                deferFriendDownloads ||
                deferChatDownloads
            ? SyncStatus.pendingSync
            : SyncStatus.fullSync,
      );
    }
  }
}
