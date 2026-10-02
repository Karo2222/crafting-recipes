import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/fullscreen_image_viewer.dart';
import 'package:craftingrecipes/views/account_view.dart';
import 'package:craftingrecipes/views/recipe_step_overview.dart';
import 'package:craftingrecipes/widgets/comment_section.dart';
import 'package:craftingrecipes/widgets/recipe_image.dart';
import 'package:craftingrecipes/widgets/linkified_text.dart';
import 'package:craftingrecipes/widgets/shopping_category_picker.dart';
import 'package:intl/intl.dart' as intl;

class RecipeOverviewWidget extends StatefulWidget {
  const RecipeOverviewWidget(
      {super.key,
      required this.recipe,
      required this.open,
      required this.additionalData});

  final Recipe recipe;
  final bool open;
  final String? additionalData;

  @override
  State<RecipeOverviewWidget> createState() => _RecipeOverviewWidgetState();
}

class _RecipeOverviewWidgetState extends State<RecipeOverviewWidget> {
  final ScrollController _scrollController = ScrollController();
  late String tagName;
  late Stream<List<Recipe>> _recipeStream;
  late Stream<List<IngredientsOfRecipeResult>> _ingredientsStream;
  late Stream<List<RecipeStep>> _stepsStream;
  int? _baseServings;
  int? _selectedServings;
  bool _openingSteps = false;

  @override
  void initState() {
    super.initState();
    _bindRecipe(widget.recipe);
  }

