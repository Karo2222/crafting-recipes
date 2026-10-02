import 'dart:async';
import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/device_info.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/scanner.dart';
import 'package:craftingrecipes/views/category.dart';
import 'package:craftingrecipes/views/create_recipe_view.dart';
import 'package:craftingrecipes/views/recipe_view.dart';
import 'package:craftingrecipes/widgets/recipe_overview_widget.dart';
import 'package:craftingrecipes/widgets/listitem.dart';
import 'package:craftingrecipes/widgets/searchbar.dart';
import 'package:craftingrecipes/objects/singleton.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.scanNotifier,
    required this.canCreateRecipe,
  });

  final ScanModel scanNotifier;
  final bool canCreateRecipe;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with AutomaticKeepAliveClientMixin<Home>, TickerProviderStateMixin<Home> {
  final TextEditingController _searchController = TextEditingController();
  late final TabController _tabController;
  Set<int> selectedCategoryIds = {};
  StreamSubscription<List<Setting>>? _settingsSubscription;

  /// Completed by [setRecipe] once the list shows the result of a scan.
  Completer<Recipe?> _scanResult = Completer<Recipe?>();
  final ValueNotifier<Recipe?> _recipe = ValueNotifier(null);

  /// Applies the account's saved language and theme whenever they change.
  void _listenToAccountSettings() {
    final accountId = currentAccount;
    if (accountId == null) return;
    _settingsSubscription = Singleton()
        .getDatabase()
        .getSettings(accountId)
        .listen((settings) {
      if (settings.isEmpty || !mounted) return;
      final setting = settings.first;
      RecipesApp.setLocale(context, Locale(setting.language));
      RecipesApp.setTheme(
        context,
        setting.lightmode ? ThemeMode.light : ThemeMode.dark,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_refresh);
    _listenToAccountSettings();
    widget.scanNotifier.addListener(_onScan);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _settingsSubscription?.cancel();
    _searchController.removeListener(_refresh);
    _searchController.dispose();
    _tabController.dispose();
    widget.scanNotifier.removeListener(_onScan);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _openRecipe(Recipe recipe) {
    Navigator.of(context).push(
      appPageRoute(
        builder: (_) =>
            RecipeView(recipe: recipe, open: false, additionalData: null),
        fullScreenSwipeBack: true,
      ),
    );
  }

  /// A scanned code is used as search term. On phones the matching recipe is
  /// opened directly once the list reports exactly one result.
  Future<void> _onScan() async {
    _scanResult = Completer<Recipe?>();
    _tabController.animateTo(0);
    _searchController.text = widget.scanNotifier.text;
    if (DeviceInfo.inTabletLayout(context)) return;

    final match = await _scanResult.future;
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (match != null) _openRecipe(match);
  }

  void mobileCallback(Recipe recipe) {
    _recipe.value = recipe;
    _openRecipe(recipe);
  }

  void tabletCallback(Recipe recipe) => _recipe.value = recipe;

  void setRecipe(Recipe? recipe) {
    _recipe.value = recipe;
    if (!_scanResult.isCompleted) _scanResult.complete(recipe);
  }

  Future<void> _openCreateRecipe() async {
    final created = await Navigator.of(context).push<bool>(recipeEditorRoute());
    if (!mounted || created != true) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tabletLayout = DeviceInfo.inTabletLayout(context);
    final l = Languages.of(context)!;
    super.build(context);
    return Scaffold(
        floatingActionButton: widget.canCreateRecipe
            ? FloatingActionButton.extended(
                onPressed: _openCreateRecipe,
                icon: const Icon(Icons.add),
                label: Text(l.newRecipe),
              )
            : null,
        body: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.search),
                        text: l.searchRecipes,
                      ),
                      Tab(
                        icon: const Icon(Icons.person_outline),
                        text: l.ownRecipes,
                      ),
                      Tab(
                        icon: const Icon(Icons.favorite_outline),
                        text: l.likedRecipes,
                      ),
                    ],
                  ),
                  RecipeSearchField(controller: _searchController),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CategoryFilterButton(
                        selectedCategoryIds: selectedCategoryIds,
                        onChanged: (categoryIds) {
                          setState(() {
                            selectedCategoryIds = categoryIds;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildRecipeTab(
                          tabletLayout: tabletLayout,
                          canCreateRecipe: widget.canCreateRecipe,
                          selectSingleResult: true,
                        ),
                        _buildRecipeTab(
                          tabletLayout: tabletLayout,
                          canCreateRecipe: widget.canCreateRecipe,
                          ownOnly: true,
                        ),
                        _buildRecipeTab(
                          tabletLayout: tabletLayout,
                          canCreateRecipe: false,
                          likedOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: tabletLayout,
                child: ValueListenableBuilder(
                    valueListenable: _recipe,
                    builder: (_, recipe, __) {
                      return recipe != null
                          ? Expanded(
                              flex: tabletLayout ? 1 : 0,
                              child: RecipeOverviewWidget(
                                recipe: recipe,
                                additionalData: null,
                                open: false,
                              ),
                            )
                          : Expanded(
                              flex: tabletLayout ? 1 : 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(l.noRecipeSelected),
                                ],
                              ));
                    }))
          ],
        ));
  }

  Widget _buildRecipeTab({
    required bool tabletLayout,
    required bool canCreateRecipe,
    bool ownOnly = false,
    bool likedOnly = false,
    bool selectSingleResult = false,
  }) {
    return Column(
      children: [
        Listing(
          setRecipe: setRecipe,
          callback: tabletLayout ? tabletCallback : mobileCallback,
          categoryIds: selectedCategoryIds,
          searchWord: _searchController.text.trim(),
          ownOnly: ownOnly,
          likedOnly: likedOnly,
          selectSingleResult: selectSingleResult,
          onCreateRecipe: canCreateRecipe ? _openCreateRecipe : null,
        ),
      ],
    );
  }
}

