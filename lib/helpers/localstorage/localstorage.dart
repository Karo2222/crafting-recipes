import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftingrecipes/main.dart';
import 'connection/connection.dart' as impl;

part 'localstorage.g.dart';

/// A recipe together with its number of steps.
class RecipeWithCount {
  RecipeWithCount(this.recipe, this.count);

  final Recipe recipe;
  final int count;

  @override
  String toString() => '(${recipe.id}, ${recipe.title})';
}

/// Builds a [Recipe] from a custom query row that selects all recipe columns.
///
/// Drift generates a separate result class per query, so the row is accessed
/// dynamically here instead of repeating the mapping for every query.
Recipe _recipeFromRow(dynamic row) => Recipe(
      id: row.id,
      title: row.title,
      image: row.image,
      description: row.description,
      totalTimeMinutes: row.totalTimeMinutes,
      servings: row.servings,
      revision: row.revision,
      createdAt: row.createdAt,
      createdBy: row.createdBy,
      updatedAt: row.updatedAt,
      updatedBy: row.updatedBy,
    );

class CommentWithAccount {
  const CommentWithAccount({
    required this.comment,
    required this.accountName,
  });

  final Comment comment;
  final String accountName;
}

class SharedResourceInvitation {
  const SharedResourceInvitation({
    required this.resourceId,
    required this.resourceName,
    required this.ownerAccountName,
    required this.permission,
  });

  final int resourceId;
  final String resourceName;
  final String ownerAccountName;
  final String permission;
}

class SharedResourceParticipant {
  const SharedResourceParticipant({
    required this.account,
    required this.permission,
    required this.status,
    required this.isOwner,
  });

  final Account account;
  final String permission;
  final String status;
  final bool isOwner;
}

class FriendConnection {
  const FriendConnection({required this.friendship, required this.account});

  final AccountFriend friendship;
  final Account account;
}

class ChatConversationWithAccount {
  const ChatConversationWithAccount({
    required this.conversation,
    required this.account,
  });

  final ChatConversation conversation;
  final Account account;
}

@DriftDatabase(tables: [], include: {'sql.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : _resetSyncCursorsOnCreate = true,
        super(impl.connect());
  AppDatabase.forTesting(super.executor) : _resetSyncCursorsOnCreate = false;

  final bool _resetSyncCursorsOnCreate;

  /// A freshly created database is empty, so download cursors stored by an
  /// earlier installation must not be reused; otherwise the next sync would
  /// only ask for changes since then and the app would stay empty.
  static Future<void> _forgetSyncCursors() async {
    final prefs = await SharedPreferences.getInstance();
    final cursors = prefs.getKeys().where(
          (key) => key.startsWith('sync_') && key != 'sync_status',
        );
    final beginning = DateTime(1900, 3, 1).toIso8601String();
    for (final key in cursors.toList()) {
      await prefs.setString(key, beginning);
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          if (_resetSyncCursorsOnCreate) await _forgetSyncCursors();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(recipes, recipes.totalTimeMinutes);
          }
          if (from < 3) {
            await m.addColumn(accounts, accounts.profileImage);
            await m.addColumn(accounts, accounts.bio);
            await m.createTable(accountFollows);
          }
          if (from < 4) {
            await m.createTable(measurementUnits);
          }
          if (from < 5) {
            await m.createTable(shoppingLists);
            await m.createTable(shoppingListItems);
          }
          if (from < 6) {
            await m.createTable(shoppingCategories);
            await m.addColumn(
              ingredients,
              ingredients.shoppingCategoryCode,
            );
            await m.addColumn(
              shoppingListItems,
              shoppingListItems.shoppingCategoryCode,
            );
          }
          if (from < 7) {
            await m.addColumn(shoppingListItems, shoppingListItems.note);
          }
          if (from < 8) {
            await m.createTable(mealPlanEntries);
          }
          if (from < 9) {
            await m.createTable(recipeLikes);
          }
          if (from < 10) {
            await m.createTable(profiles);
          }
          if (from < 11) {
            await m.addColumn(recipes, recipes.servings);
            await m.addColumn(mealPlanEntries, mealPlanEntries.servings);
            await m.createTable(mealPlanTemplates);
            await m.createTable(mealPlanTemplateEntries);
            await m.createTable(pendingMutations);
          }
          if (from < 12) {
            await m.addColumn(recipes, recipes.revision);
          }
          if (from < 13) {
            await m.createTable(shoppingListMembers);
            await m.createTable(mealPlans);
            await customStatement('''
              INSERT INTO meal_plans (
                id, account_id, name, created_at, created_by,
                updated_at, updated_by, deleted_at, deleted_by
              )
              SELECT
                id, account_id, name, created_at, created_by,
                updated_at, updated_by, deleted_at, deleted_by
              FROM profiles
            ''');
            await m.createTable(mealPlanMembers);
            if (from >= 8) {
              await m.alterTable(TableMigration(
                mealPlanEntries,
                newColumns: [mealPlanEntries.mealPlanId],
                columnTransformer: {
                  mealPlanEntries.mealPlanId:
                      const CustomExpression<int>('profile_id'),
                },
              ));
            }
          }
          if (from >= 13 && from < 14) {
            await m.addColumn(
              shoppingListMembers,
              shoppingListMembers.status,
            );
            await m.addColumn(mealPlanMembers, mealPlanMembers.status);
          }
          if (from < 15) {
            await m.createTable(accountFriends);
          }
          if (from < 16) {
            await m.createTable(chatConversations);
            await m.createTable(chatMessages);
            await m.createTable(chatMessageReactions);
          }
          if (from >= 16 && from < 17) {
            await m.addColumn(chatMessages, chatMessages.readAt);
          }
          if (from >= 11 && from < 18) {
            await m.addColumn(pendingMutations, pendingMutations.accountId);
          }
          if (from < 19) {
            await m.addColumn(
              chatMessages,
              chatMessages.recipeTitleSnapshot,
            );
            await m.addColumn(
              mealPlanEntries,
              mealPlanEntries.recipeTitleSnapshot,
            );
            await m.addColumn(
              mealPlanTemplateEntries,
              mealPlanTemplateEntries.recipeTitleSnapshot,
            );
            await customStatement('''
              UPDATE chat_messages
              SET recipe_title_snapshot = (
                SELECT title FROM recipes
                WHERE recipes.id = chat_messages.recipe_id
              )
              WHERE recipe_id IS NOT NULL
                AND recipe_title_snapshot IS NULL
            ''');
            await customStatement('''
              UPDATE meal_plan_entries
              SET recipe_title_snapshot = (
                SELECT title FROM recipes
                WHERE recipes.id = meal_plan_entries.recipe_id
              )
              WHERE recipe_id IS NOT NULL
                AND recipe_title_snapshot IS NULL
            ''');
            await customStatement('''
              UPDATE meal_plan_template_entries
              SET recipe_title_snapshot = (
                SELECT title FROM recipes
                WHERE recipes.id = meal_plan_template_entries.recipe_id
              )
              WHERE recipe_id IS NOT NULL
                AND recipe_title_snapshot IS NULL
            ''');
          }
          if (from < 20) {
            await m.alterTable(TableMigration(
              recipeIngredients,
              newColumns: [recipeIngredients.quantityNote],
            ));
          }
          if (from < 21) {
            await m.addColumn(recipes, recipes.notes);
          }
          if (from < 22) {
            await m.createTable(shoppingListSections);
            await m.addColumn(shoppingListItems, shoppingListItems.sectionId);
          }
          if (from < 23) {
            await m.addColumn(chatMessages, chatMessages.shoppingListId);
            await m.addColumn(
              chatMessages,
              chatMessages.shoppingListNameSnapshot,
            );
            await m.addColumn(chatMessages, chatMessages.replyToMessageId);
            await m.addColumn(
              chatMessages,
              chatMessages.replyMessageSnapshot,
            );
          }
          if (from < 24) {
            await m.addColumn(
              recipeIngredients,
              recipeIngredients.sectionName,
            );
            await m.addColumn(
              recipeIngredients,
              recipeIngredients.sortOrder,
            );
          }
          if (from < 25) {
            // Media attachments were never used by the recipe app.
            await customStatement('DROP TABLE IF EXISTS recipes_assets');
            await customStatement('DROP TABLE IF EXISTS assets');
          }
        },
      );
  /// Inserts or replaces all [rows] of [table] in a single batch.
  Future<void> _upsertAll<T extends Table, D>(
    TableInfo<T, D> table,
    List<Insertable<D>> rows,
  ) =>
      batch((b) => b.insertAllOnConflictUpdate(table, rows));

  /// Inserts [entry], or overwrites the existing row only if [entry] is newer.
  Future<int> _upsertIfNewer<T extends Table, D>(
    TableInfo<T, D> table,
    Insertable<D> entry,
    Expression<DateTime> Function(T row) updatedAt,
  ) =>
      into(table).insert(
        entry,
        onConflict: DoUpdate.withExcluded(
          (_, __) => entry,
          where: (old, excluded) =>
              updatedAt(old).isSmallerThan(updatedAt(excluded)),
        ),
      );

  /// Removes all local data, e.g. after signing out.
  Future<void> deleteEverything() => transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });

