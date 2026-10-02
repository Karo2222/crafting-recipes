import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/comment_dialog.dart';
import 'package:craftingrecipes/widgets/comment_list.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final comments =
        Singleton().getDatabase().watchCommentsForRecipe(recipe.id);

    return FutureBuilder<bool>(
      future: RecipePermissions.canModifyContent(),
      builder: (context, permissionSnapshot) {
        final canModify = permissionSnapshot.data == true;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 26),
            Row(
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l.comments,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Divider()),
              ],
            ),
            if (canModify) ...[
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final button = FilledButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => CommentDialog(recipeId: recipe.id),
                    ),
                    icon: const Icon(Icons.add_comment_outlined),
                    label: Text(l.addComment),
                  );
                  if (constraints.maxWidth < 420) {
                    return SizedBox(width: double.infinity, child: button);
                  }
                  return Align(
                    alignment: Alignment.centerRight,
                    child: button,
                  );
                },
              ),
            ],
            const SizedBox(height: 12),
            CommentList(comments: comments, shrinkWrap: true),
          ],
        );
      },
    );
  }
}
