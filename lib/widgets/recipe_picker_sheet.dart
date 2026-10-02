import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/category.dart';
import 'package:craftingrecipes/widgets/listitem.dart';
import 'package:craftingrecipes/widgets/searchbar.dart';
import 'package:flutter/material.dart';

Future<int?> showRecipePickerSheet({
  required BuildContext context,
  int? selectedRecipeId,
  String? title,
}) =>
    showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      showDragHandle: false,
      builder: (context) => RecipePickerSheet(
        selectedRecipeId: selectedRecipeId,
        title: title,
      ),
    );

class RecipePickerSheet extends StatefulWidget {
  const RecipePickerSheet({
    super.key,
    this.selectedRecipeId,
    this.title,
  });

  final int? selectedRecipeId;
  final String? title;

  @override
  State<RecipePickerSheet> createState() => _RecipePickerSheetState();
}

class _RecipePickerSheetState extends State<RecipePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  Set<int> _selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_refresh);
  }

  @override
  void dispose() {
    _searchController.removeListener(_refresh);
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final theme = Theme.of(context);
    final query = _searchController.text.trim();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(90),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 8, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? l.selectRecipe,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l.close,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(icon: const Icon(Icons.search), text: l.searchRecipes),
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
                  selectedCategoryIds: _selectedCategoryIds,
                  onChanged: (categoryIds) {
                    setState(() => _selectedCategoryIds = categoryIds);
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _RecipePickerResults(
                    searchQuery: query,
                    categoryIds: _selectedCategoryIds,
                    ownOnly: false,
                    likedOnly: false,
                    selectedRecipeId: widget.selectedRecipeId,
                  ),
                  _RecipePickerResults(
                    searchQuery: query,
                    categoryIds: _selectedCategoryIds,
                    ownOnly: true,
                    likedOnly: false,
                    selectedRecipeId: widget.selectedRecipeId,
                  ),
                  _RecipePickerResults(
                    searchQuery: query,
                    categoryIds: _selectedCategoryIds,
                    ownOnly: false,
                    likedOnly: true,
                    selectedRecipeId: widget.selectedRecipeId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipePickerResults extends StatelessWidget {
  const _RecipePickerResults({
    required this.searchQuery,
    required this.categoryIds,
    required this.ownOnly,
    required this.likedOnly,
    required this.selectedRecipeId,
  });

  final String searchQuery;
  final Set<int> categoryIds;
  final bool ownOnly;
  final bool likedOnly;
  final int? selectedRecipeId;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final recipesStream = Singleton().getDatabase().watchFilteredRecipes(
          categoryIds: categoryIds,
          searchWord: searchQuery,
          creatorAccountId: ownOnly ? currentAccount ?? -1 : null,
          likedByAccountId: likedOnly ? currentAccount ?? -1 : null,
        );

    return StreamBuilder<List<RecipeWithCount>>(
      stream: recipesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(l.somethingWentWrong));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final recipes = snapshot.data!.map((entry) => entry.recipe).toList();
        if (recipes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 42,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 10),
                  Text(likedOnly ? l.noLikedRecipes : l.noMatchingRecipes),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return ListItem(
              recipe: recipe,
              selected: recipe.id == selectedRecipeId,
              itemSelectedCallback: (selectedRecipe) {
                Navigator.of(context).pop(selectedRecipe.id);
              },
            );
          },
        );
      },
    );
  }
}