/// Live list of recipes matching the selected categories and search term.
class Listing extends StatefulWidget {
  const Listing({
    super.key,
    required this.callback,
    required this.categoryIds,
    required this.searchWord,
    required this.setRecipe,
    this.onCreateRecipe,
    this.ownOnly = false,
    this.likedOnly = false,
    this.selectSingleResult = false,
  });

  /// Called with the tapped recipe.
  final void Function(Recipe recipe) callback;

  /// Receives the only result (or null) when [selectSingleResult] is set.
  final void Function(Recipe? recipe) setRecipe;
  final Set<int> categoryIds;
  final String searchWord;
  final VoidCallback? onCreateRecipe;
  final bool ownOnly;
  final bool likedOnly;
  final bool selectSingleResult;

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final filteredRecipes = Singleton().getDatabase().watchFilteredRecipes(
          categoryIds: widget.categoryIds,
          searchWord: widget.searchWord,
          creatorAccountId: widget.ownOnly ? currentAccount ?? -1 : null,
          likedByAccountId: widget.likedOnly ? currentAccount ?? -1 : null,
        );
    return StreamBuilder<List<RecipeWithCount>>(
        stream: filteredRecipes,
        builder: (BuildContext context,
            AsyncSnapshot<List<RecipeWithCount>> snapshot) {
          if (snapshot.hasError) {
            return Expanded(
              child: Center(child: Text('🚨 Error: ${snapshot.error}')),
            );
          }
          if (!snapshot.hasData) {
            return const Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final recipes = snapshot.data!;
          if (widget.selectSingleResult) {
            final single = recipes.length == 1 ? recipes.first.recipe : null;
            WidgetsBinding.instance
                .addPostFrameCallback((_) => widget.setRecipe(single));
          }
          if (recipes.isEmpty) {
            final isFiltered =
                widget.categoryIds.isNotEmpty || widget.searchWord.isNotEmpty;
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFiltered
                            ? Icons.search_off
                            : Icons.menu_book_outlined,
                        size: 44,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isFiltered
                            ? l.noMatchingRecipes
                            : widget.likedOnly
                                ? l.noLikedRecipes
                                : l.noRecipesYet,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (!isFiltered && widget.onCreateRecipe != null) ...[
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: widget.onCreateRecipe,
                          icon: const Icon(Icons.add),
                          label: Text(l.createFirstRecipe),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }
          return Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                key: const Key('listview'),
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index].recipe;
                  return ListItem(
                    key: Key('${recipe.id}'),
                    recipe: recipe,
                    itemSelectedCallback: widget.callback,
                  );
                },
              ),
            ),
          );
        });
  }
}
