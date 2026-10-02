import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/widgets/recipe_image.dart';
import 'package:intl/intl.dart';

/// Recipe card used in the recipe list; highlights the selected recipe.
class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.recipe,
    required this.itemSelectedCallback,
    this.selected = false,
  });

  final Recipe recipe;
  final void Function(Recipe recipe) itemSelectedCallback;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMd(l.languageCode);
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: selected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => itemSelectedCallback(recipe),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 164,
            child: Row(
              children: [
                SizedBox(
                  width: 112,
                  height: 164,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: RecipeImage(
                      recipeId: recipe.id,
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        key: const Key("listitem_title"),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 30,
                        child: _RecipeCategoryLine(recipeId: recipe.id),
                      ),
                      const Spacer(),
                      _RecipeCreatorLine(accountId: recipe.createdBy),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 15),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              '${l.createdAt}: ${dateFormat.format(recipe.createdAt.toLocal())}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 15),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${l.totalTime}: ${recipe.totalTimeMinutes == null ? l.notSpecified : l.formatDuration(recipe.totalTimeMinutes!)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  selected ? Icons.check_circle : Icons.chevron_right,
                  color:
                      selected ? Theme.of(context).colorScheme.primary : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeCategoryLine extends StatelessWidget {
  const _RecipeCategoryLine({required this.recipeId});

  final int recipeId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Category>>(
      stream: Singleton().getDatabase().watchCategoriesOfRecipe(recipeId),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index].name,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RecipeCreatorLine extends StatelessWidget {
  const _RecipeCreatorLine({required this.accountId});

  final int accountId;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return StreamBuilder<List<Account>>(
      stream: Singleton().getDatabase().watchAccountById(accountId),
      builder: (context, snapshot) {
        final accountName = snapshot.data?.firstOrNull?.accountName;
        return Row(
          children: [
            const Icon(Icons.person_outline, size: 15),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                '${l.createdBy}: ${accountName ?? l.notSpecified}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
