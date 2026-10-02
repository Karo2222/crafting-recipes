import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/create_recipe_view.dart';
import 'package:craftingrecipes/widgets/recipe_overview_widget.dart';

class RecipeView extends StatefulWidget {
  const RecipeView(
      {super.key,
      required this.recipe,
      required this.open,
      required this.additionalData});

  final Recipe recipe;
  final bool open;
  final String? additionalData;

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool _openingEditor = false;

  Future<void> _openEditor(Recipe recipe) async {
    if (_openingEditor) return;
    setState(() => _openingEditor = true);
    try {
      final graphReady =
          await SupabaseToDrift.ensureRecipeDetailsLoaded(recipe.id);
      if (!mounted) return;
      if (!graphReady) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.recipeDetailsNotReady),
          ),
        );
        return;
      }
      final updated = await Navigator.of(context).push<bool>(
        recipeEditorRoute(recipe: recipe),
      );
      if (!mounted || updated != true) return;
      setState(() {});
    } finally {
      if (mounted) setState(() => _openingEditor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final theme = Theme.of(context);
    return StreamBuilder<List<Recipe>>(
      stream: Singleton().getDatabase().getRecipeById(widget.recipe.id),
      builder: (context, snapshot) {
        final availableRecipes = (snapshot.data ?? const <Recipe>[])
            .where((recipe) => recipe.deletedAt == null)
            .toList();
        final activeRecipe =
            availableRecipes.isEmpty ? null : availableRecipes.first;
        return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              foregroundColor: theme.colorScheme.onSurface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: widget.open
                  ? IconButton(
                      tooltip:
                          MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      icon: const Icon(Icons.close),
                    )
                  : null,
              actions: [
                if (activeRecipe != null && currentAccount != null)
                  _RecipeLikeButton(
                    accountId: currentAccount!,
                    recipeId: activeRecipe.id,
                  ),
                if (activeRecipe != null)
                  StreamBuilder<bool>(
                    stream: RecipePermissions.watchCanEditRecipe(activeRecipe),
                    builder: (context, snapshot) {
                      if (snapshot.data != true) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        tooltip: l.editRecipe,
                        onPressed: _openingEditor
                            ? null
                            : () => _openEditor(activeRecipe),
                        icon: _openingEditor
                            ? const SizedBox.square(
                                dimension: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.edit_outlined),
                      );
                    },
                  ),
              ],
            ),
            body: RecipeOverviewWidget(
              recipe: activeRecipe ?? widget.recipe,
              additionalData: widget.additionalData,
              open: widget.open,
            ));
      },
    );
  }
}

class _RecipeLikeButton extends StatefulWidget {
  const _RecipeLikeButton({
    required this.accountId,
    required this.recipeId,
  });

  final int accountId;
  final int recipeId;

  @override
  State<_RecipeLikeButton> createState() => _RecipeLikeButtonState();
}

class _RecipeLikeButtonState extends State<_RecipeLikeButton> {
  bool _updating = false;

  Future<void> _setLiked(bool liked) async {
    setState(() => _updating = true);
    try {
      await DriftToSupabase.setRecipeLiked(
        accountId: widget.accountId,
        recipeId: widget.recipeId,
        liked: liked,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Languages.of(context)!.couldNotUpdateLike)),
        );
      }
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return StreamBuilder<List<RecipeLike>>(
      stream: Singleton().getDatabase().watchRecipeLike(
            accountId: widget.accountId,
            recipeId: widget.recipeId,
          ),
      builder: (context, snapshot) {
        final liked = snapshot.data?.isNotEmpty == true;
        return IconButton(
          tooltip: liked ? l.unlikeRecipe : l.likeRecipe,
          onPressed: _updating ? null : () => _setLiked(!liked),
          icon: _updating
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(liked ? Icons.favorite : Icons.favorite_border),
          color: liked ? Theme.of(context).colorScheme.error : null,
        );
      },
    );
  }
}