  @override
  void didUpdateWidget(covariant RecipeOverviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recipe.id != widget.recipe.id) {
      _bindRecipe(widget.recipe);
    }
  }

  void _bindRecipe(Recipe recipe) {
    tagName = "recipeTag${recipe.id}";
    final database = Singleton().getDatabase();
    _recipeStream = database.getRecipeById(recipe.id);
    _ingredientsStream = database.getIngredientsByRecipeId(recipe.id);
    _stepsStream = database.getRecipeStepsByRecipeId(recipe.id);
    _baseServings = recipe.servings;
    _selectedServings = recipe.servings;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context);
    return StreamBuilder(
        stream: _recipeStream,
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(
                  '${Languages.of(context)!.somethingWentWrong} ${snapshot.error}');
            } else if (snapshot.hasData) {
              final availableRecipes = snapshot.data!
                  .where((recipe) => recipe.deletedAt == null)
                  .toList();
              if (availableRecipes.isEmpty) {
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
                        const SizedBox(height: 12),
                        Text(
                          l!.recipeUnavailable,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }
              final data = availableRecipes.first;
              _updateServingDefaults(data.servings);
              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildRecipeHeader(data),
                          widget.open &&
                                  widget.additionalData != null &&
                                  widget.additionalData != "null"
                              ? buildTable(widget.additionalData!)
                              : Container(),
                          const SizedBox(height: 18),
                          buildImage(data),
                          if (data.description?.trim().isNotEmpty == true) ...[
                            const SizedBox(height: 26),
                            _SectionHeading(
                              icon: Icons.notes_outlined,
                              title: l!.description,
                            ),
                            const SizedBox(height: 10),
                            buildDesc(data),
                          ],
                          if (data.notes?.trim().isNotEmpty == true) ...[
                            const SizedBox(height: 26),
                            _SectionHeading(
                              icon: Icons.edit_note_outlined,
                              title: l!.recipeNotes,
                            ),
                            const SizedBox(height: 10),
                            LinkifiedText(data.notes!.trim()),
                          ],
                          const SizedBox(height: 24),
                          buildIngredients(data),
                          const SizedBox(height: 22),
                          buildButtons(data),
                          CommentSection(recipe: data),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text(l!.emptyData);
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget buildTable(String data) {
    Map<String, dynamic> keyvalue = jsonDecode(data);
    return Center(
      child: DataTable(
        headingRowHeight: 0,
        columns: const [
          DataColumn(
              label: Text(
            '',
          )),
          DataColumn(
              label: Text(
            '',
          )),
        ],
        rows: keyvalue.entries
            .map((e) => DataRow(cells: [
                  DataCell(Text(e.key.toString())),
                  DataCell(Text(e.value.toString()))
                ]))
            .toList(),
      ),
    );
  }

  Widget buildButtons(recipe) => buildStepButton(recipe);

  Future<void> _openRecipeSteps(Recipe recipe) async {
    if (_openingSteps) return;
    final accountId = currentAccount;
    if (accountId == null) return;
    setState(() => _openingSteps = true);
    try {
      final detailsReady =
          await SupabaseToDrift.ensureRecipeDetailsLoaded(recipe.id);
      if (!mounted) return;
      if (!detailsReady) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Languages.of(context)!.recipeDetailsNotReady,
            ),
          ),
        );
        return;
      }
      final now = DateTime.now().toUtc();
      await Singleton().getDatabase().updateHistoryEntry(
            recipe.id,
            now,
            accountId,
            accountId,
            now,
            accountId,
          );
      if (!mounted) return;
      final route = Navigator.of(context).push(
        appPageRoute(
          builder: (context) => RecipeStepOverview(
            recipe: recipe,
            ingredientScale: _ingredientScale(recipe),
          ),
          fullScreenSwipeBack: true,
        ),
      );
      SupabaseToDrift.sync();
      await route;
    } finally {
      if (mounted) setState(() => _openingSteps = false);
    }
  }

  Widget buildStepButton(recipe) {
    return StreamBuilder(
        stream: _stepsStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<RecipeStep>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(
                  '${Languages.of(context)!.somethingWentWrong} ${snapshot.error}');
            } else if (snapshot.hasData) {
              final l = Languages.of(context)!;
              final colors = Theme.of(context).colorScheme;
              return Visibility(
                  visible: snapshot.data!.isNotEmpty,
                  child: SizedBox(
                    width: double.infinity,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 72),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _openingSteps
                            ? null
                            : () => _openRecipeSteps(recipe),
                        child: Row(
                          children: [
                            if (_openingSteps)
                              const SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            else
                              const Icon(Icons.play_circle_outline, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l.recipeSteps,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: colors.onPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${l.stepCount(snapshot.data!.length)} · ${l.startCooking}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color:
                                              colors.onPrimary.withAlpha(220),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                  ));
            } else {
              return Text(Languages.of(context)!.emptyData);
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget buildDesc(recipe) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          recipe.description ?? "",
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );

  Widget buildRecipeHeader(Recipe recipe) {
    final l = Languages.of(context)!;
    final formatter = intl.DateFormat.yMd(l.languageCode);
    return StreamBuilder<List<Account>>(
      stream: Singleton().getDatabase().watchAccountById(recipe.createdBy),
      builder: (context, snapshot) {
        final creator = snapshot.data?.firstOrNull;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 9),
            InkWell(
              onTap: creator == null
                  ? null
                  : () => Navigator.of(context).push(
                        appPageRoute(
                          builder: (context) => AccountPage(
                            accountId: recipe.createdBy,
                          ),
                        ),
                      ),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (creator != null)
                      AccountAvatar(account: creator, radius: 15)
                    else
                      const CircleAvatar(
                        radius: 15,
                        child: Icon(Icons.person_outline, size: 17),
                      ),
                    const SizedBox(width: 9),
                    Text(
                      '${l.createdBy}: ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Flexible(
                      child: Text(
                        creator?.accountName ?? l.notSpecified,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: creator == null
                                  ? null
                                  : Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (creator != null)
                      const Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ResponsiveRecipeMetadata(
              createdLabel: l.createdAt,
              createdValue: formatter.format(recipe.createdAt.toLocal()),
              updatedLabel: l.lastUpdate,
              updatedValue: formatter.format(recipe.updatedAt.toLocal()),
              timeLabel: l.totalTime,
              timeValue: recipe.totalTimeMinutes == null
                  ? l.notSpecified
                  : l.formatDuration(recipe.totalTimeMinutes!),
              servingsLabel: l.servings,
              servingsValue: _selectedServings?.toString() ?? l.notSpecified,
            ),
            const SizedBox(height: 20),
            _SectionHeading(
              icon: Icons.sell_outlined,
              title: l.categorieButtonText,
            ),
            const SizedBox(height: 9),
            _RecipeCategories(recipeId: recipe.id),
          ],
        );
      },
    );
  }

  Widget buildIngredients(Recipe recipe) {
    return StreamBuilder(
        stream: _ingredientsStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<IngredientsOfRecipeResult>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(
                  '${Languages.of(context)!.somethingWentWrong} ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHeading(
                    icon: Icons.restaurant_menu,
                    title: Languages.of(context)!.ingredients,
                  ),
                  if (_baseServings != null && _baseServings! > 0) ...[
                    const SizedBox(height: 10),
                    _ServingSelector(
                      servings: _selectedServings ?? _baseServings!,
                      onChanged: (servings) {
                        setState(() => _selectedServings = servings);
                      },
                    ),
                  ],
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children:
                          _buildIngredientOverviewRows(recipe, snapshot.data!),
                    ),
                  ),
                ],
              );
            }
            return Container();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  List<Widget> _buildIngredientOverviewRows(
    Recipe recipe,
    List<IngredientsOfRecipeResult> ingredients,
  ) {
    final l = Languages.of(context)!;
    final rows = <Widget>[];
    String? previousSection;
    var isFirst = true;

    for (final ingredient in ingredients) {
      final rawSection = ingredient.sectionName?.trim();
      final section =
          rawSection == null || rawSection.isEmpty ? null : rawSection;
      if (isFirst || section != previousSection) {
        if (section != null) {
          rows.add(
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.fromLTRB(12, 9, 12, 7),
              child: Text(
                section,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          );
        } else if (!isFirst) {
          rows.add(
            Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
              color: Theme.of(context).dividerColor,
            ),
          );
        }
        previousSection = section;
        isFirst = false;
      } else {
        rows.add(
          Divider(
            height: 1,
            indent: 12,
            endIndent: 12,
            color: Theme.of(context).dividerColor,
          ),
        );
      }

      final scaledAmount = ingredient.amount == null
          ? null
          : _roundAmount(ingredient.amount! * _ingredientScale(recipe));
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 105,
                child: Text(
                  _ingredientQuantityLabel(ingredient, scaledAmount, l),
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: Theme.of(context).dividerColor,
              ),
              Expanded(
                child: Text(
                  ingredient.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StreamBuilder<bool>(
                stream: RecipePermissions.watchCanModifyContent(),
                builder: (context, permissionSnapshot) {
                  if (permissionSnapshot.data != true) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    tooltip: l.addToShoppingList,
                    onPressed: () => _addIngredientToShoppingList(
                      ingredient,
                      scaledAmount,
                    ),
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  String _formatAmount(double amount) {
    final rounded = _roundAmount(amount);
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toString();
  }

  double _roundAmount(double amount) => (amount * 1000).round() / 1000;

  String _ingredientQuantityLabel(
    IngredientsOfRecipeResult ingredient,
    double? amount,
    Languages l,
  ) {
    if (amount != null && ingredient.unit != null) {
      return '${_formatAmount(amount)} ${l.unitLabel(ingredient.unit!)}';
    }
    final note = ingredient.quantityNote?.trim();
    return note == null || note.isEmpty ? l.quantityNotSpecified : note;
  }

  void _updateServingDefaults(int? servings) {
    if (_baseServings == servings) return;
    if (_selectedServings == _baseServings) {
      _selectedServings = servings;
    }
    _baseServings = servings;
  }

  double _ingredientScale(Recipe recipe) {
    final baseServings = recipe.servings;
    final selectedServings = _selectedServings;
    if (baseServings == null ||
        baseServings <= 0 ||
        selectedServings == null ||
        selectedServings <= 0) {
      return 1;
    }
    return selectedServings / baseServings;
  }

  Future<void> _addIngredientToShoppingList(
    IngredientsOfRecipeResult ingredient,
    double? scaledAmount,
  ) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    if (!await RecipePermissions.canModifyContent()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.viewerCannotEdit)),
      );
      return;
    }

    final lists =
        await Singleton().getDatabase().getShoppingListsForAccount(accountId);
    if (!mounted) return;
    var shoppingCategoryCode = ingredient.shoppingCategoryCode;
    var categories = const <ShoppingCategory>[];
    if (shoppingCategoryCode == null) {
      try {
        categories = await SupabaseToDrift.ensureShoppingCategoriesLoaded();
      } catch (error) {
        logger.e('Could not load shopping categories: $error');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.somethingWentWrong)),
        );
        return;
      }
      if (!mounted) return;
      if (categories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.noCategoriesAvailable)),
        );
        return;
      }
    }

    final target = await _chooseShoppingListTarget(
      lists: lists,
      categories: categories,
      initialCategoryCode: shoppingCategoryCode,
      ingredient: ingredient,
      scaledAmount: scaledAmount,
    );
    if (target == null || !mounted) return;
    shoppingCategoryCode = target.shoppingCategoryCode;

    ShoppingList selectedList;
    if (target.list != null) {
      selectedList = target.list!;
    } else {
      try {
        selectedList = await DriftToSupabase.createShoppingList(
          accountId: accountId,
          name: target.newListName!,
        );
      } catch (error) {
        logger.e('Could not create shopping list: $error');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotSaveShoppingList)),
        );
        return;
      }
    }

    try {
      await DriftToSupabase.addShoppingListItem(
        accountId: accountId,
        shoppingListId: selectedList.id,
        ingredientId: ingredient.id,
        name: ingredient.name,
        amount: scaledAmount,
        unit: ingredient.unit,
        note: ingredient.quantityNote,
        shoppingCategoryCode: shoppingCategoryCode,
      );
      if (ingredient.shoppingCategoryCode != shoppingCategoryCode) {
        try {
          await DriftToSupabase.setIngredientShoppingCategory(
            accountId: accountId,
            ingredientId: ingredient.id,
            shoppingCategoryCode: shoppingCategoryCode,
          );
        } catch (error) {
          logger.w('Could not remember ingredient category: $error');
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.addedToShoppingList(selectedList.name))),
      );
    } catch (error) {
      logger.e('Could not add recipe ingredient to shopping list: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotSaveShoppingItem)),
      );
    }
  }

  Future<_IngredientShoppingTarget?> _chooseShoppingListTarget({
    required List<ShoppingList> lists,
    required List<ShoppingCategory> categories,
    required String? initialCategoryCode,
    required IngredientsOfRecipeResult ingredient,
    required double? scaledAmount,
  }) async {
    final l = Languages.of(context)!;
    var selectedListId = lists.firstOrNull?.id;
    var newListName = '';
    var selectedCategoryCode = initialCategoryCode ??
        categories
            .where((category) => category.code == 'other')
            .firstOrNull
            ?.code ??
        categories.firstOrNull?.code;
    return showDialog<_IngredientShoppingTarget>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final valid = lists.isEmpty
              ? newListName.trim().isNotEmpty && selectedCategoryCode != null
              : selectedListId != null && selectedCategoryCode != null;
          return AlertDialog(
            title: Text(l.addToShoppingList),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ingredient.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(scaledAmount == null
                      ? _ingredientQuantityLabel(ingredient, null, l)
                      : l.scaledAmount(
                          _ingredientQuantityLabel(
                            ingredient,
                            scaledAmount,
                            l,
                          ),
                        )),
                  const SizedBox(height: 14),
                  if (lists.isEmpty)
                    TextField(
                      autofocus: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: l.shoppingListName,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setDialogState(() => newListName = value);
                      },
                    )
                  else
                    DropdownButtonFormField<int>(
                      value: selectedListId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l.chooseShoppingList,
                        border: const OutlineInputBorder(),
                      ),
                      items: lists
                          .map((list) => DropdownMenuItem<int>(
                                value: list.id,
                                child: Text(
                                  list.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedListId = value);
                      },
                    ),
                  if (initialCategoryCode == null) ...[
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedCategoryCode,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l.supermarketCategory,
                        border: const OutlineInputBorder(),
                      ),
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category.code,
                                child: Row(
                                  children: [
                                    Icon(
                                      shoppingCategoryIcon(category.code),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        shoppingCategoryLabel(
                                          category,
                                          l.languageCode,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedCategoryCode = value);
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: valid
                    ? () => Navigator.of(dialogContext).pop(
                          _IngredientShoppingTarget(
                            list: lists.isEmpty
                                ? null
                                : lists.firstWhere(
                                    (list) => list.id == selectedListId,
                                  ),
                            newListName:
                                lists.isEmpty ? newListName.trim() : null,
                            shoppingCategoryCode: selectedCategoryCode!,
                          ),
                        )
                    : null,
                child: Text(l.addToShoppingList),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildImage(recipe) {
    final hasImage = recipe.image != null && recipe.image!.trim().isNotEmpty;
    if (!hasImage) {
      final l = Languages.of(context)!;
      return Container(
        height: 72,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              l.noImageAvailable,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: GestureDetector(
          child: Hero(
            tag: tagName,
            child: RecipeImage(
              recipeId: recipe.id,
              imageUrl: recipe.image,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              appPageRoute(
                  builder: (context) => FullScreenImageViewer(
                      id: recipe.id,
                      url: recipe.image!,
                      folderName: Const.recipeImagesFolderName.key,
                      tagName: tagName)),
            );
          },
        ),
      ),
    );
  }
}

class _IngredientShoppingTarget {
  const _IngredientShoppingTarget({
    required this.list,
    required this.newListName,
    required this.shoppingCategoryCode,
  });

  final ShoppingList? list;
  final String? newListName;
  final String shoppingCategoryCode;
}

class _ServingSelector extends StatelessWidget {
  const _ServingSelector({
    required this.servings,
    required this.onChanged,
  });

  final int servings;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          l.servings,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            border: Border.all(color: colors.outlineVariant),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: l.decreaseServings,
                onPressed: servings > 1 ? () => onChanged(servings - 1) : null,
                icon: const Icon(Icons.remove, size: 18),
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(
                width: 34,
                child: Text(
                  '$servings',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              IconButton(
                tooltip: l.increaseServings,
                onPressed: () => onChanged(servings + 1),
                icon: const Icon(Icons.add, size: 18),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResponsiveRecipeMetadata extends StatelessWidget {
  const _ResponsiveRecipeMetadata({
    required this.createdLabel,
    required this.createdValue,
    required this.updatedLabel,
    required this.updatedValue,
    required this.timeLabel,
    required this.timeValue,
    required this.servingsLabel,
    required this.servingsValue,
  });

  final String createdLabel;
  final String createdValue;
  final String updatedLabel;
  final String updatedValue;
  final String timeLabel;
  final String timeValue;
  final String servingsLabel;
  final String servingsValue;

  @override
  Widget build(BuildContext context) {
    final created = _CompactMetadataItem(
      icon: Icons.calendar_today_outlined,
      label: createdLabel,
      value: createdValue,
    );
    final updated = _CompactMetadataItem(
      icon: Icons.update,
      label: updatedLabel,
      value: updatedValue,
    );
    final time = _CompactMetadataItem(
      icon: Icons.schedule,
      label: timeLabel,
      value: timeValue,
    );
    final servings = _CompactMetadataItem(
      icon: Icons.people_outline,
      label: servingsLabel,
      value: servingsValue,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 560) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: created),
              const SizedBox(width: 10),
              Expanded(child: updated),
              const SizedBox(width: 10),
              Expanded(child: time),
              const SizedBox(width: 10),
              Expanded(child: servings),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: created),
                const SizedBox(width: 8),
                Expanded(child: updated),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: time),
                const SizedBox(width: 8),
                Expanded(child: servings),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _CompactMetadataItem extends StatelessWidget {
  const _CompactMetadataItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: colors.onSurfaceVariant),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 21, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _RecipeCategories extends StatelessWidget {
  const _RecipeCategories({required this.recipeId});

  final int recipeId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Category>>(
      stream: Singleton().getDatabase().watchCategoriesOfRecipe(recipeId),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];
        if (categories.isEmpty) {
          return Text(
            Languages.of(context)!.notSpecified,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }

        return Wrap(
          spacing: 7,
          runSpacing: 7,
          children: categories
              .map(
                (category) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
