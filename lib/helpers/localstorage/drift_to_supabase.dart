import 'dart:convert';

import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/localstorage/key_value.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/offline_mutation_queue.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart' as s;

class RecipeEditConflictException implements Exception {
  const RecipeEditConflictException();
}

class ShoppingListSectionNameAlreadyExistsException implements Exception {
  const ShoppingListSectionNameAlreadyExistsException(this.name);

  final String name;
}

class DriftToSupabase {
  static const String recipeImagesBucket = 'recipe-images';
  static const String accountImagesBucket = 'account-images';

  static void initializeOfflineSync() {
    OfflineMutationQueue.instance.start(
      _dispatchPendingMutation,
      onReconnect: SupabaseToDrift.sync,
      canSync: () =>
          supabase.auth.currentSession != null && currentAccount != null,
    );
  }

  static Future<void> flushPendingMutations() =>
      OfflineMutationQueue.instance.flush();

  static Future<void> _dispatchPendingMutation(
    String mutationType,
    Map<String, dynamic> payload,
  ) async {
    final isShoppingListMutation = mutationType.startsWith('shopping_list_');
    if (isShoppingListMutation) {
      _logShoppingListMutationStart(mutationType, payload);
    }
    try {
      switch (mutationType) {
        case 'account_friend_request':
          await supabase.rpc(
            'send_friend_request',
            params: {'p_friend_account_id': payload['friend_account_id']},
          );
        case 'account_friend_response':
          await supabase.rpc(
            'respond_friend_request',
            params: {
              'p_requester_account_id': payload['requester_account_id'],
              'p_accept': payload['accept'],
            },
          );
        case 'account_friend_remove':
          await supabase.rpc(
            'remove_friend',
            params: {'p_friend_account_id': payload['friend_account_id']},
          );
        case 'chat_message_send':
          await supabase.rpc(
            'send_direct_message',
            params: {
              'p_friend_account_id': payload['friend_account_id'],
              'p_message_id': payload[Const.id.key],
              'p_message': payload[Const.message.key],
              'p_recipe_id': payload[Const.recipeId.key],
              'p_recipe_title_snapshot': payload[Const.recipeTitleSnapshot.key],
              'p_shopping_list_id': payload[Const.shoppingListId.key],
              'p_shopping_list_name_snapshot':
                  payload[Const.shoppingListNameSnapshot.key],
              'p_reply_to_message_id': payload[Const.replyToMessageId.key],
              'p_reply_message_snapshot':
                  payload[Const.replyMessageSnapshot.key],
              'p_created_at': payload[Const.createdAt.key],
              'p_updated_at': payload[Const.updatedAt.key],
            },
          );
        case 'chat_reaction_set':
          await supabase.rpc(
            'set_message_reaction',
            params: {
              'p_message_id': payload['message_id'],
              'p_reaction': payload[Const.reaction.key],
              'p_updated_at': payload[Const.updatedAt.key],
            },
          );
        case 'chat_messages_read':
          await supabase.rpc(
            'mark_chat_messages_read',
            params: {
              'p_friend_account_id': payload['friend_account_id'],
            },
          );
        case 'push_notification_send':
          await _sendQueuedPushNotification(payload);
        case 'meal_plan_entry_upsert':
          await _upsertRecipeReferenceLastWriteWins(
            'meal_plan_entry',
            payload,
          );
        case 'meal_plan_upsert':
          await _syncOwnedResource('sync_meal_plan', payload);
        case 'meal_plan_member_upsert':
          await _ensureMealPlanUploaded(
            payload[Const.mealPlanId.key] as int,
          );
          await supabase.rpc(
            'set_meal_plan_member',
            params: {
              'p_meal_plan_id': payload[Const.mealPlanId.key],
              'p_member_account_id': payload[Const.accountId.key],
              'p_permission': payload[Const.permission.key],
              'p_remove': payload[Const.deletedAt.key] != null,
            },
          );
        case 'meal_plan_invitation_response':
          await supabase.rpc(
            'respond_meal_plan_invitation',
            params: {
              'p_meal_plan_id': payload[Const.mealPlanId.key],
              'p_accept': payload['accept'],
            },
          );
        case 'meal_plan_template_upsert':
          await _upsertLastWriteWins('meal_plan_template', payload);
        case 'meal_plan_template_entry_upsert':
          await _upsertRecipeReferenceLastWriteWins(
            'meal_plan_template_entry',
            payload,
          );
        case 'shopping_list_upsert':
          await _syncOwnedResource('sync_shopping_list', payload);
        case 'shopping_list_section_upsert':
          await _ensureShoppingListAvailableForChild(
            payload[Const.shoppingListId.key] as int,
          );
          await _upsertLastWriteWins('shopping_list_section', payload);
        case 'shopping_list_item_upsert':
          await _upsertLastWriteWins('shopping_list_item', payload);
        case 'shopping_list_member_upsert':
          await _ensureShoppingListUploaded(
            payload[Const.shoppingListId.key] as int,
          );
          await supabase.rpc(
            'set_shopping_list_member',
            params: {
              'p_shopping_list_id': payload[Const.shoppingListId.key],
              'p_member_account_id': payload[Const.accountId.key],
              'p_permission': payload[Const.permission.key],
              'p_remove': payload[Const.deletedAt.key] != null,
            },
          );
        case 'shopping_list_invitation_response':
          await supabase.rpc(
            'respond_shopping_list_invitation',
            params: {
              'p_shopping_list_id': payload[Const.shoppingListId.key],
              'p_accept': payload['accept'],
            },
          );
        case 'ingredient_category_update':
          await supabase.from('ingredient').update({
            Const.shoppingCategoryCode.key:
                payload[Const.shoppingCategoryCode.key],
            Const.updatedAt.key: payload[Const.updatedAt.key],
            Const.updatedBy.key: payload[Const.updatedBy.key],
          }).eq(Const.id.key, payload[Const.id.key]);
        case 'recipe_create':
          await _uploadQueuedRecipe(payload, create: true);
        case 'recipe_update':
          await _uploadQueuedRecipe(payload, create: false);
        default:
          throw UnsupportedError('Unknown pending mutation: $mutationType');
      }
      if (isShoppingListMutation) {
        logger.i(
          'Shopping-list upload succeeded: '
          '${_shoppingListMutationSummary(mutationType, payload)}',
        );
      }
    } on s.PostgrestException catch (error) {
      if (isShoppingListMutation) {
        await _logShoppingListMutationFailure(mutationType, payload, error);
      }
      if (error.code == 'P0001' && error.message.endsWith('_owner_required')) {
        throw OfflineMutationConflictException(error.message);
      }
      if (error.code != '42501') rethrow;
      await _logRlsDiagnostics(mutationType, payload, error);
      if (mutationType == 'recipe_create' ||
          mutationType == 'recipe_update' ||
          mutationType.startsWith('account_friend_') ||
          mutationType.startsWith('chat_') ||
          mutationType.startsWith('meal_plan_') ||
          mutationType.startsWith('shopping_list_')) {
        throw OfflineMutationConflictException(error.message);
      }
      await _discardRejectedMutation(mutationType);
      throw OfflineMutationRejectedException(error.message);
    } catch (error, stackTrace) {
      if (isShoppingListMutation) {
        logger.w(
          'Shopping-list upload failed before Supabase returned a database '
          'response: ${_shoppingListMutationSummary(mutationType, payload)}',
          error: error,
          stackTrace: stackTrace,
        );
      }
      rethrow;
    }
  }

  static void _logShoppingListMutationStart(
    String mutationType,
    Map<String, dynamic> payload,
  ) {
    logger.i(
      'Shopping-list upload started: '
      '${_shoppingListMutationSummary(mutationType, payload)}',
    );
  }

  static String _shoppingListMutationSummary(
    String mutationType,
    Map<String, dynamic> payload,
  ) {
    final operation = switch (mutationType) {
      'shopping_list_upsert' => 'RPC sync_shopping_list (create/update list)',
      'shopping_list_item_upsert' =>
        'REST shopping_list_item (create/update item)',
      'shopping_list_section_upsert' =>
        'REST shopping_list_section (create/update section)',
      'shopping_list_member_upsert' =>
        'RPC sync_shopping_list, then RPC set_shopping_list_member',
      'shopping_list_invitation_response' =>
        'RPC respond_shopping_list_invitation',
      _ => mutationType,
    };
    final rowId = payload[Const.id.key];
    final listId = mutationType == 'shopping_list_upsert'
        ? rowId
        : payload[Const.shoppingListId.key];
    return 'type=$mutationType, operation=$operation, mutation='
        '${payload['_mutation_id']}, entity=${payload['_entity_key']}, '
        'localAccount=$currentAccount, listId=$listId, rowId=$rowId, '
        'listOwner=${payload[Const.accountId.key]}, '
        'createdBy=${payload[Const.createdBy.key]}, '
        'updatedBy=${payload[Const.updatedBy.key]}, '
        'updatedAt=${payload[Const.updatedAt.key]}, '
        'deleted=${payload[Const.deletedAt.key] != null}, '
        'localOriginId=${listId is int && listId < 0}';
  }

  static Future<void> _logShoppingListMutationFailure(
    String mutationType,
    Map<String, dynamic> payload,
    s.PostgrestException error,
  ) async {
    final session = supabase.auth.currentSession;
    final remoteAccountId = await _diagnosticRpc('current_account_id');
    final remoteRole = await _diagnosticRpc('current_account_role');
    final remoteCanWrite = await _diagnosticRpc('current_account_can_write');
    final listId = mutationType == 'shopping_list_upsert'
        ? payload[Const.id.key]
        : payload[Const.shoppingListId.key];
    final remoteList = await _diagnosticShoppingList(listId);
    final likelyCause = _shoppingListFailureCause(error);

    logger.w(
      'Shopping-list upload rejected.\n'
      'Request: ${_shoppingListMutationSummary(mutationType, payload)}\n'
      'Supabase error: code=${error.code}, message=${error.message}, '
      'details=${error.details}, hint=${error.hint}\n'
      'Authenticated user: id=${session?.user.id}, '
      'sessionExpired=${session?.isExpired}\n'
      'Database identity: account=$remoteAccountId, role=$remoteRole, '
      'canWrite=$remoteCanWrite\n'
      'Existing remote list with this ID: $remoteList\n'
      'Likely cause: $likelyCause',
      error: error,
    );
  }

  static Future<Object?> _diagnosticRpc(String functionName) async {
    try {
      return await supabase.rpc(functionName);
    } catch (error) {
      return 'unavailable ($error)';
    }
  }

  static Future<Object?> _diagnosticShoppingList(Object? listId) async {
    if (listId == null) return 'not checked (missing list ID)';
    try {
      return await supabase
          .from('shopping_list')
          .select(
            '${Const.id.key}, ${Const.accountId.key}, ${Const.createdBy.key}, '
            '${Const.updatedBy.key}, ${Const.updatedAt.key}, '
            '${Const.deletedAt.key}',
          )
          .eq(Const.id.key, listId)
          .maybeSingle();
    } catch (error) {
      return 'lookup failed ($error)';
    }
  }

  static String _shoppingListFailureCause(s.PostgrestException error) {
    if (error.code == 'PGRST202' ||
        error.message.contains('function public.sync_shopping_list')) {
      return 'The sync_shopping_list RPC is not installed in this Supabase '
          'project. Run supabase/sql/supabase_owned_plan_list_sync.sql in the Supabase SQL '
          'Editor.';
    }
    if (error.code == '42501') {
      return 'Supabase RLS or a permission check rejected the supplied row. '
          'Compare the database identity and ownership fields above.';
    }
    if (error.code == 'P0001') {
      return 'A server-side sync function rejected one of its ownership or '
          'validation checks.';
    }
    if (error.code == '23503') {
      return 'A referenced account, shopping list, ingredient, or category '
          'does not exist remotely yet.';
    }
    if (error.code == '23505') {
      return 'A remote row already uses a value covered by a unique '
          'constraint.';
    }
    return 'Supabase returned an unclassified database error; the complete '
        'code, details, and hint are shown above.';
  }