// TABLE: Recipe
  Stream<List<RecipeWithCount>> getAllRecipes() => allRecipes()
      .map((row) => RecipeWithCount(_recipeFromRow(row), row.numberOfSteps))
      .watch();

  Future<void> insertMultipleRecipes(List<Insertable<Recipe>> rows) =>
      _upsertAll(recipes, rows);

  Future<void> saveRecipeGraph({
    required Recipe recipe,
    required List<Ingredient> ingredientRows,
    required List<RecipeIngredient> ingredientLinks,
    required List<RecipeStep> stepRows,
    required List<RecipeStepIngredient> stepIngredientLinks,
    required List<RecipeCategory> categoryLinks,
  }) async {
    await transaction(() async {
      final oldSteps = await (select(recipeSteps)
            ..where((step) => step.recipeId.equals(recipe.id)))
          .get();
      final oldIngredientLinks = await (select(recipeIngredients)
            ..where((link) => link.recipeId.equals(recipe.id)))
          .get();
      final oldCategoryLinks = await (select(recipesCategories)
            ..where((link) => link.recipeId.equals(recipe.id)))
          .get();
      final affectedStepIds = <int>{
        ...oldSteps.map((step) => step.id),
        ...stepRows.map((step) => step.id),
      };
      final oldStepIngredientLinks = affectedStepIds.isEmpty
          ? const <RecipeStepIngredient>[]
          : await (select(recipeStepIngredients)
                ..where((link) => link.recipeStepId.isIn(affectedStepIds)))
              .get();

      String linkKey(int firstId, int secondId) => '$firstId:$secondId';

      final oldStepsById = {for (final step in oldSteps) step.id: step};
      final persistedSteps = stepRows.map((step) {
        final oldStep = oldStepsById[step.id];
        return oldStep == null
            ? step
            : step.copyWith(
                createdAt: oldStep.createdAt,
                createdBy: oldStep.createdBy,
              );
      }).toList();
      final persistedStepIds = persistedSteps.map((step) => step.id).toSet();

      final oldIngredientLinksByKey = {
        for (final link in oldIngredientLinks)
          linkKey(link.recipeId, link.ingredientId): link,
      };
      final persistedIngredientLinks = ingredientLinks.map((link) {
        final oldLink =
            oldIngredientLinksByKey[linkKey(link.recipeId, link.ingredientId)];
        return oldLink == null
            ? link
            : link.copyWith(
                createdAt: oldLink.createdAt,
                createdBy: oldLink.createdBy,
              );
      }).toList();
      final persistedIngredientLinkKeys = persistedIngredientLinks
          .map((link) => linkKey(link.recipeId, link.ingredientId))
          .toSet();

      final oldCategoryLinksByKey = {
        for (final link in oldCategoryLinks)
          linkKey(link.recipeId, link.categoryId): link,
      };
      final persistedCategoryLinks = categoryLinks.map((link) {
        final oldLink =
            oldCategoryLinksByKey[linkKey(link.recipeId, link.categoryId)];
        return oldLink == null
            ? link
            : link.copyWith(
                createdAt: oldLink.createdAt,
                createdBy: oldLink.createdBy,
              );
      }).toList();
      final persistedCategoryLinkKeys = persistedCategoryLinks
          .map((link) => linkKey(link.recipeId, link.categoryId))
          .toSet();

      final oldStepIngredientLinksByKey = {
        for (final link in oldStepIngredientLinks)
          linkKey(link.recipeStepId, link.ingredientId): link,
      };
      final persistedStepIngredientLinks = stepIngredientLinks.map((link) {
        final oldLink = oldStepIngredientLinksByKey[
            linkKey(link.recipeStepId, link.ingredientId)];
        return oldLink == null
            ? link
            : link.copyWith(
                createdAt: oldLink.createdAt,
                createdBy: oldLink.createdBy,
              );
      }).toList();
      final persistedStepIngredientLinkKeys = persistedStepIngredientLinks
          .map((link) => linkKey(link.recipeStepId, link.ingredientId))
          .toSet();

      for (final link in oldStepIngredientLinks) {
        if (persistedStepIngredientLinkKeys
            .contains(linkKey(link.recipeStepId, link.ingredientId))) {
          continue;
        }
        await (delete(recipeStepIngredients)
              ..where((row) =>
                  row.recipeStepId.equals(link.recipeStepId) &
                  row.ingredientId.equals(link.ingredientId)))
            .go();
      }
      for (final link in oldIngredientLinks) {
        if (persistedIngredientLinkKeys
            .contains(linkKey(link.recipeId, link.ingredientId))) {
          continue;
        }
        await (delete(recipeIngredients)
              ..where((row) =>
                  row.recipeId.equals(link.recipeId) &
                  row.ingredientId.equals(link.ingredientId)))
            .go();
      }
      for (final link in oldCategoryLinks) {
        if (persistedCategoryLinkKeys
            .contains(linkKey(link.recipeId, link.categoryId))) {
          continue;
        }
        await (delete(recipesCategories)
              ..where((row) =>
                  row.recipeId.equals(link.recipeId) &
                  row.categoryId.equals(link.categoryId)))
            .go();
      }
      for (final step in oldSteps) {
        if (persistedStepIds.contains(step.id)) continue;
        await (delete(recipeSteps)..where((row) => row.id.equals(step.id)))
            .go();
      }

      await into(recipes).insertOnConflictUpdate(recipe);
      for (final ingredient in ingredientRows) {
        await into(ingredients).insertOnConflictUpdate(ingredient);
      }
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
            recipeIngredients, persistedIngredientLinks);
        batch.insertAllOnConflictUpdate(recipeSteps, persistedSteps);
        batch.insertAllOnConflictUpdate(
            recipeStepIngredients, persistedStepIngredientLinks);
        batch.insertAllOnConflictUpdate(
            recipesCategories, persistedCategoryLinks);
      });
    });
  }

  Future<List<Ingredient>> getAllLocalIngredients() => (select(ingredients)
        ..where((ingredient) => ingredient.deletedAt.isNull()))
      .get();

  Future<void> clearLocalRecipeDetails(int recipeId) async {
    await transaction(() async {
      final steps = await (select(recipeSteps)
            ..where((step) => step.recipeId.equals(recipeId)))
          .get();
      final stepIds = steps.map((step) => step.id).toList();
      if (stepIds.isNotEmpty) {
        await (delete(recipeStepIngredients)
              ..where((link) => link.recipeStepId.isIn(stepIds)))
            .go();
      }
      await (delete(recipeSteps)
            ..where((step) => step.recipeId.equals(recipeId)))
          .go();
      await (delete(recipeIngredients)
            ..where((link) => link.recipeId.equals(recipeId)))
          .go();
      await (delete(recipesCategories)
            ..where((link) => link.recipeId.equals(recipeId)))
          .go();
    });
  }

  Future<void> retainRemoteRecipes(Set<int> remoteRecipeIds) async {
    final removedRecipeIds = await (selectOnly(recipes)
          ..addColumns([recipes.id])
          ..where(remoteRecipeIds.isEmpty
              ? const Constant(true)
              : recipes.id.isNotIn(remoteRecipeIds)))
        .map((row) => row.read(recipes.id)!)
        .get();
    if (removedRecipeIds.isEmpty) return;

    await (update(mealPlanEntries)
          ..where((entry) => entry.recipeId.isIn(removedRecipeIds)))
        .write(const MealPlanEntriesCompanion(recipeId: Value(null)));
    final statement = delete(recipes);
    statement.where((recipe) => recipe.id.isIn(removedRecipeIds));
    await statement.go();
  }

  Stream<List<RecipeWithCount>> watchFilteredRecipes({
    required Set<int> categoryIds,
    String searchWord = '',
    int? creatorAccountId,
    int? likedByAccountId,
  }) {
    final query = select(recipes).join([
      if (categoryIds.isNotEmpty)
        innerJoin(
          recipesCategories,
          recipesCategories.recipeId.equalsExp(recipes.id),
        ),
      if (likedByAccountId != null)
        innerJoin(
          recipeLikes,
          recipeLikes.recipeId.equalsExp(recipes.id),
        ),
    ])
      ..where(recipes.deletedAt.isNull());

    final trimmedSearch = searchWord.trim();
    if (trimmedSearch.isNotEmpty) {
      query.where(recipes.title.like('%$trimmedSearch%'));
    }
    if (creatorAccountId != null) {
      query.where(recipes.createdBy.equals(creatorAccountId));
    }
    if (categoryIds.isNotEmpty) {
      query.where(
        recipesCategories.categoryId.isIn(categoryIds) &
            recipesCategories.deletedAt.isNull(),
      );
    }
    if (likedByAccountId != null) {
      query.where(
        recipeLikes.accountId.equals(likedByAccountId) &
            recipeLikes.deletedAt.isNull(),
      );
    }
    query.orderBy([OrderingTerm(expression: recipes.title)]);

    return query.watch().map((rows) {
      final uniqueRecipes = <int, Recipe>{};
      for (final row in rows) {
        final recipe = row.readTable(recipes);
        uniqueRecipes[recipe.id] = recipe;
      }
      return uniqueRecipes.values
          .map((recipe) => RecipeWithCount(recipe, 0))
          .toList();
    });
  }

  Stream<List<Recipe>> getRecipeById(int id) =>
      (select(recipes)..where((t) => t.id.equals(id))).watch();

  // TABLE: RecipeStep
  Future<void> insertMultipleRecipeSteps(List<Insertable<RecipeStep>> rows) =>
      _upsertAll(recipeSteps, rows);

  Future<void> insertMultipleIngredients(List<Insertable<Ingredient>> rows) =>
      _upsertAll(ingredients, rows);

  Future<void> upsertIngredient(Ingredient entry) =>
      into(ingredients).insertOnConflictUpdate(entry);

  Future<void> insertMultipleShoppingCategories(
    List<Insertable<ShoppingCategory>> rows,
  ) =>
      _upsertAll(shoppingCategories, rows);

  Future<List<ShoppingCategory>> getShoppingCategories() =>
      (select(shoppingCategories)
            ..where((category) => category.deletedAt.isNull())
            ..orderBy([
              (category) => OrderingTerm(expression: category.sortOrder),
            ]))
          .get();

  Future<void> insertMultipleMeasurementUnits(
      List<Insertable<MeasurementUnit>> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(measurementUnits, list);
    });
  }

  Future<List<MeasurementUnit>> getSelectableMeasurementUnits() =>
      (select(measurementUnits)
            ..where((unit) => unit.selectable.equals(true))
            ..where((unit) => unit.deletedAt.isNull())
            ..orderBy([
              (unit) => OrderingTerm(expression: unit.sortOrder),
              (unit) => OrderingTerm(expression: unit.code),
            ]))
          .get();

  Future<void> insertMultipleRecipeIngredients(
      List<Insertable<RecipeIngredient>> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(recipeIngredients, list);
    });
  }

  Future<void> insertMultipleRecipeStepIngredients(
      List<Insertable<RecipeStepIngredient>> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(recipeStepIngredients, list);
    });
  }

  Stream<List<RecipeStep>> getRecipeStepsByRecipeId(int recipeId) =>
      (select(recipeSteps)
            ..where((s) => s.recipeId.equals(recipeId) & s.deletedAt.isNull())
            ..orderBy([(s) => OrderingTerm.asc(s.stepNr)]))
          .watch();

  Stream<List<IngredientsOfRecipeResult>> getIngredientsByRecipeId(
      int recipeId) {
    return ingredientsOfRecipe(recipeId).watch();
  }

  Stream<List<IngredientsOfRecipeStepResult>> getIngredientsByRecipeStepId(
      int recipeStepId) {
    return ingredientsOfRecipeStep(recipeStepId).watch();
  }

  Future<List<RecipeStep>> getRecipeStepById(int id) =>
      (select(recipeSteps)..where((step) => step.id.equals(id))).get();

  Future<List<RecipeStep>> getRecipeStepByRecipeIdAndStepNr(
          int recipeId, int stepNr) =>
      (select(recipeSteps)
            ..where((step) => step.recipeId.equals(recipeId))
            ..where((step) => step.stepNr.equals(stepNr)))
          .get();

  /// The step the account last viewed in [recipeId], from its history entry.
  Future<List<RecipeStep>> getLastVisitedStep({
    required int recipeId,
    required int accountId,
  }) {
    final visited = histories.recipeId.equalsExp(recipeSteps.recipeId) &
        histories.stepNr.equalsExp(recipeSteps.stepNr);
    final query = select(recipeSteps).join([
      innerJoin(histories, visited, useColumns: false),
    ])
      ..where(histories.accountId.equals(accountId) &
          histories.recipeId.equals(recipeId) &
          recipeSteps.deletedAt.isNull());
    return query.map((row) => row.readTable(recipeSteps)).get();
  }

  // TABLE: Category
  Stream<List<Category>> get allCategoryEntries =>
      (select(categories)..where((c) => c.deletedAt.isNull())).watch();

  Future<void> insertMultipleCategories(List<Insertable<Category>> rows) =>
      _upsertAll(categories, rows);

  /// Non-deleted categories linked to [recipeId].
  JoinedSelectStatement<HasResultSet, dynamic> _categoriesOfRecipeQuery(
    int recipeId,
  ) {
    final linked = recipesCategories.categoryId.equalsExp(categories.id);
    return select(categories).join([
      innerJoin(recipesCategories, linked, useColumns: false),
    ])
      ..where(recipesCategories.recipeId.equals(recipeId) &
          recipesCategories.deletedAt.isNull() &
          categories.deletedAt.isNull());
  }

  Future<List<Category>> getCategoriesOfRecipe(int recipeId) =>
      _categoriesOfRecipeQuery(recipeId)
          .map((row) => row.readTable(categories))
          .get();

  Stream<List<Category>> watchCategoriesOfRecipe(int recipeId) =>
      _categoriesOfRecipeQuery(recipeId)
          .map((row) => row.readTable(categories))
          .watch();

  // TABLE: History
  Future<int> createOrUpdateHistory(HistoriesCompanion entry) =>
      _upsertIfNewer(histories, entry, (h) => h.updatedAt);

  Stream<List<RecipeWithCount>> getAccountHistoryAsRecipes(int accountId) =>
      historyEntriesOfAccountAsRecipes(accountId)
          .map((row) => RecipeWithCount(_recipeFromRow(row), row.numberOfSteps))
          .watch();

  Future<List<History>> getAccountHistory(int accountId, int recipeId) =>
      (select(histories)
            ..where(
                (h) => h.accountId.equals(accountId) & h.recipeId.equals(recipeId)))
          .get();

  /// Remembers the step the account is currently on in [recipeId].
  Future<int> setNewStep({
    required int accountId,
    required int recipeId,
    required int stepNr,
  }) =>
      (update(histories)
            ..where(
                (h) => h.accountId.equals(accountId) & h.recipeId.equals(recipeId)))
          .write(HistoriesCompanion(
        stepNr: Value(stepNr),
        updatedAt: Value(DateTime.now().toUtc()),
      ));

  Future<List<History>> notSyncedHistoryEntries(DateTime since) =>
      (select(histories)..where((h) => h.updatedAt.isBiggerThanValue(since)))
          .get();

  /// Recipes that another device asked this account to open.
  Future<List<Recipe>> getRecipeToOpen(int accountId) =>
      openRecipe(accountId).map(_recipeFromRow).get();

  // TABLE: Recipe_Category
  Future<void> insertMultipleRecipeCategories(
    List<Insertable<RecipeCategory>> rows,
  ) =>
      _upsertAll(recipesCategories, rows);

  // TABLE: Comments
  Future<List<Comment>> notSyncedCommentEntries(
    DateTime timestamp,
    int accountId,
  ) =>
      (select(comments)
            ..where((comment) =>
                comment.accountId.equals(accountId) &
                comment.updatedAt.isBiggerThanValue(timestamp)))
          .get();

  Future<int> createOrUpdateComment(CommentsCompanion entry) =>
      _upsertIfNewer(comments, entry, (c) => c.updatedAt);

  Future<int> updateComment(CommentsCompanion entry) =>
      (update(comments)..where((c) => c.id.equals(entry.id.value)))
          .write(entry);

  Stream<List<CommentWithAccount>> watchCommentsForRecipe(int recipeId) =>
      _watchComments(comments.recipeId.equals(recipeId));

  Stream<List<CommentWithAccount>> watchCommentsForAccount(int accountId) =>
      _watchComments(comments.accountId.equals(accountId));

  Stream<List<CommentWithAccount>> _watchComments(Expression<bool> filter) {
    final query = select(comments).join([
      innerJoin(accounts, accounts.id.equalsExp(comments.accountId)),
    ])
      ..where(filter & comments.deletedAt.isNull())
      ..orderBy([OrderingTerm.desc(comments.createdAt)]);

    return query.watch().map((rows) => rows
        .map((row) => CommentWithAccount(
              comment: row.readTable(comments),
              accountName: row.readTable(accounts).accountName,
            ))
        .toList());
  }

  // TABLE: Roles
  static const _assignableRoles = ['viewer', 'editor', 'admin'];

  Future<List<Role>> get allRoleEntries => (select(roles)
        ..where((r) => r.deletedAt.isNull() & r.name.isIn(_assignableRoles)))
      .get();

  Future<void> insertMultipleRoles(List<Insertable<Role>> rows) =>
      _upsertAll(roles, rows);

  Future<List<Role>> getRoleById(int id) =>
      (select(roles)..where((r) => r.id.equals(id))).get();

  // TABLE: Accounts
  Stream<List<Account>> get allAccountEntriesAsStream =>
      (select(accounts)..where((a) => a.deletedAt.isNull())).watch();

  Future<void> insertMultipleAccounts(List<Insertable<Account>> rows) =>
      _upsertAll(accounts, rows);

  Future<List<Account>> getAccountSortedById() => (select(accounts)
        ..where((a) => a.deletedAt.isNull())
        ..orderBy([(a) => OrderingTerm.asc(a.id)]))
      .get();

  Future<List<Account>> getAccountById(int id) =>
      (select(accounts)..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
          .get();

  Future<void> insertMultipleProfiles(List<Insertable<Profile>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(profiles, entries);
    });
  }

  Future<void> retainRemoteProfilesForAccount(
    int accountId,
    Set<int> remoteProfileIds,
  ) async {
    final statement = delete(profiles)
      ..where((profile) => remoteProfileIds.isEmpty
          ? profile.accountId.equals(accountId)
          : profile.accountId.equals(accountId) &
              profile.id.isNotIn(remoteProfileIds));
    await statement.go();
  }

  Future<List<Map<String, dynamic>>> getProfilesForAccount(
      int accountId) async {
    final query = select(profiles).join([
      innerJoin(roles, roles.id.equalsExp(profiles.roleId)),
    ])
      ..where(
          profiles.accountId.equals(accountId) & profiles.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: profiles.name)]);
    final rows = await query.get();
    return rows.map((row) {
      final profile = row.readTable(profiles);
      return {
        'id': profile.id,
        'name': profile.name,
        'role_id': profile.roleId,
        'role_name': row.readTable(roles).name,
      };
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> watchProfilesForAccount(int accountId) {
    final query = select(profiles).join([
      innerJoin(roles, roles.id.equalsExp(profiles.roleId)),
    ])
      ..where(
          profiles.accountId.equals(accountId) & profiles.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: profiles.name)]);
    return query.watch().map((rows) => rows.map((row) {
          final profile = row.readTable(profiles);
          return {
            'id': profile.id,
            'name': profile.name,
            'role_id': profile.roleId,
            'role_name': row.readTable(roles).name,
          };
        }).toList());
  }

  Stream<String?> watchAccountRoleName(int accountId) {
    final query = select(accounts).join([
      innerJoin(roles, roles.id.equalsExp(accounts.roleId)),
    ])
      ..where(accounts.id.equals(accountId) & accounts.deletedAt.isNull());
    return query
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.first.readTable(roles).name);
  }

  Stream<({String? accountRole, String? profileRole})> watchContentRoleNames(
    int accountId,
    int profileId,
  ) {
    final accountRoles = alias(roles, 'content_account_roles');
    final profileRoles = alias(roles, 'content_profile_roles');
    final query = select(accounts).join([
      innerJoin(
        accountRoles,
        accountRoles.id.equalsExp(accounts.roleId),
      ),
      innerJoin(
        profiles,
        profiles.id.equals(profileId) &
            profiles.accountId.equals(accountId) &
            profiles.deletedAt.isNull(),
      ),
      innerJoin(
        profileRoles,
        profileRoles.id.equalsExp(profiles.roleId),
      ),
    ])
      ..where(accounts.id.equals(accountId) & accounts.deletedAt.isNull());
    return query.watch().map((rows) {
      if (rows.isEmpty) {
        return (accountRole: null, profileRole: null);
      }
      final row = rows.first;
      return (
        accountRole: row.readTable(accountRoles).name,
        profileRole: row.readTable(profileRoles).name,
      );
    });
  }

  Stream<List<Account>> watchAccountById(int id) => (select(accounts)
        ..where((t) => t.id.equals(id))
        ..where((t) => t.deletedAt.isNull()))
      .watch();

  Stream<List<Recipe>> watchRecipesByCreator(int accountId) => (select(recipes)
        ..where((t) => t.createdBy.equals(accountId))
        ..where((t) => t.deletedAt.isNull())
        ..orderBy([
          (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
        ]))
      .watch();

  Future<void> insertMultipleAccountFollows(
      List<Insertable<AccountFollow>> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(accountFollows, list);
    });
  }

  Future<void> insertMultipleAccountFriends(
    List<Insertable<AccountFriend>> entries,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(accountFriends, entries);
    });
  }

  Future<void> upsertAccountFriend(AccountFriend friendship) =>
      into(accountFriends).insertOnConflictUpdate(friendship);

  Future<AccountFriend?> getAccountFriend(int firstId, int secondId) {
    final low = firstId < secondId ? firstId : secondId;
    final high = firstId < secondId ? secondId : firstId;
    return (select(accountFriends)
          ..where((row) => row.firstAccountId.equals(low))
          ..where((row) => row.secondAccountId.equals(high)))
        .getSingleOrNull();
  }

  Stream<List<FriendConnection>> watchFriendConnections(int accountId) {
    final query = select(accountFriends).join([
      innerJoin(
        accounts,
        accounts.id.equalsExp(accountFriends.firstAccountId) |
            accounts.id.equalsExp(accountFriends.secondAccountId),
      ),
    ])
      ..where(accountFriends.firstAccountId.equals(accountId) |
          accountFriends.secondAccountId.equals(accountId))
      ..where(accountFriends.deletedAt.isNull())
      ..where(accounts.id.equals(accountId).not())
      ..orderBy([OrderingTerm(expression: accounts.accountName)]);
    return query.watch().map(
          (rows) => rows
              .map((row) => FriendConnection(
                    friendship: row.readTable(accountFriends),
                    account: row.readTable(accounts),
                  ))
              .toList(),
        );
  }

  Future<List<Account>> getAcceptedFriendAccounts(int accountId) async =>
      (await watchFriendConnections(accountId).first)
          .where((connection) => connection.friendship.status == 'accepted')
          .map((connection) => connection.account)
          .toList();

  Future<void> insertMultipleChatConversations(
    List<Insertable<ChatConversation>> entries,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(chatConversations, entries);
    });
  }

  Future<void> insertMultipleChatMessages(
    List<Insertable<ChatMessage>> entries,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(chatMessages, entries);
    });
  }

  Future<void> insertMultipleChatMessageReactions(
    List<Insertable<ChatMessageReaction>> entries,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(chatMessageReactions, entries);
    });
  }

  Future<void> upsertChatConversation(ChatConversation conversation) =>
      into(chatConversations).insertOnConflictUpdate(conversation);

  Future<void> upsertChatMessage(ChatMessage message) =>
      into(chatMessages).insertOnConflictUpdate(message);

  Future<void> upsertChatMessageReaction(ChatMessageReaction reaction) =>
      into(chatMessageReactions).insertOnConflictUpdate(reaction);

  Future<ChatConversation?> getChatConversation(
    int firstAccountId,
    int secondAccountId,
  ) =>
      (select(chatConversations)
            ..where((row) => row.firstAccountId.equals(firstAccountId))
            ..where((row) => row.secondAccountId.equals(secondAccountId)))
          .getSingleOrNull();

  Stream<List<ChatConversationWithAccount>> watchChatConversations(
    int accountId,
  ) {
    final query = select(chatConversations).join([
      innerJoin(
        accounts,
        accounts.id.equalsExp(chatConversations.firstAccountId) |
            accounts.id.equalsExp(chatConversations.secondAccountId),
      ),
    ])
      ..where(chatConversations.firstAccountId.equals(accountId) |
          chatConversations.secondAccountId.equals(accountId))
      ..where(chatConversations.deletedAt.isNull())
      ..where(accounts.id.equals(accountId).not())
      ..where(accounts.deletedAt.isNull())
      ..orderBy([
        OrderingTerm.desc(chatConversations.updatedAt),
      ]);
    return query.watch().map(
          (rows) => rows
              .map((row) => ChatConversationWithAccount(
                    conversation: row.readTable(chatConversations),
                    account: row.readTable(accounts),
                  ))
              .toList(),
        );
  }

  Stream<List<ChatMessage>> watchChatMessages(
    int firstAccountId,
    int secondAccountId,
  ) =>
      (select(chatMessages)
            ..where((row) => row.firstAccountId.equals(firstAccountId))
            ..where((row) => row.secondAccountId.equals(secondAccountId))
            ..where((row) => row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
          .watch();

  Stream<List<ChatMessage>> watchLatestChatMessage(
    int firstAccountId,
    int secondAccountId,
  ) =>
      (select(chatMessages)
            ..where((row) => row.firstAccountId.equals(firstAccountId))
            ..where((row) => row.secondAccountId.equals(secondAccountId))
            ..where((row) => row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
            ..limit(1))
          .watch();

  Stream<int> watchUnreadChatMessageCount(int accountId) =>
      (select(chatMessages)
            ..where((message) =>
                (message.firstAccountId.equals(accountId) |
                    message.secondAccountId.equals(accountId)) &
                message.senderAccountId.equals(accountId).not() &
                message.readAt.isNull() &
                message.deletedAt.isNull()))
          .watch()
          .map((messages) => messages.length);

  Stream<int> watchUnreadChatMessageCountForConversation(
    int accountId,
    int firstAccountId,
    int secondAccountId,
  ) =>
      (select(chatMessages)
            ..where((message) =>
                message.firstAccountId.equals(firstAccountId) &
                message.secondAccountId.equals(secondAccountId) &
                message.senderAccountId.equals(accountId).not() &
                message.readAt.isNull() &
                message.deletedAt.isNull()))
          .watch()
          .map((messages) => messages.length);

  Future<int> markChatMessagesReadLocally({
    required int accountId,
    required int friendAccountId,
    required DateTime readAt,
  }) {
    final firstId = accountId < friendAccountId ? accountId : friendAccountId;
    final secondId = accountId < friendAccountId ? friendAccountId : accountId;
    return (update(chatMessages)
          ..where((message) =>
              message.firstAccountId.equals(firstId) &
              message.secondAccountId.equals(secondId) &
              message.senderAccountId.equals(friendAccountId) &
              message.readAt.isNull() &
              message.deletedAt.isNull()))
        .write(ChatMessagesCompanion(
      readAt: Value(readAt),
      updatedAt: Value(readAt),
      updatedBy: Value(accountId),
    ));
  }

  Stream<List<ChatMessageReaction>> watchChatMessageReactions(int messageId) =>
      (select(chatMessageReactions)
            ..where((row) => row.messageId.equals(messageId))
            ..where((row) => row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
          .watch();

  Future<ChatMessage?> getChatMessage(int messageId) =>
      (select(chatMessages)..where((row) => row.id.equals(messageId)))
          .getSingleOrNull();

  Future<ChatMessageReaction?> getChatMessageReaction(
    int messageId,
    int accountId,
  ) =>
      (select(chatMessageReactions)
            ..where((row) => row.messageId.equals(messageId))
            ..where((row) => row.accountId.equals(accountId)))
          .getSingleOrNull();

  Future<void> removeSharedAccessBetweenAccounts(
    int accountId,
    int friendAccountId,
    DateTime removedAt,
  ) async {
    await transaction(() async {
      final lists = await (select(shoppingLists)
            ..where(
                (list) => list.accountId.isIn([accountId, friendAccountId])))
          .get();
      for (final list in lists) {
        final memberId =
            list.accountId == accountId ? friendAccountId : accountId;
        await (update(shoppingListMembers)
              ..where((member) =>
                  member.shoppingListId.equals(list.id) &
                  member.accountId.equals(memberId)))
            .write(ShoppingListMembersCompanion(
          updatedAt: Value(removedAt),
          updatedBy: Value(accountId),
          deletedAt: Value(removedAt),
          deletedBy: Value(accountId),
        ));
      }

      final plans = await (select(mealPlans)
            ..where(
                (plan) => plan.accountId.isIn([accountId, friendAccountId])))
          .get();
      for (final plan in plans) {
        final memberId =
            plan.accountId == accountId ? friendAccountId : accountId;
        await (update(mealPlanMembers)
              ..where((member) =>
                  member.mealPlanId.equals(plan.id) &
                  member.accountId.equals(memberId)))
            .write(MealPlanMembersCompanion(
          updatedAt: Value(removedAt),
          updatedBy: Value(accountId),
          deletedAt: Value(removedAt),
          deletedBy: Value(accountId),
        ));
      }
    });
  }

  // TABLE: Recipe likes
  Future<void> insertMultipleRecipeLikes(
      List<Insertable<RecipeLike>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(recipeLikes, entries);
    });
  }

  Future<void> upsertRecipeLike(RecipeLike entry) =>
      into(recipeLikes).insertOnConflictUpdate(entry);

  Stream<List<RecipeLike>> watchRecipeLike({
    required int accountId,
    required int recipeId,
  }) =>
      (select(recipeLikes)
            ..where((like) =>
                like.accountId.equals(accountId) &
                like.recipeId.equals(recipeId))
            ..where((like) => like.deletedAt.isNull()))
          .watch();

  // TABLE: Shopping lists
  Future<void> insertMultipleShoppingLists(
      List<Insertable<ShoppingList>> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(shoppingLists, list);
    });
  }

  Future<void> insertMultipleShoppingListItems(
      List<Insertable<ShoppingListItem>> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(shoppingListItems, list);
    });
  }

  Future<void> insertMultipleShoppingListSections(
      List<Insertable<ShoppingListSection>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(shoppingListSections, entries);
    });
  }

  Future<void> insertMultipleShoppingListMembers(
      List<Insertable<ShoppingListMember>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(shoppingListMembers, entries);
    });
  }

  Future<void> upsertShoppingListMember(ShoppingListMember entry) =>
      into(shoppingListMembers).insertOnConflictUpdate(entry);

  Future<void> upsertShoppingList(ShoppingList entry) =>
      into(shoppingLists).insertOnConflictUpdate(entry);

  Future<void> upsertShoppingListItem(ShoppingListItem entry) =>
      into(shoppingListItems).insertOnConflictUpdate(entry);

  Future<void> upsertShoppingListSection(ShoppingListSection entry) =>
      into(shoppingListSections).insertOnConflictUpdate(entry);

  Future<ShoppingList?> getShoppingListById(int id) =>
      (select(shoppingLists)..where((list) => list.id.equals(id)))
          .getSingleOrNull();

  Future<Set<int>> getShoppingListIds() =>
      (selectOnly(shoppingLists)..addColumns([shoppingLists.id]))
          .map((row) => row.read(shoppingLists.id)!)
          .get()
          .then((ids) => ids.toSet());

  Future<Set<int>> getShoppingListItemIds() =>
      (selectOnly(shoppingListItems)..addColumns([shoppingListItems.id]))
          .map((row) => row.read(shoppingListItems.id)!)
          .get()
          .then((ids) => ids.toSet());

  Future<Set<int>> getShoppingListSectionIds() =>
      (selectOnly(shoppingListSections)..addColumns([shoppingListSections.id]))
          .map((row) => row.read(shoppingListSections.id)!)
          .get()
          .then((ids) => ids.toSet());

  Future<ShoppingListItem?> getShoppingListItemById(int id) =>
      (select(shoppingListItems)..where((item) => item.id.equals(id)))
          .getSingleOrNull();

  Future<ShoppingListSection?> getShoppingListSectionById(int id) =>
      (select(shoppingListSections)..where((section) => section.id.equals(id)))
          .getSingleOrNull();

  Future<Ingredient?> getIngredientById(int id) =>
      (select(ingredients)..where((ingredient) => ingredient.id.equals(id)))
          .getSingleOrNull();

  Stream<List<ShoppingList>> watchShoppingListsForAccount(int accountId) {
    final sharedListIds = selectOnly(shoppingListMembers)
      ..addColumns([shoppingListMembers.shoppingListId])
      ..where(shoppingListMembers.accountId.equals(accountId) &
          shoppingListMembers.status.equals('accepted') &
          shoppingListMembers.deletedAt.isNull());
    return (select(shoppingLists)
          ..where((list) =>
              list.accountId.equals(accountId) |
              list.id.isInQuery(sharedListIds))
          ..where((list) => list.deletedAt.isNull())
          ..orderBy([
            (list) => OrderingTerm(expression: list.name),
          ]))
        .watch();
  }

  Future<List<ShoppingList>> getShoppingListsForAccount(int accountId) =>
      watchShoppingListsForAccount(accountId).first;

  Future<List<ShoppingList>> getShoppingListsShareableWithAccount(
    int accountId,
    int recipientAccountId,
  ) async {
    final accessibleLists = await getShoppingListsForAccount(accountId);
    final recipientMemberships = await (select(shoppingListMembers)
          ..where((member) =>
              member.accountId.equals(recipientAccountId) &
              member.status.equals('accepted') &
              member.deletedAt.isNull()))
        .get();
    final recipientMemberListIds = recipientMemberships
        .map((membership) => membership.shoppingListId)
        .toSet();
    return accessibleLists
        .where((list) =>
            list.accountId == recipientAccountId ||
            recipientMemberListIds.contains(list.id))
        .toList();
  }

  Stream<List<ShoppingList>> watchAccessibleShoppingListById(
    int accountId,
    int listId,
  ) {
    final acceptedMemberships = selectOnly(shoppingListMembers)
      ..addColumns([shoppingListMembers.shoppingListId])
      ..where(shoppingListMembers.accountId.equals(accountId) &
          shoppingListMembers.status.equals('accepted') &
          shoppingListMembers.deletedAt.isNull());
    return (select(shoppingLists)
          ..where((list) =>
              list.id.equals(listId) &
              (list.accountId.equals(accountId) |
                  list.id.isInQuery(acceptedMemberships)))
          ..where((list) => list.deletedAt.isNull()))
        .watch();
  }

  Future<void> retainAccessibleShoppingLists(Set<int> remoteListIds) async {
    final removedListIds = await (selectOnly(shoppingLists)
          ..addColumns([shoppingLists.id])
          ..where(remoteListIds.isEmpty
              ? const Constant(true)
              : shoppingLists.id.isNotIn(remoteListIds)))
        .map((row) => row.read(shoppingLists.id)!)
        .get();
    if (removedListIds.isEmpty) return;

    await transaction(() async {
      await (delete(shoppingListItems)
            ..where((item) => item.shoppingListId.isIn(removedListIds)))
          .go();
      await (delete(shoppingListSections)
            ..where((section) => section.shoppingListId.isIn(removedListIds)))
          .go();
      await (delete(shoppingListMembers)
            ..where((member) => member.shoppingListId.isIn(removedListIds)))
          .go();
      await (delete(shoppingLists)
            ..where((list) => list.id.isIn(removedListIds)))
          .go();
    });
  }

  Stream<List<ShoppingListMember>> watchShoppingListMembers(int listId) =>
      (select(shoppingListMembers)
            ..where((member) => member.shoppingListId.equals(listId))
            ..where((member) => member.deletedAt.isNull())
            ..orderBy([(member) => OrderingTerm(expression: member.accountId)]))
          .watch();

  Stream<List<SharedResourceParticipant>> watchShoppingListParticipants(
    int listId,
    int ownerAccountId,
  ) =>
      watchShoppingListMembers(listId).asyncMap((members) async {
        final accountRows = await getAccountSortedById();
        final accountsById = {
          for (final account in accountRows) account.id: account,
        };
        final participants = <SharedResourceParticipant>[];
        final owner = accountsById[ownerAccountId];
        if (owner != null) {
          participants.add(SharedResourceParticipant(
            account: owner,
            permission: 'owner',
            status: 'accepted',
            isOwner: true,
          ));
        }
        for (final member in members) {
          if (member.status == 'declined') continue;
          final account = accountsById[member.accountId];
          if (account == null || account.id == ownerAccountId) continue;
          participants.add(SharedResourceParticipant(
            account: account,
            permission: member.permission,
            status: member.status,
            isOwner: false,
          ));
        }
        participants.sort((first, second) {
          if (first.isOwner != second.isOwner) return first.isOwner ? -1 : 1;
          return first.account.accountName.toLowerCase().compareTo(
                second.account.accountName.toLowerCase(),
              );
        });
        return participants;
      });

  Future<ShoppingListMember?> getShoppingListMember(
    int listId,
    int accountId,
  ) =>
      (select(shoppingListMembers)
            ..where((member) => member.shoppingListId.equals(listId))
            ..where((member) => member.accountId.equals(accountId)))
          .getSingleOrNull();

  Stream<List<SharedResourceInvitation>> watchPendingShoppingListInvitations(
      int accountId) {
    final query = select(shoppingListMembers).join([
      innerJoin(
        shoppingLists,
        shoppingLists.id.equalsExp(shoppingListMembers.shoppingListId),
      ),
      innerJoin(accounts, accounts.id.equalsExp(shoppingLists.accountId)),
    ])
      ..where(shoppingListMembers.accountId.equals(accountId))
      ..where(shoppingListMembers.status.equals('pending'))
      ..where(shoppingListMembers.deletedAt.isNull())
      ..where(shoppingLists.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: shoppingLists.name)]);
    return query.watch().map(
          (rows) => rows
              .map((row) => SharedResourceInvitation(
                    resourceId: row.readTable(shoppingLists).id,
                    resourceName: row.readTable(shoppingLists).name,
                    ownerAccountName: row.readTable(accounts).accountName,
                    permission: row.readTable(shoppingListMembers).permission,
                  ))
              .toList(),
        );
  }

  Future<bool> canEditShoppingList(int accountId, int listId) async {
    final list = await getShoppingListById(listId);
    if (list?.accountId == accountId) return true;
    final member = await (select(shoppingListMembers)
          ..where((row) => row.shoppingListId.equals(listId))
          ..where((row) => row.accountId.equals(accountId))
          ..where((row) => row.permission.equals('editor'))
          ..where((row) => row.status.equals('accepted'))
          ..where((row) => row.deletedAt.isNull()))
        .getSingleOrNull();
    return member != null;
  }

  Stream<bool> watchCanEditShoppingList(int accountId, int listId) {
    final query = select(shoppingLists).join([
      leftOuterJoin(
        shoppingListMembers,
        shoppingListMembers.shoppingListId.equalsExp(shoppingLists.id) &
            shoppingListMembers.accountId.equals(accountId),
      ),
    ])
      ..where(shoppingLists.id.equals(listId))
      ..where(shoppingLists.deletedAt.isNull());
    return query.watch().map((rows) {
      if (rows.isEmpty) return false;
      final list = rows.first.readTable(shoppingLists);
      if (list.accountId == accountId) return true;
      final member = rows.first.readTableOrNull(shoppingListMembers);
      return member?.permission == 'editor' &&
          member?.status == 'accepted' &&
          member?.deletedAt == null;
    }).distinct();
  }

  Stream<List<ShoppingListItem>> watchShoppingListItems(int shoppingListId) =>
      (select(shoppingListItems)
            ..where((item) => item.shoppingListId.equals(shoppingListId))
            ..where((item) => item.deletedAt.isNull())
            ..orderBy([
              (item) => OrderingTerm(expression: item.checked),
              (item) => OrderingTerm(expression: item.name),
            ]))
          .watch();

  Stream<List<ShoppingListSection>> watchShoppingListSections(
    int shoppingListId,
  ) =>
      (select(shoppingListSections)
            ..where((section) => section.shoppingListId.equals(shoppingListId))
            ..where((section) => section.deletedAt.isNull())
            ..orderBy([
              (section) => OrderingTerm(expression: section.sortOrder),
              (section) => OrderingTerm(expression: section.name),
            ]))
          .watch();

  Future<List<ShoppingListItem>> getShoppingListItemsInSection(
    int sectionId,
  ) =>
      (select(shoppingListItems)
            ..where((item) => item.sectionId.equals(sectionId))
            ..where((item) => item.deletedAt.isNull()))
          .get();

  // TABLE: Meal plan
  Future<void> insertMultipleMealPlans(
      List<Insertable<MealPlan>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(mealPlans, entries);
    });
  }

  Future<void> insertMultipleMealPlanMembers(
      List<Insertable<MealPlanMember>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(mealPlanMembers, entries);
    });
  }

  Future<void> upsertMealPlan(MealPlan plan) =>
      into(mealPlans).insertOnConflictUpdate(plan);

  Future<void> upsertMealPlanMember(MealPlanMember member) =>
      into(mealPlanMembers).insertOnConflictUpdate(member);

  Future<MealPlan?> getMealPlanById(int id) =>
      (select(mealPlans)..where((plan) => plan.id.equals(id)))
          .getSingleOrNull();

  Future<Set<int>> getMealPlanIds() =>
      (selectOnly(mealPlans)..addColumns([mealPlans.id]))
          .map((row) => row.read(mealPlans.id)!)
          .get()
          .then((ids) => ids.toSet());

  Future<Set<int>> getMealPlanEntryIds() =>
      (selectOnly(mealPlanEntries)..addColumns([mealPlanEntries.id]))
          .map((row) => row.read(mealPlanEntries.id)!)
          .get()
          .then((ids) => ids.toSet());

  Stream<List<MealPlan>> watchMealPlansForAccount(int accountId) {
    final sharedPlanIds = selectOnly(mealPlanMembers)
      ..addColumns([mealPlanMembers.mealPlanId])
      ..where(mealPlanMembers.accountId.equals(accountId) &
          mealPlanMembers.status.equals('accepted') &
          mealPlanMembers.deletedAt.isNull());
    return (select(mealPlans)
          ..where((plan) =>
              plan.accountId.equals(accountId) |
              plan.id.isInQuery(sharedPlanIds))
          ..where((plan) => plan.deletedAt.isNull())
          ..orderBy([(plan) => OrderingTerm(expression: plan.name)]))
        .watch();
  }

  Future<void> retainAccessibleMealPlans(Set<int> remotePlanIds) async {
    final removedPlanIds = await (selectOnly(mealPlans)
          ..addColumns([mealPlans.id])
          ..where(remotePlanIds.isEmpty
              ? const Constant(true)
              : mealPlans.id.isNotIn(remotePlanIds)))
        .map((row) => row.read(mealPlans.id)!)
        .get();
    if (removedPlanIds.isEmpty) return;

    await transaction(() async {
      await (delete(mealPlanEntries)
            ..where((entry) => entry.mealPlanId.isIn(removedPlanIds)))
          .go();
      await (delete(mealPlanMembers)
            ..where((member) => member.mealPlanId.isIn(removedPlanIds)))
          .go();
      await (delete(mealPlans)..where((plan) => plan.id.isIn(removedPlanIds)))
          .go();
    });
  }

  Stream<List<MealPlanMember>> watchMealPlanMembers(int planId) =>
      (select(mealPlanMembers)
            ..where((member) => member.mealPlanId.equals(planId))
            ..where((member) => member.deletedAt.isNull())
            ..orderBy([(member) => OrderingTerm(expression: member.accountId)]))
          .watch();

  Stream<List<SharedResourceParticipant>> watchMealPlanParticipants(
    int planId,
    int ownerAccountId,
  ) =>
      watchMealPlanMembers(planId).asyncMap((members) async {
        final accountRows = await getAccountSortedById();
        final accountsById = {
          for (final account in accountRows) account.id: account,
        };
        final participants = <SharedResourceParticipant>[];
        final owner = accountsById[ownerAccountId];
        if (owner != null) {
          participants.add(SharedResourceParticipant(
            account: owner,
            permission: 'owner',
            status: 'accepted',
            isOwner: true,
          ));
        }
        for (final member in members) {
          if (member.status == 'declined') continue;
          final account = accountsById[member.accountId];
          if (account == null || account.id == ownerAccountId) continue;
          participants.add(SharedResourceParticipant(
            account: account,
            permission: member.permission,
            status: member.status,
            isOwner: false,
          ));
        }
        participants.sort((first, second) {
          if (first.isOwner != second.isOwner) return first.isOwner ? -1 : 1;
          return first.account.accountName.toLowerCase().compareTo(
                second.account.accountName.toLowerCase(),
              );
        });
        return participants;
      });

  Future<MealPlanMember?> getMealPlanMember(int planId, int accountId) =>
      (select(mealPlanMembers)
            ..where((member) => member.mealPlanId.equals(planId))
            ..where((member) => member.accountId.equals(accountId)))
          .getSingleOrNull();

  Stream<List<SharedResourceInvitation>> watchPendingMealPlanInvitations(
    int accountId,
  ) {
    final query = select(mealPlanMembers).join([
      innerJoin(
        mealPlans,
        mealPlans.id.equalsExp(mealPlanMembers.mealPlanId),
      ),
      innerJoin(accounts, accounts.id.equalsExp(mealPlans.accountId)),
    ])
      ..where(mealPlanMembers.accountId.equals(accountId))
      ..where(mealPlanMembers.status.equals('pending'))
      ..where(mealPlanMembers.deletedAt.isNull())
      ..where(mealPlans.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: mealPlans.name)]);
    return query.watch().map(
          (rows) => rows
              .map((row) => SharedResourceInvitation(
                    resourceId: row.readTable(mealPlans).id,
                    resourceName: row.readTable(mealPlans).name,
                    ownerAccountName: row.readTable(accounts).accountName,
                    permission: row.readTable(mealPlanMembers).permission,
                  ))
              .toList(),
        );
  }

  Future<bool> canEditMealPlan(int accountId, int planId) async {
    final plan = await getMealPlanById(planId);
    if (plan?.accountId == accountId) return true;
    final member = await (select(mealPlanMembers)
          ..where((row) => row.mealPlanId.equals(planId))
          ..where((row) => row.accountId.equals(accountId))
          ..where((row) => row.permission.equals('editor'))
          ..where((row) => row.status.equals('accepted'))
          ..where((row) => row.deletedAt.isNull()))
        .getSingleOrNull();
    return member != null;
  }

  Stream<bool> watchCanEditMealPlan(int accountId, int planId) {
    final query = select(mealPlans).join([
      leftOuterJoin(
        mealPlanMembers,
        mealPlanMembers.mealPlanId.equalsExp(mealPlans.id) &
            mealPlanMembers.accountId.equals(accountId),
      ),
    ])
      ..where(mealPlans.id.equals(planId))
      ..where(mealPlans.deletedAt.isNull());
    return query.watch().map((rows) {
      if (rows.isEmpty) return false;
      final plan = rows.first.readTable(mealPlans);
      if (plan.accountId == accountId) return true;
      final member = rows.first.readTableOrNull(mealPlanMembers);
      return member?.permission == 'editor' &&
          member?.status == 'accepted' &&
          member?.deletedAt == null;
    }).distinct();
  }

  Future<void> insertMultipleMealPlanEntries(
      List<Insertable<MealPlanEntry>> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(mealPlanEntries, entries);
    });
  }

  Future<void> upsertMealPlanEntry(MealPlanEntry entry) =>
      into(mealPlanEntries).insertOnConflictUpdate(entry.toCompanion(false));

  Future<MealPlanEntry?> getMealPlanEntryById(int id) =>
      (select(mealPlanEntries)..where((entry) => entry.id.equals(id)))
          .getSingleOrNull();

  Stream<List<MealPlanEntry>> watchMealPlanEntriesForWeek(
    int mealPlanId,
    DateTime weekStart,
    DateTime weekEnd,
  ) =>
      (select(mealPlanEntries)
            ..where((entry) => entry.mealPlanId.equals(mealPlanId))
            ..where((entry) =>
                entry.plannedDate.isBiggerOrEqualValue(weekStart) &
                entry.plannedDate.isSmallerThanValue(weekEnd))
            ..where((entry) => entry.deletedAt.isNull())
            ..orderBy([
              (entry) => OrderingTerm(expression: entry.plannedDate),
              (entry) => OrderingTerm(expression: entry.mealSlot),
              (entry) => OrderingTerm(expression: entry.sortOrder),
              (entry) => OrderingTerm(expression: entry.createdAt),
              (entry) => OrderingTerm(expression: entry.id),
            ]))
          .watch();

  Future<List<Recipe>> getSelectableRecipes() => (select(recipes)
        ..where((recipe) => recipe.deletedAt.isNull())
        ..orderBy([(recipe) => OrderingTerm(expression: recipe.title)]))
      .get();

  Stream<List<Recipe>> watchSelectableRecipes() => (select(recipes)
        ..where((recipe) => recipe.deletedAt.isNull())
        ..orderBy([(recipe) => OrderingTerm(expression: recipe.title)]))
      .watch();

  Future<bool> hasCompleteRecipeGraph(int recipeId) async {
    final ingredients = await getIngredientsByRecipeId(recipeId).first;
    final steps = await getRecipeStepsByRecipeId(recipeId).first;
    return ingredients.isNotEmpty && steps.isNotEmpty;
  }

  Future<List<MealPlanEntry>> getMealPlanEntriesForWeek(
    int mealPlanId,
    DateTime weekStart,
    DateTime weekEnd,
  ) =>
      (select(mealPlanEntries)
            ..where((entry) => entry.mealPlanId.equals(mealPlanId))
            ..where((entry) =>
                entry.plannedDate.isBiggerOrEqualValue(weekStart) &
                entry.plannedDate.isSmallerThanValue(weekEnd))
            ..where((entry) => entry.deletedAt.isNull())
            ..orderBy([
              (entry) => OrderingTerm(expression: entry.plannedDate),
              (entry) => OrderingTerm(expression: entry.mealSlot),
              (entry) => OrderingTerm(expression: entry.sortOrder),
            ]))
          .get();

  Future<void> insertMultipleMealPlanTemplates(
    List<Insertable<MealPlanTemplate>> templates,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(mealPlanTemplates, templates);
    });
  }

  Future<void> upsertMealPlanTemplate(MealPlanTemplate template) =>
      into(mealPlanTemplates).insertOnConflictUpdate(
        template.toCompanion(false),
      );

  Future<void> upsertMealPlanTemplateEntry(
    MealPlanTemplateEntry entry,
  ) =>
      into(mealPlanTemplateEntries).insertOnConflictUpdate(
        entry.toCompanion(false),
      );

  Future<MealPlanTemplate?> getMealPlanTemplateById(int id) =>
      (select(mealPlanTemplates)..where((template) => template.id.equals(id)))
          .getSingleOrNull();

  Future<void> insertMultipleMealPlanTemplateEntries(
    List<Insertable<MealPlanTemplateEntry>> entries,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(mealPlanTemplateEntries, entries);
    });
  }

  Stream<List<MealPlanTemplate>> watchMealPlanTemplates(int accountId) =>
      (select(mealPlanTemplates)
            ..where((template) => template.accountId.equals(accountId))
            ..where((template) => template.deletedAt.isNull())
            ..orderBy([(template) => OrderingTerm(expression: template.name)]))
          .watch();

  Future<List<MealPlanTemplate>> getMealPlanTemplates(int accountId) =>
      (select(mealPlanTemplates)
            ..where((template) => template.accountId.equals(accountId))
            ..where((template) => template.deletedAt.isNull())
            ..orderBy([(template) => OrderingTerm(expression: template.name)]))
          .get();

  Future<List<MealPlanTemplateEntry>> getMealPlanTemplateEntries(
    int templateId,
  ) =>
      (select(mealPlanTemplateEntries)
            ..where((entry) => entry.templateId.equals(templateId))
            ..where((entry) => entry.deletedAt.isNull())
            ..orderBy([
              (entry) => OrderingTerm(expression: entry.dayOffset),
              (entry) => OrderingTerm(expression: entry.mealSlot),
              (entry) => OrderingTerm(expression: entry.sortOrder),
            ]))
          .get();

  Future<void> enqueueMutation(PendingMutationsCompanion mutation) =>
      into(pendingMutations).insert(mutation);

  Future<List<PendingMutation>> getPendingMutationsForAccount(int accountId) =>
      (select(pendingMutations)
            ..where((mutation) => mutation.blocked.equals(false))
            ..where((mutation) => mutation.accountId.equals(accountId))
            ..orderBy([
              (mutation) => OrderingTerm(expression: mutation.createdAt),
            ]))
          .get();

  Future<List<PendingMutation>> getAllPendingMutations() =>
      select(pendingMutations).get();

  Stream<List<PendingMutation>> watchPendingMutations() =>
      (select(pendingMutations)
            ..orderBy([
              (mutation) => OrderingTerm(expression: mutation.createdAt),
            ]))
          .watch();

  Future<void> markMutationAttempt(
    String id, {
    required int attempts,
    required String error,
    bool blocked = false,
  }) =>
      (update(pendingMutations)..where((mutation) => mutation.id.equals(id)))
          .write(PendingMutationsCompanion(
        attempts: Value(attempts),
        lastError: Value(error),
        blocked: Value(blocked),
      ));

  Future<void> assignPendingMutationAccount(
    String id,
    int accountId, {
    bool unblock = false,
  }) =>
      (update(pendingMutations)..where((mutation) => mutation.id.equals(id)))
          .write(PendingMutationsCompanion(
        accountId: Value(accountId),
        blocked: unblock ? const Value(false) : const Value.absent(),
      ));

  Future<void> unblockPendingMutationsForAccount(int accountId) =>
      (update(pendingMutations)
            ..where((mutation) => mutation.accountId.equals(accountId))
            ..where((mutation) => mutation.blocked.equals(true)))
          .write(const PendingMutationsCompanion(
        blocked: Value(false),
      ));

  Future<void> deletePendingMutation(String id) =>
      (delete(pendingMutations)..where((mutation) => mutation.id.equals(id)))
          .go();

  Future<void> deleteLocalMealPlanEntry(int id) =>
      (delete(mealPlanEntries)..where((entry) => entry.id.equals(id))).go();

  Future<void> deleteLocalMealPlanTemplate(int id) =>
      (delete(mealPlanTemplates)..where((entry) => entry.id.equals(id))).go();

  Future<void> deleteLocalMealPlanTemplateEntry(int id) =>
      (delete(mealPlanTemplateEntries)..where((entry) => entry.id.equals(id)))
          .go();

  Future<void> deleteLocalShoppingList(int id) =>
      (delete(shoppingLists)..where((entry) => entry.id.equals(id))).go();

  Future<void> deleteLocalShoppingListItem(int id) =>
      (delete(shoppingListItems)..where((entry) => entry.id.equals(id))).go();

  Stream<List<AccountFollow>> watchFollowers(int accountId) =>
      (select(accountFollows)
            ..where((t) => t.followedAccountId.equals(accountId))
            ..where((t) => t.deletedAt.isNull()))
          .watch();

  Stream<List<AccountFollow>> watchFollowing(int accountId) =>
      (select(accountFollows)
            ..where((t) => t.followerAccountId.equals(accountId))
            ..where((t) => t.deletedAt.isNull()))
          .watch();

  Stream<List<Account>> watchFollowerAccounts(int accountId) {
    final query = select(accountFollows).join([
      innerJoin(
        accounts,
        accounts.id.equalsExp(accountFollows.followerAccountId),
      ),
    ])
      ..where(accountFollows.followedAccountId.equals(accountId))
      ..where(accountFollows.deletedAt.isNull())
      ..where(accounts.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: accounts.accountName)]);
    return query.watch().map(
          (rows) => rows.map((row) => row.readTable(accounts)).toList(),
        );
  }

  Stream<List<Account>> watchFollowingAccounts(int accountId) {
    final query = select(accountFollows).join([
      innerJoin(
        accounts,
        accounts.id.equalsExp(accountFollows.followedAccountId),
      ),
    ])
      ..where(accountFollows.followerAccountId.equals(accountId))
      ..where(accountFollows.deletedAt.isNull())
      ..where(accounts.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: accounts.accountName)]);
    return query.watch().map(
          (rows) => rows.map((row) => row.readTable(accounts)).toList(),
        );
  }

  Stream<List<AccountFollow>> watchFollow({
    required int followerAccountId,
    required int followedAccountId,
  }) =>
      (select(accountFollows)
            ..where((t) =>
                t.followerAccountId.equals(followerAccountId) &
                t.followedAccountId.equals(followedAccountId))
            ..where((t) => t.deletedAt.isNull()))
          .watch();

  // TABLE: Settings
  Future<int> createOrUpdateSetting(SettingsCompanion entry) =>
      _upsertIfNewer(settings, entry, (row) => row.updatedAt);

  /// Changes one setting of [accountId] and marks it for upload.
  Future<int> _updateSetting(int accountId, SettingsCompanion change) =>
      (update(settings)..where((row) => row.accountId.equals(accountId)))
          .write(change.copyWith(
        updatedAt: Value(DateTime.now().toUtc()),
        updatedBy: Value(currentAccount ?? accountId),
      ));

  Future<int> updateAccountLanguage(int accountId, String language) =>
      _updateSetting(accountId, SettingsCompanion(language: Value(language)));

  Future<int> updateAccountRealtime(int accountId, bool realtime) =>
      _updateSetting(accountId, SettingsCompanion(realtime: Value(realtime)));

  Future<int> updateAccountLightmode(int accountId, bool lightmode) =>
      _updateSetting(accountId, SettingsCompanion(lightmode: Value(lightmode)));

  SimpleSelectStatement<Settings, Setting> _settingsOf(int accountId) =>
      select(settings)..where((row) => row.accountId.equals(accountId));

  Stream<List<Setting>> getSettings(int accountId) =>
      _settingsOf(accountId).watch();

  Future<List<Setting>> getRealtime(int accountId) =>
      _settingsOf(accountId).get();

  Future<List<Setting>> notSyncedSettingsEntries(DateTime since) =>
      (select(settings)..where((row) => row.updatedAt.isBiggerThanValue(since)))
          .get();

  @override
  int get schemaVersion => 25;
}
