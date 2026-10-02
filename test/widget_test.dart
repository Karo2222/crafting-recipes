import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/offline_mutation_queue.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/helpers/recipe_comparison.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/app_localizations.dart';
import 'package:craftingrecipes/languages/de.dart';
import 'package:craftingrecipes/languages/en.dart';
import 'package:craftingrecipes/views/second_homepage.dart';
import 'package:craftingrecipes/views/recipe_comparison_view.dart';
import 'package:craftingrecipes/views/syncing_status.dart';
import 'package:craftingrecipes/widgets/comment_card.dart';
import 'package:craftingrecipes/widgets/linkified_text.dart';
import 'package:craftingrecipes/widgets/shared_access_dialog.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('viewer profiles are read-only', () {
    expect(RecipePermissions.accountRoleCanModify('viewer'), isFalse);
    expect(RecipePermissions.accountRoleCanModify('editor'), isTrue);
    expect(RecipePermissions.accountRoleCanModify('admin'), isTrue);
    expect(RecipePermissions.profileRoleCanModify('viewer'), isFalse);
    expect(RecipePermissions.profileRoleCanModify('editor'), isTrue);
    expect(RecipePermissions.profileRoleCanModify('admin'), isTrue);
    expect(RecipePermissions.profileRoleCanModify('unsupported'), isFalse);
  });

  test('recipe creation requires editable account and profile roles', () {
    expect(
      RecipePermissions.rolesCanCreateRecipe(
        accountRoleName: 'editor',
        profileRoleName: 'editor',
      ),
      isTrue,
    );
    expect(
      RecipePermissions.rolesCanCreateRecipe(
        accountRoleName: 'admin',
        profileRoleName: 'editor',
      ),
      isTrue,
    );
    expect(
      RecipePermissions.rolesCanCreateRecipe(
        accountRoleName: 'editor',
        profileRoleName: 'viewer',
      ),
      isFalse,
    );
    expect(
      RecipePermissions.rolesCanCreateRecipe(
        accountRoleName: 'viewer',
        profileRoleName: 'editor',
      ),
      isFalse,
    );
  });

  test('content permissions update when a profile role changes', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.utc(2026, 7, 30);
    await database.insertMultipleRoles([
      Role(
        id: 1,
        name: 'viewer',
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
      Role(
        id: 2,
        name: 'editor',
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
    ]);
    await database.insertMultipleAccounts([
      Account(
        id: 1,
        accountName: 'Editor',
        roleId: 2,
        hostCode: 'host',
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
    ]);
    final profile = Profile(
      id: 1,
      accountId: 1,
      name: 'main',
      roleId: 2,
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    );
    await database.insertMultipleProfiles([profile]);
    final values = database.watchContentRoleNames(1, 1).take(2).toList();
    await Future<void>.delayed(Duration.zero);

    await database.insertMultipleProfiles([
      profile.copyWith(
        roleId: 1,
        updatedAt: now.add(const Duration(minutes: 1)),
      ),
    ]);

    final roles = await values;
    expect(roles.first.accountRole, 'editor');
    expect(roles.first.profileRole, 'editor');
    expect(roles.last.profileRole, 'viewer');
  });

  test('offline records receive distinct negative local ids', () {
    final first = OfflineMutationQueue.createLocalId();
    final second = OfflineMutationQueue.createLocalId();

    expect(first, isNegative);
    expect(second, isNegative);
    expect(
      first,
      greaterThanOrEqualTo(-OfflineMutationQueue.maxWebSafeInteger),
    );
    expect(
      second,
      greaterThanOrEqualTo(-OfflineMutationQueue.maxWebSafeInteger),
    );
    expect(second, isNot(first));
  });

  test('pending offline mutations are isolated by account', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.utc(2026, 7, 19);

    await database.enqueueMutation(PendingMutationsCompanion.insert(
      id: 'owner-list',
      accountId: const Value(1),
      mutationType: 'shopping_list_upsert',
      payload: '{}',
      createdAt: now,
    ));
    await database.enqueueMutation(PendingMutationsCompanion.insert(
      id: 'collaborator-item',
      accountId: const Value(13),
      mutationType: 'shopping_list_item_upsert',
      payload: '{}',
      createdAt: now.add(const Duration(seconds: 1)),
    ));
    await database.enqueueMutation(PendingMutationsCompanion.insert(
      id: 'collaborator-meal',
      accountId: const Value(13),
      mutationType: 'meal_plan_entry_upsert',
      payload: '{}',
      createdAt: now.add(const Duration(seconds: 2)),
    ));

    expect(
      (await database.getPendingMutationsForAccount(1))
          .map((mutation) => mutation.id),
      ['owner-list'],
    );
    expect(
      (await database.getPendingMutationsForAccount(13))
          .map((mutation) => mutation.id),
      ['collaborator-item', 'collaborator-meal'],
    );

    await database.markMutationAttempt(
      'owner-list',
      attempts: 1,
      error: 'blocked',
      blocked: true,
    );
    await database.markMutationAttempt(
      'collaborator-item',
      attempts: 1,
      error: 'blocked',
      blocked: true,
    );
    await database.unblockPendingMutationsForAccount(13);

    expect(await database.getPendingMutationsForAccount(1), isEmpty);
    expect(
      (await database.getPendingMutationsForAccount(13))
          .map((mutation) => mutation.id),
      ['collaborator-item', 'collaborator-meal'],
    );
  });

  test('shopping items can move between store sections locally', () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final now = DateTime.utc(2026, 7, 23);
    await database.upsertShoppingList(ShoppingList(
      id: -1,
      accountId: 1,
      name: 'Weekly',
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    ));
    await database.upsertShoppingListSection(ShoppingListSection(
      id: -2,
      shoppingListId: -1,
      name: 'Pharmacy',
      sortOrder: 0,
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    ));
    final item = ShoppingListItem(
      id: -3,
      shoppingListId: -1,
      name: 'Soap',
      shoppingCategoryCode: 'other',
      checked: false,
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    );
    await database.upsertShoppingListItem(item);

    expect((await database.watchShoppingListItems(-1).first).single.sectionId,
        isNull);
    await database.upsertShoppingListItem(
      item.copyWith(sectionId: const Value(-2)),
    );

    expect(
      (await database.getShoppingListItemsInSection(-2)).single.name,
      'Soap',
    );
  });

  test('shopping lists are shareable only while both accounts have access',
      () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final now = DateTime.utc(2026, 7, 23);
    await database.upsertShoppingList(ShoppingList(
      id: 10,
      accountId: 1,
      name: 'Shared groceries',
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    ));
    final membership = ShoppingListMember(
      shoppingListId: 10,
      accountId: 13,
      permission: 'editor',
      status: 'accepted',
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    );
    await database.upsertShoppingListMember(membership);

    expect(
      (await database.getShoppingListsShareableWithAccount(1, 13))
          .map((list) => list.id),
      [10],
    );
    expect(
      (await database.watchAccessibleShoppingListById(13, 10).first)
          .map((list) => list.id),
      [10],
    );

    await database.upsertShoppingListMember(
      membership.copyWith(
        deletedAt: Value(now.add(const Duration(minutes: 1))),
        deletedBy: const Value(1),
      ),
    );

    expect(
      await database.getShoppingListsShareableWithAccount(1, 13),
      isEmpty,
    );
    expect(
      await database.watchAccessibleShoppingListById(13, 10).first,
      isEmpty,
    );
  });

  test('shared shopping-list edit access updates with membership', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.utc(2026, 7, 30);
    await database.upsertShoppingList(ShoppingList(
      id: 10,
      accountId: 1,
      name: 'Shared groceries',
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    ));
    final membership = ShoppingListMember(
      shoppingListId: 10,
      accountId: 13,
      permission: 'viewer',
      status: 'accepted',
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    );
    await database.upsertShoppingListMember(membership);
    final values = database.watchCanEditShoppingList(13, 10).take(2).toList();
    await Future<void>.delayed(Duration.zero);

    await database.upsertShoppingListMember(
      membership.copyWith(
        permission: 'editor',
        updatedAt: now.add(const Duration(minutes: 1)),
      ),
    );

    expect(await values, [false, true]);
  });

  test('meal-plan serving labels are localized', () {
    expect(LanguageEn().plannedServings, 'Planned servings (optional)');
    expect(LanguageDe().plannedServings, 'Geplante Portionen (optional)');
    expect(
      LanguageEn().confirmRemoveAccess('Sam', 'Home'),
      contains('Sam'),
    );
    expect(
      LanguageDe().confirmRemoveAccess('Sam', 'Zuhause'),
      contains('Zuhause'),
    );
  });

  test('recipe durations are formatted for the selected language', () {
    expect(LanguageEn().formatDuration(90), '1 hr 30 min');
    expect(LanguageDe().formatDuration(90), '1 Std. 30 Min.');
  });

  test('measurement unit codes are localized for display', () {
    expect(LanguageEn().unitLabel('tbsp'), 'tbsp');
    expect(LanguageDe().unitLabel('tbsp'), 'EL');
    expect(LanguageDe().unitLabel('piece'), 'Stück');
    expect(LanguageEn().unitLabel('fl_oz'), 'fl oz');
  });

  testWidgets('comment card shows its author and message', (tester) async {
    final now = DateTime.utc(2026, 7, 16, 12);
    final comment = CommentWithAccount(
      accountName: 'Garo',
      comment: Comment(
        id: 1,
        recipeId: 2,
        accountId: 1,
        message: 'This recipe worked well.',
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [AppLocalizationsDelegate()],
        supportedLocales: const [Locale('en'), Locale('de')],
        home: Scaffold(
          body: CommentCard(data: comment),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Garo'), findsOneWidget);
    expect(find.text('This recipe worked well.'), findsOneWidget);
    expect(find.byTooltip('Comment actions'), findsNothing);
  });

  testWidgets('shared invitation panel exposes accept and decline actions',
      (tester) async {
    var accepted = false;
    var declined = false;
    const invitation = SharedResourceInvitation(
      resourceId: 7,
      resourceName: 'Family week',
      ownerAccountName: 'Garo',
      permission: 'editor',
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [AppLocalizationsDelegate()],
        supportedLocales: const [Locale('en'), Locale('de')],
        home: Scaffold(
          body: SharedInvitationsPanel(
            title: 'Meal plans',
            invitations: const [invitation],
            onAccept: (_) => accepted = true,
            onDecline: (_) => declined = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Family week'), findsOneWidget);
    expect(find.textContaining('Garo'), findsOneWidget);
    await tester.tap(find.text('Accept'));
    expect(accepted, isTrue);
    await tester.tap(find.text('Decline'));
    expect(declined, isTrue);
  });

  testWidgets('full-screen swipe back is limited to opted-in iOS pages',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    appPageRoute(
                      builder: (context) => const Scaffold(
                        body: Center(child: Text('Protected page')),
                      ),
                    ),
                  ),
                  child: const Text('Open protected page'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    appPageRoute(
                      fullScreenSwipeBack: true,
                      builder: (context) => const Scaffold(
                        body: Center(child: Text('Swipeable page')),
                      ),
                    ),
                  ),
                  child: const Text('Open swipeable page'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open protected page'));
    await tester.pumpAndSettle();
    await tester.dragFrom(const Offset(400, 300), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Protected page'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open swipeable page'));
    await tester.pumpAndSettle();
    await tester.dragFrom(const Offset(400, 300), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Swipeable page'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android system back pops the active nested navigator',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(
      MaterialApp(
        home: NavigatorPage(
          isActive: true,
          child: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const Scaffold(
                      body: Text('Nested details'),
                    ),
                  ),
                ),
                child: const Text('Open nested details'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open nested details'));
    await tester.pumpAndSettle();
    expect(find.text('Nested details'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Nested details'), findsNothing);
    expect(find.text('Open nested details'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android back keeps every tab navigator usable', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(
      const MaterialApp(home: _TabbedNavigatorHarness()),
    );

    await tester.tap(find.text('Open recipe'));
    await tester.pumpAndSettle();
    expect(find.text('Recipe details'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Recipes root'), findsOneWidget);

    await tester.tap(find.text('Meal plan'));
    await tester.pumpAndSettle();
    expect(find.text('Meal plan root'), findsOneWidget);

    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.text('Chat root'), findsOneWidget);

    await tester.tap(find.text('Recipes'));
    await tester.pumpAndSettle();
    expect(find.text('Recipes root'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android back returns secondary tabs to Recipes first',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(
      const MaterialApp(home: _TabbedNavigatorHarness()),
    );
    await tester.tap(find.text('Meal plan'));
    await tester.pumpAndSettle();
    expect(find.text('Meal plan root'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Recipes root'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android back closes secondary-tab details before Recipes',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(
      const MaterialApp(home: _TabbedNavigatorHarness()),
    );
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open chat'));
    await tester.pumpAndSettle();
    expect(find.text('Conversation'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Conversation'), findsNothing);
    expect(find.text('Chat root'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Recipes root'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('recipe comparison shows differences and returns the decision',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    RecipeComparisonAction? result;
    const draft = RecipeVersionSnapshot(
      revision: 1,
      title: 'Pasta with herbs',
      description: 'My edited description',
      totalTimeMinutes: 30,
      servings: 4,
      imageUrl: null,
      imageComparisonKey: '',
      categoryNames: ['Dinner'],
      ingredients: [
        RecipeVersionIngredient(
          id: null,
          name: 'Pasta',
          amount: 250,
          unit: 'g',
          quantityNote: null,
        ),
      ],
      steps: [
        RecipeVersionStep(
          stepNr: 1,
          description: 'Cook the pasta.',
          ingredientNames: ['Pasta'],
        ),
      ],
    );
    const latest = RecipeVersionSnapshot(
      revision: 2,
      title: 'Pasta',
      description: 'Database description',
      totalTimeMinutes: 25,
      servings: 2,
      imageUrl: null,
      imageComparisonKey: '',
      categoryNames: ['Dinner'],
      ingredients: [
        RecipeVersionIngredient(
          id: 1,
          name: 'Pasta',
          amount: 200,
          unit: 'g',
          quantityNote: null,
        ),
      ],
      steps: [
        RecipeVersionStep(
          stepNr: 1,
          description: 'Cook until tender.',
          ingredientNames: ['Pasta'],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [AppLocalizationsDelegate()],
        supportedLocales: const [Locale('en'), Locale('de')],
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result =
                    await Navigator.of(context).push<RecipeComparisonAction>(
                  MaterialPageRoute(
                    builder: (_) => const RecipeComparisonView(
                      draft: draft,
                      latest: latest,
                    ),
                  ),
                );
              },
              child: const Text('Open comparison'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Open comparison'));
    await tester.pumpAndSettle();

    expect(find.text('Compare recipe changes'), findsOneWidget);
    expect(find.text('Pasta with herbs'), findsOneWidget);
    expect(find.text('Pasta'), findsWidgets);
    expect(find.text('Changed'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Save as copy'));
    await tester.pumpAndSettle();
    expect(result, RecipeComparisonAction.saveAsCopy);
  });

  testWidgets('sync progress remains scrollable in landscape', (tester) async {
    await tester.binding.setSurfaceSize(const Size(852, 393));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      Singleton().resetPercentageOfSyncedEntries();
      Singleton().resetNumberOfSyncedTables();
      Singleton().setNumberOfSyncSteps(numberOfSyncSteps: 0);
      Singleton().setLastSyncError(null);
      Singleton().setSyncStatus(newStatus: SyncStatus.neverSynced);
    });

    Singleton().resetPercentageOfSyncedEntries();
    Singleton().setNumberOfSyncSteps(numberOfSyncSteps: 24);
    Singleton().setNumberOfSyncedTables(numberOfSyncedTables: 20);
    Singleton().setSyncStatus(newStatus: SyncStatus.pendingSync);
    for (var index = 0; index < 24; index++) {
      Singleton().addAndUpdate(
        ProgressFraction(index + 1, index + 1, 'Table ${index + 1}'),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [AppLocalizationsDelegate()],
        supportedLocales: const [Locale('en'), Locale('de')],
        home: const SyncingStatus(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Start sync'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('recipe graph updates preserve retained step ids', () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final createdAt = DateTime.utc(2026, 7, 20);
    final updatedAt = DateTime.utc(2026, 7, 21);

    Recipe recipe(DateTime timestamp) => Recipe(
          id: 1,
          title: 'Stable steps',
          revision: 1,
          createdAt: createdAt,
          createdBy: 1,
          updatedAt: timestamp,
          updatedBy: 1,
        );
    RecipeStep step(int id, int number, DateTime timestamp) => RecipeStep(
          id: id,
          recipeId: 1,
          stepNr: number,
          description: 'Step $number',
          createdAt: timestamp,
          createdBy: 1,
          updatedAt: timestamp,
          updatedBy: 1,
        );

    await database.saveRecipeGraph(
      recipe: recipe(createdAt),
      ingredientRows: const [],
      ingredientLinks: const [],
      stepRows: [step(100, 1, createdAt), step(101, 2, createdAt)],
      stepIngredientLinks: const [],
      categoryLinks: const [],
    );
    await database.saveRecipeGraph(
      recipe: recipe(updatedAt),
      ingredientRows: const [],
      ingredientLinks: const [],
      stepRows: [step(100, 1, updatedAt), step(102, 2, updatedAt)],
      stepIngredientLinks: const [],
      categoryLinks: const [],
    );

    final steps = await database.getRecipeStepsByRecipeId(1).first;
    expect(steps.map((step) => step.id), [100, 102]);
    expect(steps.first.createdAt.isAtSameMomentAs(createdAt), isTrue);
    expect(await database.getRecipeStepById(101), isEmpty);
  });

  test('recipe ingredients allow a quantity note without amount or unit',
      () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final now = DateTime.utc(2026, 7, 21);

    await database.saveRecipeGraph(
      recipe: Recipe(
        id: 1,
        title: 'Seasoned soup',
        revision: 1,
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
      ingredientRows: [
        Ingredient(
          id: 10,
          name: 'Salt',
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
      ],
      ingredientLinks: [
        RecipeIngredient(
          recipeId: 1,
          ingredientId: 10,
          quantityNote: 'to taste',
          sortOrder: 0,
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
      ],
      stepRows: const [],
      stepIngredientLinks: const [],
      categoryLinks: const [],
    );

    final ingredients = await database.getIngredientsByRecipeId(1).first;
    expect(ingredients, hasLength(1));
    expect(ingredients.single.amount, isNull);
    expect(ingredients.single.unit, isNull);
    expect(ingredients.single.quantityNote, 'to taste');
  });

  test('recipe ingredients preserve section names and entered order', () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final now = DateTime.utc(2026, 7, 30);

    await database.saveRecipeGraph(
      recipe: Recipe(
        id: 1,
        title: 'Pasta',
        revision: 1,
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
      ingredientRows: [
        Ingredient(
          id: 10,
          name: 'Zucchini',
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
        Ingredient(
          id: 11,
          name: 'Flour',
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
      ],
      ingredientLinks: [
        RecipeIngredient(
          recipeId: 1,
          ingredientId: 10,
          sectionName: 'Sauce',
          sortOrder: 1,
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
        RecipeIngredient(
          recipeId: 1,
          ingredientId: 11,
          sectionName: 'Noodles',
          sortOrder: 0,
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
      ],
      stepRows: const [],
      stepIngredientLinks: const [],
      categoryLinks: const [],
    );

    final ingredients = await database.getIngredientsByRecipeId(1).first;
    expect(ingredients.map((ingredient) => ingredient.name), [
      'Flour',
      'Zucchini',
    ]);
    expect(ingredients.map((ingredient) => ingredient.sectionName), [
      'Noodles',
      'Sauce',
    ]);
    expect(ingredients.map((ingredient) => ingredient.sortOrder), [0, 1]);
  });

  test('recipe notes persist in the local database', () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final now = DateTime.utc(2026, 7, 21);

    await database.insertMultipleRecipes([
      Recipe(
        id: 1,
        title: 'Linked recipe',
        notes: 'Source: https://example.com/recipe',
        revision: 1,
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
    ]);

    final recipe = (await database.getRecipeById(1).first).single;
    expect(recipe.notes, 'Source: https://example.com/recipe');
  });

  test('selectable recipes update when a recipe is added locally', () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final emissions = database.watchSelectableRecipes().take(2).toList();
    await Future<void>.delayed(Duration.zero);
    final now = DateTime.utc(2026, 7, 30);

    await database.insertMultipleRecipes([
      Recipe(
        id: -1,
        title: 'New local recipe',
        revision: 1,
        createdAt: now,
        createdBy: 1,
        updatedAt: now,
        updatedBy: 1,
      ),
    ]);

    final values = await emissions;
    expect(values.first, isEmpty);
    expect(values.last.single.title, 'New local recipe');
  });

  test('recipe editing waits for ingredients and steps', () async {
    final warnAboutMultipleDatabases =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          warnAboutMultipleDatabases;
    });
    final now = DateTime.utc(2026, 7, 30);
    final recipe = Recipe(
      id: 7,
      title: 'Complete recipe',
      revision: 1,
      createdAt: now,
      createdBy: 1,
      updatedAt: now,
      updatedBy: 1,
    );
    await database.insertMultipleRecipes([recipe]);
    expect(await database.hasCompleteRecipeGraph(recipe.id), isFalse);

    await database.saveRecipeGraph(
      recipe: recipe,
      ingredientRows: [
        Ingredient(
          id: 8,
          name: 'Ingredient',
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
      ],
      ingredientLinks: [
        RecipeIngredient(
          recipeId: recipe.id,
          ingredientId: 8,
          sortOrder: 0,
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
      ],
      stepRows: [
        RecipeStep(
          id: 9,
          recipeId: recipe.id,
          stepNr: 1,
          description: 'Prepare it.',
          createdAt: now,
          createdBy: 1,
          updatedAt: now,
          updatedBy: 1,
        ),
      ],
      stepIngredientLinks: const [],
      categoryLinks: const [],
    );

    expect(await database.hasCompleteRecipeGraph(recipe.id), isTrue);
  });

  test('recipe notes recognize web links', () {
    expect(
      detectWebLinks('Source https://example.com and www.example.org.'),
      [
        'https://example.com',
        'www.example.org',
      ],
    );
  });
}

class _TabbedNavigatorHarness extends StatefulWidget {
  const _TabbedNavigatorHarness();

  @override
  State<_TabbedNavigatorHarness> createState() =>
      _TabbedNavigatorHarnessState();
}

class _TabbedNavigatorHarnessState extends State<_TabbedNavigatorHarness> {
  final GlobalKey<NavigatorPageState> _recipesKey =
      GlobalKey<NavigatorPageState>();
  final GlobalKey<NavigatorPageState> _mealPlanKey =
      GlobalKey<NavigatorPageState>();
  final GlobalKey<NavigatorPageState> _chatKey =
      GlobalKey<NavigatorPageState>();
  int _index = 0;

  NavigatorPageState? get _activeNavigator => switch (_index) {
        0 => _recipesKey.currentState,
        1 => _mealPlanKey.currentState,
        2 => _chatKey.currentState,
        _ => null,
      };

  void _navigationChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RootTabBackScope(
      isOnRootTab: _index == 0,
      currentTabCanPop: _activeNavigator?.canPop == true,
      onPopCurrentTab: () => _activeNavigator?.popCurrentRoute(),
      onReturnToRootTab: () => setState(() => _index = 0),
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            NavigatorPage(
              key: _recipesKey,
              isActive: _index == 0,
              handlesSystemBack: false,
              onNavigationChanged: _navigationChanged,
              child: Builder(
                builder: (context) => Scaffold(
                  body: Column(
                    children: [
                      const Text('Recipes root'),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const Scaffold(
                              body: Text('Recipe details'),
                            ),
                          ),
                        ),
                        child: const Text('Open recipe'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            NavigatorPage(
              key: _mealPlanKey,
              isActive: _index == 1,
              handlesSystemBack: false,
              onNavigationChanged: _navigationChanged,
              child: const Scaffold(body: Text('Meal plan root')),
            ),
            NavigatorPage(
              key: _chatKey,
              isActive: _index == 2,
              handlesSystemBack: false,
              onNavigationChanged: _navigationChanged,
              child: Builder(
                builder: (context) => Scaffold(
                  body: Column(
                    children: [
                      const Text('Chat root'),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                const Scaffold(body: Text('Conversation')),
                          ),
                        ),
                        child: const Text('Open chat'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() => _index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu),
              label: 'Recipes',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month),
              label: 'Meal plan',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