  static Future<void> _logRlsDiagnostics(
    String mutationType,
    Map<String, dynamic> payload,
    s.PostgrestException error,
  ) async {
    try {
      final remoteAccountId = await supabase.rpc('current_account_id');
      final remoteRole = await supabase.rpc('current_account_role');
      logger.w(
        'RLS rejected $mutationType: local account $currentAccount, '
        'authenticated account $remoteAccountId, role $remoteRole, '
        'row id ${payload[Const.id.key]}, '
        'row account ${payload[Const.accountId.key]}, '
        'created by ${payload[Const.createdBy.key]}, '
        'updated by ${payload[Const.updatedBy.key]}',
        error: error,
      );
    } catch (diagnosticError) {
      logger.w(
        'RLS rejected $mutationType and identity diagnostics failed',
        error: diagnosticError,
      );
    }
  }

  static Future<void> _discardRejectedMutation(String mutationType) async {
    const initialCursor = '1900-03-01T00:00:00.000';
    switch (mutationType) {
      case 'ingredient_category_update':
        await KeyValue.setNewValue(
          KeyValueEnum.ingredient.key,
          initialCursor,
        );
    }
  }

  static Future<void> _upsertLastWriteWins(
    String table,
    Map<String, dynamic> payload,
  ) async {
    final id = payload[Const.id.key];
    final localUpdatedAt = DateTime.parse(
      payload[Const.updatedAt.key].toString(),
    ).toUtc();
    final remote = await supabase
        .from(table)
        .select(Const.updatedAt.key)
        .eq(Const.id.key, id)
        .maybeSingle();
    final remoteUpdatedAt = DateTime.tryParse(
      remote?[Const.updatedAt.key]?.toString() ?? '',
    )?.toUtc();
    final data = _withoutQueueMetadata(payload);
    if (remote == null) {
      await supabase.from(table).insert(data);
      return;
    }
    if (remoteUpdatedAt != null && !localUpdatedAt.isAfter(remoteUpdatedAt)) {
      return;
    }
    data.remove(Const.id.key);
    await supabase.from(table).update(data).eq(Const.id.key, id);
  }

  static Future<void> _upsertRecipeReferenceLastWriteWins(
    String table,
    Map<String, dynamic> payload,
  ) async {
    try {
      await _upsertLastWriteWins(table, payload);
    } on s.PostgrestException catch (error) {
      final recipeReferenceFailed = error.code == '23503' &&
          (error.message.contains('recipe') ||
              error.details.toString().contains('recipe'));
      final savedTitle =
          _nullableTrimmed(payload[Const.recipeTitleSnapshot.key]?.toString());
      if (!recipeReferenceFailed ||
          payload[Const.recipeId.key] == null ||
          savedTitle == null) {
        rethrow;
      }
      final unavailableRecipePayload = Map<String, dynamic>.from(payload)
        ..[Const.recipeId.key] = null;
      await _upsertLastWriteWins(table, unavailableRecipePayload);
    }
  }

  static Future<void> _syncOwnedResource(
    String functionName,
    Map<String, dynamic> payload,
  ) =>
      supabase.rpc(
        functionName,
        params: {
          'p_id': payload[Const.id.key],
          'p_account_id': payload[Const.accountId.key],
          'p_name': payload[Const.name.key],
          'p_created_at': payload[Const.createdAt.key],
          'p_created_by': payload[Const.createdBy.key],
          'p_updated_at': payload[Const.updatedAt.key],
          'p_updated_by': payload[Const.updatedBy.key],
          'p_deleted_at': payload[Const.deletedAt.key],
          'p_deleted_by': payload[Const.deletedBy.key],
        },
      );

  static Map<String, dynamic> _withoutQueueMetadata(
    Map<String, dynamic> payload,
  ) =>
      Map<String, dynamic>.from(payload)
        ..remove('_mutation_id')
        ..remove('_entity_key');

  static Future<void> _ensureShoppingListUploaded(int shoppingListId) async {
    final accountId = currentAccount;
    final list =
        await Singleton().getDatabase().getShoppingListById(shoppingListId);
    if (accountId == null ||
        list == null ||
        list.accountId != accountId ||
        list.deletedAt != null) {
      throw const OfflineMutationConflictException(
        'shopping_list_owner_required',
      );
    }

    var remote = await supabase
        .from('shopping_list')
        .select('${Const.accountId.key}, ${Const.deletedAt.key}')
        .eq(Const.id.key, shoppingListId)
        .maybeSingle();
    if (remote != null) {
      if (remote[Const.accountId.key] != accountId ||
          remote[Const.deletedAt.key] != null) {
        throw const OfflineMutationConflictException(
          'shopping_list_owner_required',
        );
      }
      return;
    }

    await _syncOwnedResource(
      'sync_shopping_list',
      _shoppingListPayload(list),
    );
    remote = await supabase
        .from('shopping_list')
        .select('${Const.accountId.key}, ${Const.deletedAt.key}')
        .eq(Const.id.key, shoppingListId)
        .maybeSingle();
    if (remote?[Const.accountId.key] != accountId ||
        remote?[Const.deletedAt.key] != null) {
      throw const OfflineMutationConflictException(
        'shopping_list_owner_required',
      );
    }
    await OfflineMutationQueue.instance.removeEntity(
      'shopping-list:$shoppingListId',
    );
  }

  static Future<void> _ensureShoppingListAvailableForChild(
    int shoppingListId,
  ) async {
    final accountId = currentAccount;
    final list =
        await Singleton().getDatabase().getShoppingListById(shoppingListId);
    if (accountId == null || list == null || list.deletedAt != null) {
      throw const OfflineMutationConflictException(
        'shopping_list_not_available',
      );
    }
    if (list.accountId == accountId) {
      await _ensureShoppingListUploaded(shoppingListId);
      return;
    }
    final remote = await supabase
        .from('shopping_list')
        .select(Const.id.key)
        .eq(Const.id.key, shoppingListId)
        .maybeSingle();
    if (remote == null) {
      throw const OfflineMutationConflictException(
        'shopping_list_not_available',
      );
    }
  }

  static Future<void> _ensureMealPlanUploaded(int mealPlanId) async {
    final accountId = currentAccount;
    final plan = await Singleton().getDatabase().getMealPlanById(mealPlanId);
    if (accountId == null ||
        plan == null ||
        plan.accountId != accountId ||
        plan.deletedAt != null) {
      throw const OfflineMutationConflictException(
        'meal_plan_owner_required',
      );
    }

    var remote = await supabase
        .from('meal_plan')
        .select('${Const.accountId.key}, ${Const.deletedAt.key}')
        .eq(Const.id.key, mealPlanId)
        .maybeSingle();
    if (remote != null) {
      if (remote[Const.accountId.key] != accountId ||
          remote[Const.deletedAt.key] != null) {
        throw const OfflineMutationConflictException(
          'meal_plan_owner_required',
        );
      }
      return;
    }

    await _syncOwnedResource('sync_meal_plan', _mealPlanPayload(plan));
    remote = await supabase
        .from('meal_plan')
        .select('${Const.accountId.key}, ${Const.deletedAt.key}')
        .eq(Const.id.key, mealPlanId)
        .maybeSingle();
    if (remote?[Const.accountId.key] != accountId ||
        remote?[Const.deletedAt.key] != null) {
      throw const OfflineMutationConflictException(
        'meal_plan_owner_required',
      );
    }
    await OfflineMutationQueue.instance.removeEntity('meal-plan:$mealPlanId');
  }

  static Future<void> _uploadQueuedRecipe(
    Map<String, dynamic> payload, {
    required bool create,
  }) async {
    String? image = payload['remote_image'] as String?;
    final encodedImage = payload['image_base64'] as String?;
    if (encodedImage != null) {
      image = await _uploadQueuedRecipeImage(
        accountId: payload['account_id'] as int,
        recipeId: payload['recipe_id'] as int,
        bytes: base64Decode(encodedImage),
        fileName: payload['image_name'] as String? ?? 'recipe.jpg',
      );
    }
    try {
      await supabase.rpc(
        create
            ? 'create_recipe_with_details_offline'
            : 'update_recipe_with_details_if_unchanged',
        params: {
          'p_account_id': payload['account_id'],
          'p_recipe_id': payload['recipe_id'],
          'p_title': payload['title'],
          'p_description': payload['description'],
          'p_notes': payload['notes'],
          'p_image': image,
          'p_ingredients': payload['ingredients'],
          'p_steps': payload['steps'],
          'p_category_ids': payload['category_ids'],
          'p_total_time_minutes': payload['total_time_minutes'],
          'p_servings': payload['servings'],
          'p_mutation_id': payload['_mutation_id'],
          if (!create) 'p_expected_revision': payload['expected_revision'],
        },
      );
      await supabase.rpc(
        'set_recipe_ingredient_layout',
        params: {
          'p_recipe_id': payload['recipe_id'],
          'p_layout': (payload['ingredients'] as List<dynamic>)
              .asMap()
              .entries
              .map((entry) {
            final ingredient = Map<String, dynamic>.from(entry.value as Map);
            return {
              Const.name.key: ingredient[Const.name.key],
              Const.sectionName.key: ingredient[Const.sectionName.key],
              Const.sortOrder.key: ingredient[Const.sortOrder.key] ?? entry.key,
            };
          }).toList(),
        },
      );
      await Singleton()
          .getDatabase()
          .clearLocalRecipeDetails(payload['recipe_id'] as int);
      final previousImage = payload['remote_image'] as String?;
      if (previousImage != image) {
        await tryDeleteUnreferencedRecipeImage(previousImage);
      }
      await _resetRecipeDownloadCursors();
    } on s.PostgrestException catch (error) {
      if (error.message.contains('recipe_edit_conflict') ||
          error.message.contains('recipe_not_found')) {
        throw OfflineMutationConflictException(error.message);
      }
      rethrow;
    }
  }

  static Future<String> uploadRecipeImage({
    required int accountId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    return _uploadImage(
      bucket: recipeImagesBucket,
      accountId: accountId,
      bytes: bytes,
      fileName: fileName,
    );
  }

  static Future<String> _uploadQueuedRecipeImage({
    required int accountId,
    required int recipeId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final originalExtension = path.extension(fileName).toLowerCase();
    const supportedExtensions = {
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.heic',
      '.heif',
      '.gif',
    };
    final extension = supportedExtensions.contains(originalExtension)
        ? originalExtension
        : '.jpg';
    final digest = sha256.convert(bytes).toString().substring(0, 20);
    final objectPath = '$accountId/recipe_${recipeId}_$digest$extension';
    await supabase.storage.from(recipeImagesBucket).uploadBinary(
          objectPath,
          bytes,
          fileOptions: s.FileOptions(
            cacheControl: '3600',
            contentType: _imageContentType(extension),
            upsert: true,
          ),
        );
    return supabase.storage.from(recipeImagesBucket).getPublicUrl(objectPath);
  }

  static Future<String> uploadAccountImage({
    required int accountId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    return _uploadImage(
      bucket: accountImagesBucket,
      accountId: accountId,
      bytes: bytes,
      fileName: fileName,
    );
  }

  static Future<String> _uploadImage({
    required String bucket,
    required int accountId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final originalExtension = path.extension(fileName).toLowerCase();
    const supportedExtensions = {
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.heic',
      '.heif',
      '.gif',
    };
    final extension = supportedExtensions.contains(originalExtension)
        ? originalExtension
        : '.jpg';
    final objectPath =
        '$accountId/${DateTime.now().microsecondsSinceEpoch}$extension';

    await supabase.storage.from(bucket).uploadBinary(
          objectPath,
          bytes,
          fileOptions: s.FileOptions(
            cacheControl: '3600',
            contentType: _imageContentType(extension),
          ),
        );

    return supabase.storage.from(bucket).getPublicUrl(objectPath);
  }

  static Future<void> tryDeleteUnreferencedRecipeImage(String? imageUrl) async {
    await _tryDeleteUnreferencedImage(
      bucket: recipeImagesBucket,
      imageUrl: imageUrl,
      table: 'recipe',
      column: Const.image.key,
    );
  }

  static Future<void> tryDeleteUnreferencedAccountImage(
      String? imageUrl) async {
    await _tryDeleteUnreferencedImage(
      bucket: accountImagesBucket,
      imageUrl: imageUrl,
      table: 'account',
      column: Const.profileImage.key,
    );
  }

  static Future<void> tryCleanupOrphanedImages({
    required int accountId,
  }) async {
    try {
      await _checkCurrentProfileCanModify(accountId);
    } catch (_) {
      return;
    }

    try {
      await _cleanupOrphanedImages(
        bucket: recipeImagesBucket,
        accountId: accountId,
        table: 'recipe',
        column: Const.image.key,
      );
      await _cleanupOrphanedImages(
        bucket: accountImagesBucket,
        accountId: accountId,
        table: 'account',
        column: Const.profileImage.key,
      );
    } catch (error, stackTrace) {
      logger.w(
        'Could not clean up orphaned Storage images',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> _tryDeleteUnreferencedImage({
    required String bucket,
    required String? imageUrl,
    required String table,
    required String column,
  }) async {
    final objectPath = _storageObjectPath(bucket: bucket, imageUrl: imageUrl);
    if (objectPath == null) return;

    try {
      final references = await supabase
          .from(table)
          .select(column)
          .eq(column, imageUrl!)
          .limit(1);
      if (references.isNotEmpty) return;
      await supabase.storage.from(bucket).remove([objectPath]);
    } catch (error, stackTrace) {
      logger.w(
        'Could not delete unreferenced image $objectPath from $bucket',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> _cleanupOrphanedImages({
    required String bucket,
    required int accountId,
    required String table,
    required String column,
  }) async {
    final rows = await supabase.from(table).select(column);
    final referencedPaths = <String>{};
    for (final row in rows) {
      final objectPath = _storageObjectPath(
        bucket: bucket,
        imageUrl: row[column]?.toString(),
      );
      if (objectPath != null) referencedPaths.add(objectPath);
    }

    const pageSize = 100;
    var offset = 0;
    final orphanedPaths = <String>[];
    final minimumAge =
        DateTime.now().toUtc().subtract(const Duration(hours: 1));
    while (true) {
      final files = await supabase.storage.from(bucket).list(
            path: '$accountId',
            searchOptions: s.SearchOptions(
              limit: pageSize,
              offset: offset,
            ),
          );

      for (final file in files) {
        final createdAt = DateTime.tryParse(file.createdAt ?? '')?.toUtc();
        if (file.id == null ||
            createdAt == null ||
            createdAt.isAfter(minimumAge)) {
          continue;
        }
        final objectPath = '$accountId/${file.name}';
        if (!referencedPaths.contains(objectPath)) {
          orphanedPaths.add(objectPath);
        }
      }

      if (files.length < pageSize) break;
      offset += pageSize;
    }

    for (var start = 0; start < orphanedPaths.length; start += pageSize) {
      final end = start + pageSize < orphanedPaths.length
          ? start + pageSize
          : orphanedPaths.length;
      await supabase.storage
          .from(bucket)
          .remove(orphanedPaths.sublist(start, end));
    }
  }

  static String? _storageObjectPath({
    required String bucket,
    required String? imageUrl,
  }) {
    final trimmedUrl = imageUrl?.trim();
    if (trimmedUrl == null || trimmedUrl.isEmpty) return null;
    final uri = Uri.tryParse(trimmedUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;

    final segments = uri.pathSegments;
    final publicIndex = segments.indexOf('public');
    if (publicIndex < 0 ||
        publicIndex + 2 > segments.length ||
        segments[publicIndex + 1] != bucket) {
      return null;
    }
    final objectPath = segments.skip(publicIndex + 2).join('/');
    if (objectPath.isEmpty) return null;

    final currentProjectUrl = Uri.tryParse(
      supabase.storage.from(bucket).getPublicUrl(objectPath),
    );
    if (currentProjectUrl == null ||
        currentProjectUrl.scheme != uri.scheme ||
        currentProjectUrl.authority != uri.authority) {
      return null;
    }
    return objectPath;
  }

  static String _imageContentType(String extension) {
    switch (extension) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      case '.heif':
        return 'image/heif';
      case '.gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }

  static Future<int> getRoleIdByName(String roleName) async {
    final data = await supabase
        .from('roles')
        .select(Const.id.key)
        .eq(Const.name.key, roleName)
        .single();

    return data[Const.id.key];
  }

  static Future<int> createProfileForAccount({
    required int accountId,
    required String name,
    required int roleId,
  }) async {
    await _checkAccountCanManageProfiles(accountId);
    return _createProfileForAccount(
      accountId: accountId,
      name: name,
      roleId: roleId,
    );
  }

  static Future<int> _createProfileForAccount({
    required int accountId,
    required String name,
    required int roleId,
  }) async {
    final data = await supabase
        .from('profiles')
        .insert({
          Const.accountId.key: accountId,
          Const.name.key: name,
          Const.roleId.key: roleId,
          Const.createdBy.key: accountId,
          Const.updatedBy.key: accountId,
        })
        .select(Const.id.key)
        .single();

    return data[Const.id.key];
  }

  static Future<void> updateProfileRole({
    required int profileId,
    required int roleId,
    required int accountId,
  }) async {
    await _checkAccountCanManageProfiles(accountId);
    await supabase
        .from('profiles')
        .update({
          Const.roleId.key: roleId,
          Const.updatedAt.key: DateTime.now().toUtc().toIso8601String(),
          Const.updatedBy.key: accountId,
        })
        .eq(Const.id.key, profileId)
        .eq(Const.accountId.key, accountId);
  }

  static Future<void> deleteProfileForAccount({
    required int profileId,
    required int accountId,
  }) async {
    await _checkAccountCanManageProfiles(accountId);
    final activeProfiles = await supabase
        .from('profiles')
        .select(Const.id.key)
        .eq(Const.accountId.key, accountId)
        .isFilter(Const.deletedAt.key, null);
    if (activeProfiles.length <= 1) {
      throw Exception('The last profile cannot be deleted.');
    }

    await supabase
        .from('profiles')
        .update({
          Const.deletedAt.key: DateTime.now().toUtc().toIso8601String(),
          Const.deletedBy.key: accountId,
          Const.updatedAt.key: DateTime.now().toUtc().toIso8601String(),
          Const.updatedBy.key: accountId,
        })
        .eq(Const.id.key, profileId)
        .eq(Const.accountId.key, accountId)
        .isFilter(Const.deletedAt.key, null);
  }

  static Future<void> _checkAccountCanManageProfiles(int accountId) async {
    final accountRole =
        (await SupabaseToDrift.getAccountRoleName(accountId))?.toLowerCase();
    if (accountRole != 'admin') {
      throw Exception('Only administrators can manage profiles.');
    }
  }

  static Future<ShoppingList> createShoppingList({
    required int accountId,
    required String name,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final now = DateTime.now().toUtc();
    final entry = ShoppingList(
      id: OfflineMutationQueue.createLocalId(),
      accountId: accountId,
      name: name.trim(),
      createdAt: now,
      createdBy: accountId,
      updatedAt: now,
      updatedBy: accountId,
    );
    await Singleton().getDatabase().upsertShoppingList(entry);
    await _enqueueShoppingList(entry);
    return entry;
  }

  static Future<void> renameShoppingList({
    required int accountId,
    required int shoppingListId,
    required String name,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(
          name, 'name', 'Shopping-list name is required.');
    }

    final database = Singleton().getDatabase();
    final existing = await database.getShoppingListById(shoppingListId);
    if (existing == null ||
        !await database.canEditShoppingList(accountId, shoppingListId)) {
      throw Exception('This shopping list is view-only.');
    }
    if (existing.name == trimmedName) return;

    final updated = existing.copyWith(
      name: trimmedName,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await database.upsertShoppingList(updated);
    await _enqueueShoppingList(updated);
  }

  static Future<void> deleteShoppingList({
    required int accountId,
    required int shoppingListId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getShoppingListById(shoppingListId);
    if (existing == null || existing.accountId != accountId) return;
    final now = DateTime.now().toUtc();
    final deleted = existing.copyWith(
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: Value(now),
      deletedBy: Value(accountId),
    );
    await database.upsertShoppingList(deleted);
    await _enqueueShoppingList(deleted);
  }

  static Future<ShoppingListSection> createShoppingListSection({
    required int accountId,
    required int shoppingListId,
    required String name,
  }) async {
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: shoppingListId,
    );
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Section name is required.');
    }
    final database = Singleton().getDatabase();
    final sections =
        await database.watchShoppingListSections(shoppingListId).first;
    if (sections.any(
      (section) => section.name.toLowerCase() == trimmedName.toLowerCase(),
    )) {
      throw ShoppingListSectionNameAlreadyExistsException(trimmedName);
    }
    final now = DateTime.now().toUtc();
    final entry = ShoppingListSection(
      id: OfflineMutationQueue.createLocalId(),
      shoppingListId: shoppingListId,
      name: trimmedName,
      sortOrder: sections.isEmpty
          ? 0
          : sections.map((section) => section.sortOrder).reduce(
                    (first, second) => first > second ? first : second,
                  ) +
              1,
      createdAt: now,
      createdBy: accountId,
      updatedAt: now,
      updatedBy: accountId,
    );
    await database.upsertShoppingListSection(entry);
    await _enqueueShoppingListSection(entry);
    return entry;
  }

  static Future<void> renameShoppingListSection({
    required int accountId,
    required int sectionId,
    required String name,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getShoppingListSectionById(sectionId);
    if (existing == null) return;
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: existing.shoppingListId,
    );
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Section name is required.');
    }
    final sections =
        await database.watchShoppingListSections(existing.shoppingListId).first;
    if (sections.any(
      (section) =>
          section.id != sectionId &&
          section.name.toLowerCase() == trimmedName.toLowerCase(),
    )) {
      throw ShoppingListSectionNameAlreadyExistsException(trimmedName);
    }
    if (existing.name == trimmedName) return;
    final updated = existing.copyWith(
      name: trimmedName,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await database.upsertShoppingListSection(updated);
    await _enqueueShoppingListSection(updated);
  }

  static Future<void> deleteShoppingListSection({
    required int accountId,
    required int sectionId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getShoppingListSectionById(sectionId);
    if (existing == null) return;
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: existing.shoppingListId,
    );
    final now = DateTime.now().toUtc();
    final items = await database.getShoppingListItemsInSection(sectionId);
    for (final item in items) {
      final moved = item.copyWith(
        sectionId: const Value(null),
        updatedAt: now,
        updatedBy: accountId,
      );
      await database.upsertShoppingListItem(moved);
      await _enqueueShoppingListItem(moved);
    }
    final deleted = existing.copyWith(
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: Value(now),
      deletedBy: Value(accountId),
    );
    await database.upsertShoppingListSection(deleted);
    await _enqueueShoppingListSection(deleted);
  }

  static Future<void> moveShoppingListItemToSection({
    required int accountId,
    required int itemId,
    int? sectionId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final item = await database.getShoppingListItemById(itemId);
    if (item == null || item.sectionId == sectionId) return;
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: item.shoppingListId,
    );
    if (sectionId != null) {
      final section = await database.getShoppingListSectionById(sectionId);
      if (section == null ||
          section.shoppingListId != item.shoppingListId ||
          section.deletedAt != null) {
        throw StateError('The target section is not available.');
      }
    }
    final moved = item.copyWith(
      sectionId: Value(sectionId),
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await database.upsertShoppingListItem(moved);
    await _enqueueShoppingListItem(moved);
  }

  static Future<ShoppingListItem> addShoppingListItem({
    required int accountId,
    required int shoppingListId,
    required String name,
    double? amount,
    String? unit,
    String? note,
    int? ingredientId,
    int? sectionId,
    String shoppingCategoryCode = 'other',
  }) async {
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: shoppingListId,
    );
    final now = DateTime.now().toUtc();
    final entry = ShoppingListItem(
      id: OfflineMutationQueue.createLocalId(),
      shoppingListId: shoppingListId,
      sectionId: sectionId,
      ingredientId: ingredientId,
      name: name.trim(),
      amount: amount,
      unit: unit,
      note: _nullableTrimmed(note),
      shoppingCategoryCode: shoppingCategoryCode,
      checked: false,
      createdAt: now,
      createdBy: accountId,
      updatedAt: now,
      updatedBy: accountId,
    );
    await Singleton().getDatabase().upsertShoppingListItem(entry);
    await _enqueueShoppingListItem(entry);
    return entry;
  }

  static Future<ShoppingListItem> updateShoppingListItem({
    required int accountId,
    required int itemId,
    required String name,
    required String shoppingCategoryCode,
    double? amount,
    String? unit,
    String? note,
    int? sectionId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getShoppingListItemById(itemId);
    if (existing == null) {
      throw StateError('Shopping-list item is not available locally.');
    }
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: existing.shoppingListId,
    );
    final entry = existing.copyWith(
      name: name.trim(),
      amount: Value(amount),
      unit: Value(unit),
      note: Value(_nullableTrimmed(note)),
      sectionId: Value(sectionId),
      shoppingCategoryCode: shoppingCategoryCode,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await Singleton().getDatabase().upsertShoppingListItem(entry);
    await _enqueueShoppingListItem(entry);
    return entry;
  }

  static Future<void> setShoppingListItemChecked({
    required int accountId,
    required int itemId,
    required bool checked,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getShoppingListItemById(itemId);
    if (existing == null) return;
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: existing.shoppingListId,
    );
    final updated = existing.copyWith(
      checked: checked,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await database.upsertShoppingListItem(updated);
    await _enqueueShoppingListItem(updated);
  }

  static Future<void> setIngredientShoppingCategory({
    required int accountId,
    required int ingredientId,
    required String shoppingCategoryCode,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getIngredientById(ingredientId);
    if (existing == null) return;
    final updated = existing.copyWith(
      shoppingCategoryCode: Value(shoppingCategoryCode),
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await database.upsertIngredient(updated);
    await OfflineMutationQueue.instance.enqueue(
      'ingredient_category_update',
      {
        Const.id.key: ingredientId,
        Const.shoppingCategoryCode.key: shoppingCategoryCode,
        Const.updatedAt.key: updated.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: accountId,
      },
      accountId: accountId,
    );
  }

  static Future<void> deleteShoppingListItem({
    required int accountId,
    required int itemId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getShoppingListItemById(itemId);
    if (existing == null) return;
    await _checkShoppingListAccess(
      accountId: accountId,
      shoppingListId: existing.shoppingListId,
    );
    final now = DateTime.now().toUtc();
    final deleted = existing.copyWith(
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: Value(now),
      deletedBy: Value(accountId),
    );
    await database.upsertShoppingListItem(deleted);
    await _enqueueShoppingListItem(deleted);
  }

  static Future<void> _enqueueShoppingList(ShoppingList list) =>
      OfflineMutationQueue.instance.enqueue(
        'shopping_list_upsert',
        _shoppingListPayload(list),
        accountId: list.updatedBy,
        entityKey: 'shopping-list:${list.id}',
      );

  static Future<void> _enqueueShoppingListItem(ShoppingListItem item) =>
      OfflineMutationQueue.instance.enqueue(
        'shopping_list_item_upsert',
        _shoppingListItemPayload(item),
        accountId: item.updatedBy,
        entityKey: 'shopping-list-item:${item.id}',
      );

  static Future<void> _enqueueShoppingListSection(
    ShoppingListSection section,
  ) =>
      OfflineMutationQueue.instance.enqueue(
        'shopping_list_section_upsert',
        _shoppingListSectionPayload(section),
        accountId: section.updatedBy,
        entityKey: 'shopping-list-section:${section.id}',
      );

  static Map<String, dynamic> _shoppingListPayload(ShoppingList list) => {
        Const.id.key: list.id,
        Const.accountId.key: list.accountId,
        Const.name.key: list.name,
        Const.createdAt.key: list.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: list.createdBy,
        Const.updatedAt.key: list.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: list.updatedBy,
        Const.deletedAt.key: list.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: list.deletedBy,
      };

  static Map<String, dynamic> _shoppingListItemPayload(
    ShoppingListItem item,
  ) =>
      {
        Const.id.key: item.id,
        Const.shoppingListId.key: item.shoppingListId,
        Const.sectionId.key: item.sectionId,
        Const.ingredientId.key: item.ingredientId,
        Const.name.key: item.name,
        Const.amount.key: item.amount,
        Const.unit.key: item.unit,
        Const.note.key: item.note,
        Const.shoppingCategoryCode.key: item.shoppingCategoryCode,
        Const.checked.key: item.checked,
        Const.createdAt.key: item.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: item.createdBy,
        Const.updatedAt.key: item.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: item.updatedBy,
        Const.deletedAt.key: item.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: item.deletedBy,
      };

  static Map<String, dynamic> _shoppingListSectionPayload(
    ShoppingListSection section,
  ) =>
      {
        Const.id.key: section.id,
        Const.shoppingListId.key: section.shoppingListId,
        Const.name.key: section.name,
        Const.sortOrder.key: section.sortOrder,
        Const.createdAt.key: section.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: section.createdBy,
        Const.updatedAt.key: section.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: section.updatedBy,
        Const.deletedAt.key: section.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: section.deletedBy,
      };

  static Future<void> _checkShoppingListAccess({
    required int accountId,
    required int shoppingListId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    if (!await Singleton()
        .getDatabase()
        .canEditShoppingList(accountId, shoppingListId)) {
      throw Exception('This shopping list is view-only.');
    }
  }

  static Future<void> setShoppingListMember({
    required int ownerAccountId,
    required int shoppingListId,
    required int memberAccountId,
    required String permission,
  }) async {
    await _checkCurrentProfileCanModify(ownerAccountId);
    final database = Singleton().getDatabase();
    final list = await database.getShoppingListById(shoppingListId);
    if (list?.accountId != ownerAccountId ||
        memberAccountId == ownerAccountId ||
        (permission != 'viewer' && permission != 'editor')) {
      throw Exception('Only the list owner can manage sharing.');
    }
    final now = DateTime.now().toUtc();
    final existing =
        await database.getShoppingListMember(shoppingListId, memberAccountId);
    final member = existing == null
        ? ShoppingListMember(
            shoppingListId: shoppingListId,
            accountId: memberAccountId,
            permission: permission,
            status: 'pending',
            createdAt: now,
            createdBy: ownerAccountId,
            updatedAt: now,
            updatedBy: ownerAccountId,
          )
        : existing.copyWith(
            permission: permission,
            status: existing.deletedAt == null && existing.status != 'declined'
                ? existing.status
                : 'pending',
            updatedAt: now,
            updatedBy: ownerAccountId,
            deletedAt: const Value(null),
            deletedBy: const Value(null),
          );
    await database.upsertShoppingListMember(member);
    await OfflineMutationQueue.instance.enqueue(
      'shopping_list_member_upsert',
      _shoppingListMemberPayload(member),
      accountId: ownerAccountId,
      entityKey: 'shopping-list-member:$shoppingListId:$memberAccountId',
    );
    if (member.status == 'pending') {
      await _enqueuePushNotification(
        accountId: ownerAccountId,
        type: 'shopping_list_invitation',
        recipientAccountId: memberAccountId,
        entityId: shoppingListId,
      );
    }
  }

  static Future<void> removeShoppingListMember({
    required int ownerAccountId,
    required ShoppingListMember member,
  }) async {
    final database = Singleton().getDatabase();
    final list = await database.getShoppingListById(member.shoppingListId);
    if (list?.accountId != ownerAccountId) {
      throw Exception('Only the list owner can manage sharing.');
    }
    final now = DateTime.now().toUtc();
    final deleted = member.copyWith(
      updatedAt: now,
      updatedBy: ownerAccountId,
      deletedAt: Value(now),
      deletedBy: Value(ownerAccountId),
    );
    await database.upsertShoppingListMember(deleted);
    await OfflineMutationQueue.instance.enqueue(
      'shopping_list_member_upsert',
      _shoppingListMemberPayload(deleted),
      accountId: ownerAccountId,
      entityKey:
          'shopping-list-member:${member.shoppingListId}:${member.accountId}',
    );
  }

  static Map<String, dynamic> _shoppingListMemberPayload(
    ShoppingListMember member,
  ) =>
      {
        Const.shoppingListId.key: member.shoppingListId,
        Const.accountId.key: member.accountId,
        Const.permission.key: member.permission,
        Const.invitationStatus.key: member.status,
        Const.createdAt.key: member.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: member.createdBy,
        Const.updatedAt.key: member.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: member.updatedBy,
        Const.deletedAt.key: member.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: member.deletedBy,
      };

  static Future<void> respondToShoppingListInvitation({
    required int accountId,
    required int shoppingListId,
    required bool accept,
  }) async {
    final database = Singleton().getDatabase();
    final member =
        await database.getShoppingListMember(shoppingListId, accountId);
    if (member == null || member.status != 'pending') return;
    final now = DateTime.now().toUtc();
    final updated = member.copyWith(
      status: accept ? 'accepted' : 'declined',
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: accept ? const Value(null) : Value(now),
      deletedBy: accept ? const Value(null) : Value(accountId),
    );
    await database.upsertShoppingListMember(updated);
    await OfflineMutationQueue.instance.enqueue(
      'shopping_list_invitation_response',
      {
        Const.shoppingListId.key: shoppingListId,
        'accept': accept,
      },
      accountId: accountId,
      entityKey: 'shopping-list-invitation:$shoppingListId:$accountId',
    );
  }

  static Future<MealPlan> createMealPlan({
    required int accountId,
    required String name,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final now = DateTime.now().toUtc();
    final plan = MealPlan(
      id: OfflineMutationQueue.createLocalId(),
      accountId: accountId,
      name: name.trim(),
      createdAt: now,
      createdBy: accountId,
      updatedAt: now,
      updatedBy: accountId,
    );
    await Singleton().getDatabase().upsertMealPlan(plan);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_upsert',
      _mealPlanPayload(plan),
      accountId: accountId,
      entityKey: 'meal-plan:${plan.id}',
    );
    return plan;
  }

  static Future<void> renameMealPlan({
    required int accountId,
    required int mealPlanId,
    required String name,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Meal-plan name is required.');
    }

    final database = Singleton().getDatabase();
    final existing = await database.getMealPlanById(mealPlanId);
    if (existing == null ||
        !await database.canEditMealPlan(accountId, mealPlanId)) {
      throw Exception('This meal plan is view-only.');
    }
    if (existing.name == trimmedName) return;

    final updated = existing.copyWith(
      name: trimmedName,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await database.upsertMealPlan(updated);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_upsert',
      _mealPlanPayload(updated),
      accountId: accountId,
      entityKey: 'meal-plan:$mealPlanId',
    );
  }

  static Future<void> deleteMealPlan({
    required int accountId,
    required int mealPlanId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing = await database.getMealPlanById(mealPlanId);
    if (existing == null || existing.accountId != accountId) {
      throw Exception('Only the meal-plan owner can delete it.');
    }

    final now = DateTime.now().toUtc();
    final deleted = existing.copyWith(
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: Value(now),
      deletedBy: Value(accountId),
    );
    await database.upsertMealPlan(deleted);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_upsert',
      _mealPlanPayload(deleted),
      accountId: accountId,
      entityKey: 'meal-plan:$mealPlanId',
    );
  }

  static Map<String, dynamic> _mealPlanPayload(MealPlan plan) => {
        Const.id.key: plan.id,
        Const.accountId.key: plan.accountId,
        Const.name.key: plan.name,
        Const.createdAt.key: plan.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: plan.createdBy,
        Const.updatedAt.key: plan.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: plan.updatedBy,
        Const.deletedAt.key: plan.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: plan.deletedBy,
      };

  static Future<void> setMealPlanMember({
    required int ownerAccountId,
    required int mealPlanId,
    required int memberAccountId,
    required String permission,
  }) async {
    await _checkCurrentProfileCanModify(ownerAccountId);
    final database = Singleton().getDatabase();
    final plan = await database.getMealPlanById(mealPlanId);
    if (plan?.accountId != ownerAccountId ||
        memberAccountId == ownerAccountId ||
        (permission != 'viewer' && permission != 'editor')) {
      throw Exception('Only the meal-plan owner can manage sharing.');
    }
    final now = DateTime.now().toUtc();
    final existing =
        await database.getMealPlanMember(mealPlanId, memberAccountId);
    final member = existing == null
        ? MealPlanMember(
            mealPlanId: mealPlanId,
            accountId: memberAccountId,
            permission: permission,
            status: 'pending',
            createdAt: now,
            createdBy: ownerAccountId,
            updatedAt: now,
            updatedBy: ownerAccountId,
          )
        : existing.copyWith(
            permission: permission,
            status: existing.deletedAt == null && existing.status != 'declined'
                ? existing.status
                : 'pending',
            updatedAt: now,
            updatedBy: ownerAccountId,
            deletedAt: const Value(null),
            deletedBy: const Value(null),
          );
    await database.upsertMealPlanMember(member);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_member_upsert',
      _mealPlanMemberPayload(member),
      accountId: ownerAccountId,
      entityKey: 'meal-plan-member:$mealPlanId:$memberAccountId',
    );
    if (member.status == 'pending') {
      await _enqueuePushNotification(
        accountId: ownerAccountId,
        type: 'meal_plan_invitation',
        recipientAccountId: memberAccountId,
        entityId: mealPlanId,
      );
    }
  }

  static Future<void> removeMealPlanMember({
    required int ownerAccountId,
    required MealPlanMember member,
  }) async {
    final database = Singleton().getDatabase();
    final plan = await database.getMealPlanById(member.mealPlanId);
    if (plan?.accountId != ownerAccountId) {
      throw Exception('Only the meal-plan owner can manage sharing.');
    }
    final now = DateTime.now().toUtc();
    final deleted = member.copyWith(
      updatedAt: now,
      updatedBy: ownerAccountId,
      deletedAt: Value(now),
      deletedBy: Value(ownerAccountId),
    );
    await database.upsertMealPlanMember(deleted);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_member_upsert',
      _mealPlanMemberPayload(deleted),
      accountId: ownerAccountId,
      entityKey: 'meal-plan-member:${member.mealPlanId}:${member.accountId}',
    );
  }

  static Map<String, dynamic> _mealPlanMemberPayload(MealPlanMember member) => {
        Const.mealPlanId.key: member.mealPlanId,
        Const.accountId.key: member.accountId,
        Const.permission.key: member.permission,
        Const.invitationStatus.key: member.status,
        Const.createdAt.key: member.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: member.createdBy,
        Const.updatedAt.key: member.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: member.updatedBy,
        Const.deletedAt.key: member.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: member.deletedBy,
      };

  static Future<void> respondToMealPlanInvitation({
    required int accountId,
    required int mealPlanId,
    required bool accept,
  }) async {
    final database = Singleton().getDatabase();
    final member = await database.getMealPlanMember(mealPlanId, accountId);
    if (member == null || member.status != 'pending') return;
    final now = DateTime.now().toUtc();
    final updated = member.copyWith(
      status: accept ? 'accepted' : 'declined',
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: accept ? const Value(null) : Value(now),
      deletedBy: accept ? const Value(null) : Value(accountId),
    );
    await database.upsertMealPlanMember(updated);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_invitation_response',
      {
        Const.mealPlanId.key: mealPlanId,
        'accept': accept,
      },
      accountId: accountId,
      entityKey: 'meal-plan-invitation:$mealPlanId:$accountId',
    );
  }

  static Future<MealPlanEntry> createMealPlanEntry({
    required int accountId,
    required int mealPlanId,
    required DateTime plannedDate,
    required String mealSlot,
    required int sortOrder,
    int? recipeId,
    String? recipeTitleSnapshot,
    String? customTitle,
    String? note,
    int? servings,
  }) async {
    await _checkMealPlanAccess(accountId: accountId, mealPlanId: mealPlanId);
    final now = DateTime.now().toUtc();
    final resolvedRecipeTitle = await _recipeTitleForSnapshot(
      recipeId,
      fallback: recipeTitleSnapshot,
    );
    final entry = MealPlanEntry(
      id: OfflineMutationQueue.createLocalId(),
      mealPlanId: mealPlanId,
      plannedDate: DateTime(
        plannedDate.year,
        plannedDate.month,
        plannedDate.day,
      ),
      mealSlot: mealSlot,
      recipeId: recipeId,
      recipeTitleSnapshot: resolvedRecipeTitle,
      customTitle: _nullableTrimmed(customTitle),
      note: _nullableTrimmed(note),
      servings: servings,
      sortOrder: sortOrder,
      createdAt: now,
      createdBy: accountId,
      updatedAt: now,
      updatedBy: accountId,
    );
    await Singleton().getDatabase().upsertMealPlanEntry(entry);
    await _enqueueMealPlanEntry(entry);
    return entry;
  }

  static Future<MealPlanEntry> updateMealPlanEntry({
    required int accountId,
    required int mealPlanId,
    required int entryId,
    required DateTime plannedDate,
    required String mealSlot,
    required int sortOrder,
    int? recipeId,
    String? recipeTitleSnapshot,
    String? customTitle,
    String? note,
    int? servings,
  }) async {
    await _checkMealPlanAccess(accountId: accountId, mealPlanId: mealPlanId);
    final existing =
        await Singleton().getDatabase().getMealPlanEntryById(entryId);
    if (existing == null || existing.mealPlanId != mealPlanId) {
      throw StateError('Meal-plan entry is not available locally.');
    }
    final resolvedRecipeTitle = await _recipeTitleForSnapshot(
      recipeId,
      fallback: recipeTitleSnapshot ??
          (recipeId == existing.recipeId ? existing.recipeTitleSnapshot : null),
    );
    final entry = existing.copyWith(
      plannedDate: DateTime(
        plannedDate.year,
        plannedDate.month,
        plannedDate.day,
      ),
      mealSlot: mealSlot,
      recipeId: Value(recipeId),
      recipeTitleSnapshot: Value(resolvedRecipeTitle),
      customTitle: Value(_nullableTrimmed(customTitle)),
      note: Value(_nullableTrimmed(note)),
      servings: Value(servings),
      sortOrder: sortOrder,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
      deletedAt: const Value(null),
      deletedBy: const Value(null),
    );
    await Singleton().getDatabase().upsertMealPlanEntry(entry);
    await _enqueueMealPlanEntry(entry);
    return entry;
  }

  static Future<void> deleteMealPlanEntry({
    required int accountId,
    required int mealPlanId,
    required int entryId,
  }) async {
    await _checkMealPlanAccess(accountId: accountId, mealPlanId: mealPlanId);
    final existing =
        await Singleton().getDatabase().getMealPlanEntryById(entryId);
    if (existing == null || existing.mealPlanId != mealPlanId) return;
    final now = DateTime.now().toUtc();
    final deleted = existing.copyWith(
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: Value(now),
      deletedBy: Value(accountId),
    );
    await Singleton().getDatabase().upsertMealPlanEntry(deleted);
    await _enqueueMealPlanEntry(deleted);
  }

  static Future<void> _checkMealPlanAccess({
    required int accountId,
    required int mealPlanId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    if (!await Singleton()
        .getDatabase()
        .canEditMealPlan(accountId, mealPlanId)) {
      throw Exception('This meal plan is view-only.');
    }
  }

  static Future<void> _checkMealPlanOwnership({
    required int accountId,
    required int mealPlanId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final plan = await Singleton().getDatabase().getMealPlanById(mealPlanId);
    if (plan == null || plan.accountId != accountId) {
      throw Exception('Only the meal-plan owner can manage whole weeks.');
    }
  }

  static Future<void> _enqueueMealPlanEntry(MealPlanEntry entry) =>
      OfflineMutationQueue.instance.enqueue(
        'meal_plan_entry_upsert',
        _mealPlanEntryPayload(entry),
        accountId: entry.updatedBy,
      );

  static Map<String, dynamic> _mealPlanEntryPayload(MealPlanEntry entry) => {
        Const.id.key: entry.id,
        Const.mealPlanId.key: entry.mealPlanId,
        Const.plannedDate.key: _dateOnlyString(entry.plannedDate),
        Const.mealSlot.key: entry.mealSlot,
        Const.recipeId.key: entry.recipeId,
        Const.recipeTitleSnapshot.key: entry.recipeTitleSnapshot,
        Const.customTitle.key: entry.customTitle,
        Const.note.key: entry.note,
        Const.servings.key: entry.servings,
        Const.sortOrder.key: entry.sortOrder,
        Const.createdAt.key: entry.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: entry.createdBy,
        Const.updatedAt.key: entry.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: entry.updatedBy,
        Const.deletedAt.key: entry.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: entry.deletedBy,
      };

  static Future<void> copyMealPlanWeek({
    required int accountId,
    required int mealPlanId,
    required DateTime sourceWeekStart,
    required DateTime targetWeekStart,
    required bool replace,
  }) async {
    await _checkMealPlanOwnership(
      accountId: accountId,
      mealPlanId: mealPlanId,
    );
    final database = Singleton().getDatabase();
    final sourceEntries = await database.getMealPlanEntriesForWeek(
      mealPlanId,
      sourceWeekStart,
      sourceWeekStart.add(const Duration(days: 7)),
    );
    if (replace) {
      final targetEntries = await database.getMealPlanEntriesForWeek(
        mealPlanId,
        targetWeekStart,
        targetWeekStart.add(const Duration(days: 7)),
      );
      for (final entry in targetEntries) {
        await deleteMealPlanEntry(
          accountId: accountId,
          mealPlanId: mealPlanId,
          entryId: entry.id,
        );
      }
    }
    for (final source in sourceEntries) {
      final offset = source.plannedDate.difference(sourceWeekStart).inDays;
      await createMealPlanEntry(
        accountId: accountId,
        mealPlanId: mealPlanId,
        plannedDate: targetWeekStart.add(Duration(days: offset)),
        mealSlot: source.mealSlot,
        sortOrder: source.sortOrder,
        recipeId: source.recipeId,
        recipeTitleSnapshot: source.recipeTitleSnapshot,
        customTitle: source.customTitle,
        note: source.note,
        servings: source.servings,
      );
    }
  }

  static Future<MealPlanTemplate> saveMealPlanTemplate({
    required int accountId,
    required String name,
    required DateTime weekStart,
    required List<MealPlanEntry> entries,
  }) async {
    if (!await RecipePermissions.canModifyContent()) {
      throw Exception('Viewer profiles cannot make changes.');
    }
    final now = DateTime.now().toUtc();
    final template = MealPlanTemplate(
      id: OfflineMutationQueue.createLocalId(),
      accountId: accountId,
      name: name.trim(),
      createdAt: now,
      createdBy: accountId,
      updatedAt: now,
      updatedBy: accountId,
    );
    final database = Singleton().getDatabase();
    await database.upsertMealPlanTemplate(template);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_template_upsert',
      _mealPlanTemplatePayload(template),
      accountId: accountId,
      entityKey: 'meal-plan-template:${template.id}',
    );

    for (final source in entries) {
      final entry = MealPlanTemplateEntry(
        id: OfflineMutationQueue.createLocalId(),
        templateId: template.id,
        dayOffset: source.plannedDate.difference(weekStart).inDays,
        mealSlot: source.mealSlot,
        recipeId: source.recipeId,
        recipeTitleSnapshot: source.recipeTitleSnapshot,
        customTitle: source.customTitle,
        note: source.note,
        servings: source.servings,
        sortOrder: source.sortOrder,
        createdAt: now,
        createdBy: accountId,
        updatedAt: now,
        updatedBy: accountId,
      );
      await database.upsertMealPlanTemplateEntry(entry);
      await OfflineMutationQueue.instance.enqueue(
        'meal_plan_template_entry_upsert',
        _mealPlanTemplateEntryPayload(entry),
        accountId: accountId,
      );
    }
    return template;
  }

  static Future<void> applyMealPlanTemplate({
    required int accountId,
    required int mealPlanId,
    required int templateId,
    required DateTime targetWeekStart,
    required bool replace,
  }) async {
    await _checkMealPlanOwnership(
      accountId: accountId,
      mealPlanId: mealPlanId,
    );
    final database = Singleton().getDatabase();
    if (replace) {
      final targetEntries = await database.getMealPlanEntriesForWeek(
        mealPlanId,
        targetWeekStart,
        targetWeekStart.add(const Duration(days: 7)),
      );
      for (final entry in targetEntries) {
        await deleteMealPlanEntry(
          accountId: accountId,
          mealPlanId: mealPlanId,
          entryId: entry.id,
        );
      }
    }
    final templateEntries =
        await database.getMealPlanTemplateEntries(templateId);
    for (final source in templateEntries) {
      await createMealPlanEntry(
        accountId: accountId,
        mealPlanId: mealPlanId,
        plannedDate: targetWeekStart.add(Duration(days: source.dayOffset)),
        mealSlot: source.mealSlot,
        sortOrder: source.sortOrder,
        recipeId: source.recipeId,
        recipeTitleSnapshot: source.recipeTitleSnapshot,
        customTitle: source.customTitle,
        note: source.note,
        servings: source.servings,
      );
    }
  }

  static Future<void> deleteMealPlanTemplate({
    required int accountId,
    required int templateId,
  }) async {
    if (!await RecipePermissions.canModifyContent()) {
      throw Exception('Viewer profiles cannot make changes.');
    }
    final database = Singleton().getDatabase();
    final existing = await database.getMealPlanTemplateById(templateId);
    if (existing == null || existing.accountId != accountId) return;
    final now = DateTime.now().toUtc();
    final deleted = existing.copyWith(
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: Value(now),
      deletedBy: Value(accountId),
    );
    await database.upsertMealPlanTemplate(deleted);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_template_upsert',
      _mealPlanTemplatePayload(deleted),
      accountId: accountId,
      entityKey: 'meal-plan-template:$templateId',
    );
  }

  static Future<MealPlanTemplate> renameMealPlanTemplate({
    required int accountId,
    required int templateId,
    required String name,
  }) async {
    if (!await RecipePermissions.canModifyContent()) {
      throw Exception('Viewer profiles cannot make changes.');
    }
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Template name is required.');
    }
    final database = Singleton().getDatabase();
    final existing = await database.getMealPlanTemplateById(templateId);
    if (existing == null || existing.accountId != accountId) {
      throw StateError('Only the template owner can rename it.');
    }
    final renamed = existing.copyWith(
      name: normalizedName,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: accountId,
    );
    await database.upsertMealPlanTemplate(renamed);
    await OfflineMutationQueue.instance.enqueue(
      'meal_plan_template_upsert',
      _mealPlanTemplatePayload(renamed),
      accountId: accountId,
      entityKey: 'meal-plan-template:$templateId',
    );
    return renamed;
  }

  static Map<String, dynamic> _mealPlanTemplatePayload(
    MealPlanTemplate template,
  ) =>
      {
        Const.id.key: template.id,
        Const.accountId.key: template.accountId,
        Const.name.key: template.name,
        Const.createdAt.key: template.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: template.createdBy,
        Const.updatedAt.key: template.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: template.updatedBy,
        Const.deletedAt.key: template.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: template.deletedBy,
      };

  static Map<String, dynamic> _mealPlanTemplateEntryPayload(
    MealPlanTemplateEntry entry,
  ) =>
      {
        Const.id.key: entry.id,
        Const.templateId.key: entry.templateId,
        Const.dayOffset.key: entry.dayOffset,
        Const.mealSlot.key: entry.mealSlot,
        Const.recipeId.key: entry.recipeId,
        Const.recipeTitleSnapshot.key: entry.recipeTitleSnapshot,
        Const.customTitle.key: entry.customTitle,
        Const.note.key: entry.note,
        Const.servings.key: entry.servings,
        Const.sortOrder.key: entry.sortOrder,
        Const.createdAt.key: entry.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: entry.createdBy,
        Const.updatedAt.key: entry.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: entry.updatedBy,
        Const.deletedAt.key: entry.deletedAt?.toUtc().toIso8601String(),
        Const.deletedBy.key: entry.deletedBy,
      };

  static String _dateOnlyString(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return '${normalized.year.toString().padLeft(4, '0')}-'
        '${normalized.month.toString().padLeft(2, '0')}-'
        '${normalized.day.toString().padLeft(2, '0')}';
  }

  static String? _nullableTrimmed(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static Future<String?> _recipeTitleForSnapshot(
    int? recipeId, {
    String? fallback,
  }) async {
    if (recipeId == null) return _nullableTrimmed(fallback);
    final recipe =
        (await Singleton().getDatabase().getRecipeById(recipeId).first)
            .firstOrNull;
    return _nullableTrimmed(recipe?.title) ?? _nullableTrimmed(fallback);
  }

  static Future<String?> _shoppingListNameForSnapshot(
    int? shoppingListId,
  ) async {
    if (shoppingListId == null) return null;
    final list =
        await Singleton().getDatabase().getShoppingListById(shoppingListId);
    return list?.deletedAt == null ? _nullableTrimmed(list?.name) : null;
  }

  static String? _chatMessageSnapshot(ChatMessage? message) {
    if (message == null) return null;
    return _nullableTrimmed(message.message) ??
        _nullableTrimmed(message.recipeTitleSnapshot) ??
        _nullableTrimmed(message.shoppingListNameSnapshot);
  }

  /// Records this device once so it can receive account-specific features.
  static Future<void> registerDevice(String deviceId) async {
    if (await SupabaseToDrift.isDeviceRegistrated(deviceId)) return;
    await supabase.from('device').insert({'device_id': deviceId});
  }


  static Future<void> _checkCanCreateRecipe(int accountId) async {
    await _checkCurrentProfileCanModify(accountId);
    final roleName = await RecipePermissions.currentAccountRoleName();
    if (roleName != 'editor' && roleName != 'admin') {
      throw Exception('You need editor access to create recipes.');
    }
  }

  static Future<void> _checkCanUpdateRecipe({
    required int accountId,
    required int recipeId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final roleName = await RecipePermissions.currentAccountRoleName();
    if (roleName == 'admin') return;

    final recipes =
        await Singleton().getDatabase().getRecipeById(recipeId).first;
    if (roleName == 'editor' && recipes.firstOrNull?.createdBy == accountId) {
      return;
    }

    throw Exception('You can only edit your own recipes.');
  }

  static Future<void> _checkCurrentProfileCanModify(int accountId) async {
    if (currentAccount != accountId) {
      throw Exception('The active account cannot make this change.');
    }
    final accountRole = await RecipePermissions.currentAccountRoleName();
    if (!RecipePermissions.accountRoleCanModify(accountRole)) {
      throw Exception('Viewer accounts cannot make changes.');
    }
    final profileId = currentProfile;
    if (profileId == null) {
      throw Exception('Select an editor profile to make changes.');
    }
    final roleName = await RecipePermissions.currentProfileRoleName();
    final normalizedRole = roleName.toLowerCase();
    if (normalizedRole != 'editor' && normalizedRole != 'admin') {
      throw Exception('Viewer profiles cannot make changes.');
    }
  }

  static Future<void> updateAccountProfile({
    required int accountId,
    required String? bio,
    required String? profileImage,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    await supabase.from('account').update({
      Const.bio.key: bio,
      Const.profileImage.key: profileImage,
      Const.updatedAt.key: DateTime.now().toUtc().toIso8601String(),
      Const.updatedBy.key: accountId,
    }).eq(Const.id.key, accountId);
    await SupabaseToDrift.refreshAccounts();
  }

  static Future<void> followAccount({
    required int followerAccountId,
    required int followedAccountId,
  }) async {
    await _checkCurrentProfileCanModify(followerAccountId);
    if (followerAccountId == followedAccountId) {
      throw ArgumentError('An account cannot follow itself.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    await supabase.from('account_follow').upsert({
      Const.followerAccountId.key: followerAccountId,
      Const.followedAccountId.key: followedAccountId,
      Const.createdAt.key: now,
      Const.createdBy.key: followerAccountId,
      Const.updatedAt.key: now,
      Const.updatedBy.key: followerAccountId,
      Const.deletedAt.key: null,
      Const.deletedBy.key: null,
    },
        onConflict:
            '${Const.followerAccountId.key},${Const.followedAccountId.key}');
    await SupabaseToDrift.refreshAccountFollows();
  }

  static Future<void> sendFriendRequest({
    required int accountId,
    required int friendAccountId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    if (accountId == friendAccountId) return;
    final database = Singleton().getDatabase();
    final existing =
        await database.getAccountFriend(accountId, friendAccountId);
    if (existing?.deletedAt == null &&
        (existing?.status == 'accepted' || existing?.status == 'pending')) {
      return;
    }
    final now = DateTime.now().toUtc();
    final low = accountId < friendAccountId ? accountId : friendAccountId;
    final high = accountId < friendAccountId ? friendAccountId : accountId;
    final friendship = existing == null
        ? AccountFriend(
            firstAccountId: low,
            secondAccountId: high,
            requestedBy: accountId,
            status: 'pending',
            createdAt: now,
            createdBy: accountId,
            updatedAt: now,
            updatedBy: accountId,
          )
        : existing.copyWith(
            requestedBy: accountId,
            status: 'pending',
            updatedAt: now,
            updatedBy: accountId,
            deletedAt: const Value(null),
            deletedBy: const Value(null),
          );
    await database.upsertAccountFriend(friendship);
    await OfflineMutationQueue.instance.enqueue(
      'account_friend_request',
      {'friend_account_id': friendAccountId},
      accountId: accountId,
      entityKey: 'account-friend:$low:$high',
    );
    await _enqueuePushNotification(
      accountId: accountId,
      type: 'friend_request',
      recipientAccountId: friendAccountId,
    );
  }

  static Future<void> respondToFriendRequest({
    required int accountId,
    required int requesterAccountId,
    required bool accept,
  }) async {
    final database = Singleton().getDatabase();
    final existing =
        await database.getAccountFriend(accountId, requesterAccountId);
    if (existing == null ||
        existing.status != 'pending' ||
        existing.requestedBy != requesterAccountId) {
      return;
    }
    final now = DateTime.now().toUtc();
    final updated = existing.copyWith(
      status: accept ? 'accepted' : 'declined',
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: accept ? const Value(null) : Value(now),
      deletedBy: accept ? const Value(null) : Value(accountId),
    );
    await database.upsertAccountFriend(updated);
    await OfflineMutationQueue.instance.enqueue(
      'account_friend_response',
      {
        'requester_account_id': requesterAccountId,
        'accept': accept,
      },
      accountId: accountId,
      entityKey:
          'account-friend:${existing.firstAccountId}:${existing.secondAccountId}',
    );
  }

  static Future<void> removeFriend({
    required int accountId,
    required int friendAccountId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final database = Singleton().getDatabase();
    final existing =
        await database.getAccountFriend(accountId, friendAccountId);
    if (existing == null) return;
    final now = DateTime.now().toUtc();
    await database.upsertAccountFriend(existing.copyWith(
      updatedAt: now,
      updatedBy: accountId,
      deletedAt: Value(now),
      deletedBy: Value(accountId),
    ));
    await database.removeSharedAccessBetweenAccounts(
      accountId,
      friendAccountId,
      now,
    );
    await OfflineMutationQueue.instance.enqueue(
      'account_friend_remove',
      {'friend_account_id': friendAccountId},
      accountId: accountId,
      entityKey:
          'account-friend:${existing.firstAccountId}:${existing.secondAccountId}',
    );
  }

  static Future<ChatMessage> sendChatMessage({
    required int accountId,
    required int friendAccountId,
    String? message,
    int? recipeId,
    int? shoppingListId,
    int? replyToMessageId,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final trimmedMessage = _nullableTrimmed(message);
    if (trimmedMessage == null && recipeId == null && shoppingListId == null) {
      throw ArgumentError('A message or shared item is required.');
    }
    final firstId = accountId < friendAccountId ? accountId : friendAccountId;
    final secondId = accountId < friendAccountId ? friendAccountId : accountId;
    final database = Singleton().getDatabase();
    final friendship = await database.getAccountFriend(firstId, secondId);
    if (friendship == null ||
        friendship.status != 'accepted' ||
        friendship.deletedAt != null) {
      throw Exception('Messages can only be sent to accepted friends.');
    }
    final now = DateTime.now().toUtc();
    final recipeTitleSnapshot = await _recipeTitleForSnapshot(recipeId);
    final shoppingListNameSnapshot =
        await _shoppingListNameForSnapshot(shoppingListId);
    final replyMessage = replyToMessageId == null
        ? null
        : await database.getChatMessage(replyToMessageId);
    if (replyToMessageId != null && replyMessage == null) {
      throw Exception('The replied-to message is not available.');
    }
    if (replyMessage != null &&
        (replyMessage.firstAccountId != firstId ||
            replyMessage.secondAccountId != secondId ||
            replyMessage.deletedAt != null)) {
      throw Exception('The replied-to message is not available.');
    }
    final replyMessageSnapshot = _chatMessageSnapshot(replyMessage);
    final existing = await database.getChatConversation(firstId, secondId);
    final conversation = existing == null
        ? ChatConversation(
            firstAccountId: firstId,
            secondAccountId: secondId,
            createdAt: now,
            createdBy: accountId,
            updatedAt: now,
            updatedBy: accountId,
          )
        : existing.copyWith(
            updatedAt: now,
            updatedBy: accountId,
            deletedAt: const Value(null),
            deletedBy: const Value(null),
          );
    final chatMessage = ChatMessage(
      id: OfflineMutationQueue.createLocalId(),
      firstAccountId: firstId,
      secondAccountId: secondId,
      senderAccountId: accountId,
      message: trimmedMessage,
      recipeId: recipeId,
      recipeTitleSnapshot: recipeTitleSnapshot,
      shoppingListId: shoppingListId,
      shoppingListNameSnapshot: shoppingListNameSnapshot,
      replyToMessageId: replyMessage?.id,
      replyMessageSnapshot: replyMessageSnapshot,
      createdAt: now,
      createdBy: accountId,
      updatedAt: now,
      updatedBy: accountId,
    );
    await database.upsertChatConversation(conversation);
    await database.upsertChatMessage(chatMessage);
    await OfflineMutationQueue.instance.enqueue(
      'chat_message_send',
      {
        'friend_account_id': friendAccountId,
        Const.id.key: chatMessage.id,
        Const.message.key: chatMessage.message,
        Const.recipeId.key: chatMessage.recipeId,
        Const.recipeTitleSnapshot.key: chatMessage.recipeTitleSnapshot,
        Const.shoppingListId.key: chatMessage.shoppingListId,
        Const.shoppingListNameSnapshot.key:
            chatMessage.shoppingListNameSnapshot,
        Const.replyToMessageId.key: chatMessage.replyToMessageId,
        Const.replyMessageSnapshot.key: chatMessage.replyMessageSnapshot,
        Const.createdAt.key: chatMessage.createdAt.toIso8601String(),
        Const.updatedAt.key: chatMessage.updatedAt.toIso8601String(),
      },
      accountId: accountId,
      entityKey: 'chat-message:${chatMessage.id}',
    );
    await _enqueuePushNotification(
      accountId: accountId,
      type: 'chat_message',
      recipientAccountId: friendAccountId,
      entityId: chatMessage.id,
    );
    return chatMessage;
  }

  static Future<void> _enqueuePushNotification({
    required int accountId,
    required String type,
    required int recipientAccountId,
    int? entityId,
  }) =>
      OfflineMutationQueue.instance.enqueue(
        'push_notification_send',
        {
          'notification_type': type,
          'recipient_account_id': recipientAccountId,
          'entity_id': entityId,
        },
        accountId: accountId,
        entityKey: 'push:$type:$recipientAccountId:${entityId ?? 'none'}',
      );

  static Future<void> _sendQueuedPushNotification(
    Map<String, dynamic> payload,
  ) async {
    final notificationId = await supabase.rpc(
      'queue_push_notification',
      params: {
        'p_type': payload['notification_type'],
        'p_recipient_account_id': payload['recipient_account_id'],
        'p_entity_id': payload['entity_id'],
      },
    );
    if (notificationId == null) return;
    final response = await supabase.functions.invoke(
      'push-notification',
      body: {'notification_id': notificationId.toString()},
    );
    if (response.status < 200 || response.status >= 300) {
      throw Exception(
        'Push delivery failed (${response.status}): ${response.data}',
      );
    }
  }

  static Future<void> setChatMessageReaction({
    required int accountId,
    required int messageId,
    String? reaction,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    const allowed = {'👍', '❤️', '😂', '😮', '😢', '🎉'};
    if (reaction != null && !allowed.contains(reaction)) {
      throw ArgumentError('Unsupported message reaction.');
    }
    final database = Singleton().getDatabase();
    final message = await database.getChatMessage(messageId);
    if (message == null ||
        accountId != message.firstAccountId &&
            accountId != message.secondAccountId) {
      throw Exception('This message is not available.');
    }
    final now = DateTime.now().toUtc();
    final existing =
        await database.getChatMessageReaction(messageId, accountId);
    if (reaction == null && existing == null) return;
    final entry = existing == null
        ? ChatMessageReaction(
            messageId: messageId,
            accountId: accountId,
            reaction: reaction!,
            createdAt: now,
            createdBy: accountId,
            updatedAt: now,
            updatedBy: accountId,
          )
        : existing.copyWith(
            reaction: reaction ?? existing.reaction,
            updatedAt: now,
            updatedBy: accountId,
            deletedAt: reaction == null ? Value(now) : const Value(null),
            deletedBy: reaction == null ? Value(accountId) : const Value(null),
          );
    await database.upsertChatMessageReaction(entry);
    await OfflineMutationQueue.instance.enqueue(
      'chat_reaction_set',
      {
        'message_id': messageId,
        Const.reaction.key: reaction,
        Const.updatedAt.key: now.toIso8601String(),
      },
      accountId: accountId,
      entityKey: 'chat-reaction:$messageId:$accountId',
    );
  }

  static Future<void> markChatMessagesRead({
    required int accountId,
    required int friendAccountId,
  }) async {
    final readAt = DateTime.now().toUtc();
    final changed = await Singleton().getDatabase().markChatMessagesReadLocally(
          accountId: accountId,
          friendAccountId: friendAccountId,
          readAt: readAt,
        );
    if (changed == 0) return;
    await OfflineMutationQueue.instance.enqueue(
      'chat_messages_read',
      {
        'friend_account_id': friendAccountId,
      },
      accountId: accountId,
      entityKey: 'chat-read:$accountId:$friendAccountId',
    );
  }

  static Future<void> unfollowAccount({
    required int followerAccountId,
    required int followedAccountId,
  }) async {
    await _checkCurrentProfileCanModify(followerAccountId);
    final now = DateTime.now().toUtc().toIso8601String();
    await supabase
        .from('account_follow')
        .update({
          Const.updatedAt.key: now,
          Const.updatedBy.key: followerAccountId,
          Const.deletedAt.key: now,
          Const.deletedBy.key: followerAccountId,
        })
        .eq(Const.followerAccountId.key, followerAccountId)
        .eq(Const.followedAccountId.key, followedAccountId);
    await SupabaseToDrift.refreshAccountFollows();
  }

  static Future<void> setRecipeLiked({
    required int accountId,
    required int recipeId,
    required bool liked,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final values = {
      Const.accountId.key: accountId,
      Const.recipeId.key: recipeId,
      Const.updatedAt.key: now,
      Const.updatedBy.key: accountId,
      Const.deletedAt.key: liked ? null : now,
      Const.deletedBy.key: liked ? null : accountId,
    };

    late final Map<String, dynamic> data;
    if (liked) {
      data = await supabase
          .from('recipe_like')
          .upsert({
            ...values,
            Const.createdAt.key: now,
            Const.createdBy.key: accountId,
          }, onConflict: '${Const.accountId.key},${Const.recipeId.key}')
          .select()
          .single();
    } else {
      data = await supabase
          .from('recipe_like')
          .update(values)
          .eq(Const.accountId.key, accountId)
          .eq(Const.recipeId.key, recipeId)
          .select()
          .single();
    }

    await Singleton().getDatabase().upsertRecipeLike(
          RecipeLike(
            accountId: data[Const.accountId.key],
            recipeId: data[Const.recipeId.key],
            createdAt: DateTime.parse(data[Const.createdAt.key]),
            createdBy: data[Const.createdBy.key],
            updatedAt: DateTime.parse(data[Const.updatedAt.key]),
            updatedBy: data[Const.updatedBy.key],
            deletedAt: DateTime.tryParse(data[Const.deletedAt.key] ?? ''),
            deletedBy: data[Const.deletedBy.key],
          ),
        );
  }

  static Future<int> createRecipeWithDetails({
    required int accountId,
    required String title,
    required String? description,
    required String? notes,
    required int? totalTimeMinutes,
    required int? servings,
    required String? image,
    required List<Map<String, dynamic>> ingredients,
    required List<Map<String, dynamic>> steps,
    required List<int> categoryIds,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    await _checkCanCreateRecipe(accountId);
    final recipeId = OfflineMutationQueue.createLocalId();
    await _saveRecipeLocallyAndQueue(
      create: true,
      accountId: accountId,
      recipeId: recipeId,
      title: title,
      description: description,
      notes: notes,
      totalTimeMinutes: totalTimeMinutes,
      servings: servings,
      image: image,
      imageBytes: imageBytes,
      imageName: imageName,
      ingredients: ingredients,
      steps: steps,
      categoryIds: categoryIds,
      expectedRevision: 1,
    );
    await OfflineMutationQueue.instance.flush();
    if (await OfflineMutationQueue.instance
        .hasBlockedEntity('recipe:$recipeId')) {
      throw const RecipeEditConflictException();
    }
    return recipeId;
  }

  static Future<int> updateRecipeWithDetails({
    required int accountId,
    required int recipeId,
    required String title,
    required String? description,
    required String? notes,
    required int? totalTimeMinutes,
    required int? servings,
    required String? image,
    required List<Map<String, dynamic>> ingredients,
    required List<Map<String, dynamic>> steps,
    required List<int> categoryIds,
    required int expectedRevision,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    await _checkCanUpdateRecipe(accountId: accountId, recipeId: recipeId);
    await _saveRecipeLocallyAndQueue(
      create: false,
      accountId: accountId,
      recipeId: recipeId,
      title: title,
      description: description,
      notes: notes,
      totalTimeMinutes: totalTimeMinutes,
      servings: servings,
      image: image,
      imageBytes: imageBytes,
      imageName: imageName,
      ingredients: ingredients,
      steps: steps,
      categoryIds: categoryIds,
      expectedRevision: expectedRevision,
    );
    await OfflineMutationQueue.instance.flush();
    if (await OfflineMutationQueue.instance
        .hasBlockedEntity('recipe:$recipeId')) {
      throw const RecipeEditConflictException();
    }
    return recipeId;
  }

  static Future<void> discardPendingRecipeDraft(int recipeId) async {
    await OfflineMutationQueue.instance.removeEntity('recipe:$recipeId');
    await Singleton().getDatabase().clearLocalRecipeDetails(recipeId);
    await _resetRecipeDownloadCursors();
  }

  static Future<void> _resetRecipeDownloadCursors() async {
    const initialCursor = '1900-03-01T00:00:00.000';
    for (final key in [
      KeyValueEnum.recipe,
      KeyValueEnum.steps,
      KeyValueEnum.recipeIngredient,
      KeyValueEnum.recipeStepIngredient,
      KeyValueEnum.recipeCategory,
    ]) {
      await KeyValue.setNewValue(key.key, initialCursor);
    }
  }

  static Future<void> _saveRecipeLocallyAndQueue({
    required bool create,
    required int accountId,
    required int recipeId,
    required String title,
    required String? description,
    required String? notes,
    required int? totalTimeMinutes,
    required int? servings,
    required String? image,
    required Uint8List? imageBytes,
    required String? imageName,
    required List<Map<String, dynamic>> ingredients,
    required List<Map<String, dynamic>> steps,
    required List<int> categoryIds,
    required int expectedRevision,
  }) async {
    final database = Singleton().getDatabase();
    final existing = (await database.getRecipeById(recipeId).first).firstOrNull;
    final now = DateTime.now().toUtc();
    final localImage = imageBytes == null
        ? image
        : 'data:image/${path.extension(imageName ?? 'recipe.jpg').replaceFirst('.', '')};base64,${base64Encode(imageBytes)}';
    final cachedIngredients = await database.getAllLocalIngredients();
    final ingredientRows = <Ingredient>[];
    final ingredientLinks = <RecipeIngredient>[];
    final preparedIngredients = <Map<String, dynamic>>[];
    final ingredientIds = <int>[];
    for (var ingredientIndex = 0;
        ingredientIndex < ingredients.length;
        ingredientIndex++) {
      final value = ingredients[ingredientIndex];
      final name = value['name'].toString().trim();
      final cached = cachedIngredients
          .where((item) => item.name.toLowerCase() == name.toLowerCase())
          .firstOrNull;
      final id = cached?.id ?? OfflineMutationQueue.createLocalId();
      ingredientIds.add(id);
      if (cached == null) {
        ingredientRows.add(Ingredient(
          id: id,
          name: name,
          createdAt: now,
          createdBy: accountId,
          updatedAt: now,
          updatedBy: accountId,
        ));
      }
      ingredientLinks.add(RecipeIngredient(
        recipeId: recipeId,
        ingredientId: id,
        amount: (value['amount'] as num?)?.toDouble(),
        unit: _nullableTrimmed(value['unit']?.toString()),
        quantityNote: _nullableTrimmed(
          value[Const.quantityNote.key]?.toString(),
        ),
        sectionName: _nullableTrimmed(
          value[Const.sectionName.key]?.toString(),
        ),
        sortOrder:
            (value[Const.sortOrder.key] as num?)?.toInt() ?? ingredientIndex,
        createdAt: now,
        createdBy: accountId,
        updatedAt: now,
        updatedBy: accountId,
      ));
      preparedIngredients.add({...value, 'id': id});
    }
    final stepRows = <RecipeStep>[];
    final stepLinks = <RecipeStepIngredient>[];
    final preparedSteps = <Map<String, dynamic>>[];
    final existingSteps = create
        ? const <int, RecipeStep>{}
        : {
            for (final step
                in await database.getRecipeStepsByRecipeId(recipeId).first)
              step.id: step,
          };
    for (final value in steps) {
      final existingStepId = value['id'];
      final stepId = !create && existingStepId is num
          ? existingStepId.toInt()
          : OfflineMutationQueue.createLocalId();
      final existingStep = existingSteps[stepId];
      stepRows.add(RecipeStep(
        id: stepId,
        recipeId: recipeId,
        stepNr: (value['step_nr'] as num).toInt(),
        description: value['description'].toString(),
        image: value['image'] as String?,
        createdAt: existingStep?.createdAt ?? now,
        createdBy: existingStep?.createdBy ?? accountId,
        updatedAt: now,
        updatedBy: accountId,
      ));
      final indexes = (value['ingredient_indexes'] as List? ?? const [])
          .map((index) => (index as num).toInt());
      for (final index in indexes) {
        if (index >= 0 && index < ingredientIds.length) {
          stepLinks.add(RecipeStepIngredient(
            recipeStepId: stepId,
            ingredientId: ingredientIds[index],
            createdAt: now,
            createdBy: accountId,
            updatedAt: now,
            updatedBy: accountId,
          ));
        }
      }
      preparedSteps.add({...value, 'id': stepId});
    }
    await database.saveRecipeGraph(
      recipe: Recipe(
        id: recipeId,
        title: title,
        image: localImage,
        description: description,
        notes: notes,
        totalTimeMinutes: totalTimeMinutes,
        servings: servings,
        revision: existing?.revision ?? expectedRevision,
        createdAt: existing?.createdAt ?? now,
        createdBy: existing?.createdBy ?? accountId,
        updatedAt: now,
        updatedBy: accountId,
      ),
      ingredientRows: ingredientRows,
      ingredientLinks: ingredientLinks,
      stepRows: stepRows,
      stepIngredientLinks: stepLinks,
      categoryLinks: categoryIds
          .map((id) => RecipeCategory(
                categoryId: id,
                recipeId: recipeId,
                createdAt: now,
                createdBy: accountId,
                updatedAt: now,
                updatedBy: accountId,
              ))
          .toList(),
    );
    await OfflineMutationQueue.instance.enqueue(
      create ? 'recipe_create' : 'recipe_update',
      {
        'account_id': accountId,
        'recipe_id': recipeId,
        'title': title,
        'description': description,
        'notes': notes,
        'total_time_minutes': totalTimeMinutes,
        'servings': servings,
        'remote_image': image,
        'image_base64': imageBytes == null ? null : base64Encode(imageBytes),
        'image_name': imageName,
        'ingredients': preparedIngredients,
        'steps': preparedSteps,
        'category_ids': categoryIds,
        'expected_revision': expectedRevision,
      },
      accountId: accountId,
      entityKey: 'recipe:$recipeId',
    );
  }

  static Future<void> createComment({
    required int recipeId,
    required int accountId,
    required String message,
  }) async {
    await _checkCurrentProfileCanModify(accountId);
    final now = DateTime.now().toUtc();
    final data = await supabase
        .from('comment')
        .insert({
          Const.recipeId.key: recipeId,
          Const.accountId.key: accountId,
          Const.message.key: message,
          Const.createdAt.key: now.toIso8601String(),
          Const.createdBy.key: accountId,
          Const.updatedAt.key: now.toIso8601String(),
          Const.updatedBy.key: accountId,
        })
        .select()
        .single();

    await Singleton().getDatabase().createOrUpdateComment(
          CommentsCompanion.insert(
            id: Value(data[Const.id.key]),
            recipeId: data[Const.recipeId.key],
            accountId: data[Const.accountId.key],
            message: data[Const.message.key],
            createdAt: DateTime.parse(data[Const.createdAt.key]),
            createdBy: data[Const.createdBy.key],
            updatedAt: DateTime.parse(data[Const.updatedAt.key]),
            updatedBy: data[Const.updatedBy.key],
          ),
        );
  }

  static Future<void> uploadComments() async {
    final accountId = currentAccount;
    if (accountId == null) return;
    var lastSynced = await KeyValue.getValue(KeyValueEnum.comment.key);

    var commentEntries = await Singleton()
        .getDatabase()
        .notSyncedCommentEntries(DateTime.parse(lastSynced!), accountId);
    final remoteRows = await supabase
        .from('comment')
        .select('${Const.id.key}, ${Const.updatedAt.key}')
        .eq(Const.accountId.key, accountId);
    final remoteUpdatedAtById = <int, DateTime>{
      for (final row in remoteRows)
        if (DateTime.tryParse(row[Const.updatedAt.key]?.toString() ?? '') !=
            null)
          (row[Const.id.key] as num).toInt():
              DateTime.parse(row[Const.updatedAt.key].toString()).toUtc(),
    };
    commentEntries = commentEntries.where((comment) {
      final remoteUpdatedAt = remoteUpdatedAtById[comment.id];
      return remoteUpdatedAt == null ||
          comment.updatedAt.toUtc().isAfter(remoteUpdatedAt);
    }).toList();
    logger.i("Comments pending upload: ${commentEntries.length}");

    int len = commentEntries.length;
    for (int i = 0; i < len; i++) {
      var entry = commentEntries[i];
      await supabase.from('comment').upsert({
        'id': entry.id,
        Const.accountId.key: entry.accountId,
        Const.message.key: entry.message,
        Const.recipeId.key: entry.recipeId,
        Const.createdAt.key: entry.createdAt.toUtc().toIso8601String(),
        Const.createdBy.key: entry.createdBy,
        Const.updatedAt.key: entry.updatedAt.toUtc().toIso8601String(),
        Const.updatedBy.key: entry.updatedBy,
        Const.deletedAt.key: entry.deletedAt != null
            ? entry.deletedAt!.toUtc().toIso8601String()
            : entry.deletedAt,
        Const.deletedBy.key: entry.deletedBy,
      }, onConflict: 'id');
    }
  }

  static String? _isoOrNull(DateTime? value) =>
      value?.toUtc().toIso8601String();

  /// Uploads local history changes, skipping entries for which [remoteRows]
  /// (just downloaded from the server) already contain a newer version.
  static Future<void> uploadHistory(List<Map<String, dynamic>> remoteRows) async {
    final since = DateTime.parse(
      await KeyValue.getValue(KeyValueEnum.history.key) ??
          DateTime.utc(1900).toIso8601String(),
    );
    final remoteUpdatedAt = {
      for (final row in remoteRows)
        (row[Const.accountId.key], row[Const.recipeId.key]):
            DateTime.parse(row[Const.updatedAt.key]).toUtc(),
    };
    final local =
        await Singleton().getDatabase().notSyncedHistoryEntries(since);

    for (final entry in local) {
      final remote = remoteUpdatedAt[(entry.accountId, entry.recipeId)];
      if (remote != null && !remote.isBefore(entry.updatedAt.toUtc())) continue;
      await supabase.from('history').upsert(
        {
          Const.accountId.key: entry.accountId,
          Const.recipeId.key: entry.recipeId,
          Const.stepNr.key: entry.stepNr,
          Const.open.key: entry.open,
          Const.createdAt.key: _isoOrNull(entry.createdAt),
          Const.createdBy.key: entry.createdBy,
          Const.updatedAt.key: _isoOrNull(entry.updatedAt),
          Const.updatedBy.key: entry.updatedBy,
          Const.deletedAt.key: _isoOrNull(entry.deletedAt),
          Const.deletedBy.key: entry.deletedBy,
        },
        onConflict: 'account_id,recipe_id',
      );
    }
  }

  /// Uploads changed settings unless the server already has a newer version.
  static Future<void> uploadSettings() async {
    final since = DateTime.parse(
      await KeyValue.getValue(KeyValueEnum.setting.key) ??
          DateTime.utc(1900).toIso8601String(),
    );
    final changed =
        await Singleton().getDatabase().notSyncedSettingsEntries(since);

    for (final setting in changed) {
      final remote = await supabase
          .from('setting')
          .select(Const.updatedAt.key)
          .eq(Const.accountId.key, setting.accountId)
          .maybeSingle();
      final remoteUpdatedAt =
          DateTime.tryParse('${remote?[Const.updatedAt.key] ?? ''}')?.toUtc();
      if (remoteUpdatedAt != null &&
          !setting.updatedAt.toUtc().isAfter(remoteUpdatedAt)) {
        continue;
      }
      await supabase.from('setting').update({
        Const.language.key: setting.language,
        Const.realtime.key: setting.realtime,
        Const.lightmode.key: setting.lightmode,
        Const.updatedAt.key: _isoOrNull(setting.updatedAt),
        Const.updatedBy.key: setting.updatedBy,
      }).eq(Const.accountId.key, setting.accountId);
    }
  }
}
