import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/recipe_step_view.dart';
import 'package:craftingrecipes/widgets/streambuilder_widgets.dart';
import 'package:flutter/material.dart';

const double _navigationItemExtent = 54;

class RecipeStepOverview extends StatefulWidget {
  const RecipeStepOverview({
    super.key,
    required this.recipe,
    this.ingredientScale = 1,
  });

  final Recipe recipe;
  final double ingredientScale;

  @override
  State<RecipeStepOverview> createState() => _RecipeStepOverviewState();
}

class _RecipeStepOverviewState extends State<RecipeStepOverview> {
  final ScrollController _contentController = ScrollController();
  final ScrollController _navigationController = ScrollController();
  final Map<int, GlobalKey> _contentKeys = {};
  final GlobalKey _contentViewportKey = GlobalKey();
  late final Stream<List<Recipe>> _recipeStream;
  late final Stream<List<RecipeStep>> _stepsStream;
  late final Stream<List<IngredientsOfRecipeResult>> _ingredientsStream;
  late final Future<List<RecipeStep>> _lastVisitedStepFuture;
  int? _selectedStepId;
  bool _selectionUpdateScheduled = false;
  bool _initialPositionApplied = false;
  bool _programmaticScroll = false;
  bool _finishing = false;
  int _scrollRequestId = 0;

  @override
  void initState() {
    super.initState();
    final database = Singleton().getDatabase();
    _recipeStream = database.getRecipeById(widget.recipe.id);
    _stepsStream = database.getRecipeStepsByRecipeId(widget.recipe.id);
    _ingredientsStream = database.getIngredientsByRecipeId(widget.recipe.id);
    _lastVisitedStepFuture = database.getLastVisitedStep(
      recipeId: widget.recipe.id,
      accountId: currentAccount!,
    );
    _contentController.addListener(_scheduleSelectionUpdate);
  }

  @override
  void dispose() {
    _contentController
      ..removeListener(_scheduleSelectionUpdate)
      ..dispose();
    _navigationController.dispose();
    super.dispose();
  }

  Future<void> _storeSelectedStep(RecipeStep step) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    await Singleton().getDatabase().setNewStep(
          accountId: accountId,
          recipeId: widget.recipe.id,
          stepNr: step.stepNr,
        );
  }

  Future<void> _finishRecipe() async {
    final firstStep = _visibleSteps.firstOrNull;
    if (firstStep == null || _finishing) return;
    setState(() => _finishing = true);
    try {
      await _storeSelectedStep(firstStep);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      logger.e('Could not finish recipe: $error');
      if (!mounted) return;
      setState(() => _finishing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Languages.of(context)!.somethingWentWrong)),
      );
    }
  }

  void _selectStep(
    RecipeStep step, {
    required bool scrollToContent,
  }) {
    if (_selectedStepId != step.id) {
      setState(() => _selectedStepId = step.id);
      _storeSelectedStep(step);
    }
    _scrollNavigationTo(step);
    if (scrollToContent) _scrollContentTo(step);
  }

  void _scrollNavigationTo(RecipeStep step, {bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_navigationController.hasClients) return;
      final index = _visibleSteps.indexWhere((entry) => entry.id == step.id);
      if (index < 0) return;
      final position = _navigationController.position;
      final target = (index * _navigationItemExtent -
              (position.viewportDimension - _navigationItemExtent) / 2)
          .clamp(0.0, position.maxScrollExtent)
          .toDouble();
      if (animate) {
        _navigationController.animateTo(
          target,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
        );
      } else {
        _navigationController.jumpTo(target);
      }
    });
  }

  void _scrollContentTo(RecipeStep step, {bool animate = true}) {
    final requestId = ++_scrollRequestId;
    _programmaticScroll = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || requestId != _scrollRequestId) return;
      final renderObject =
          _contentKeys[step.id]?.currentContext?.findRenderObject();
      if (renderObject == null || !_contentController.hasClients) {
        _programmaticScroll = false;
        return;
      }
      try {
        await _contentController.position.ensureVisible(
          renderObject,
          alignment: 0,
          duration: animate ? const Duration(milliseconds: 320) : Duration.zero,
          curve: Curves.easeOutCubic,
        );
      } finally {
        if (mounted && requestId == _scrollRequestId) {
          _programmaticScroll = false;
        }
      }
    });
  }

  void _scheduleSelectionUpdate() {
    if (_programmaticScroll || _selectionUpdateScheduled) return;
    _selectionUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectionUpdateScheduled = false;
      if (!mounted) return;
      _updateSelectionFromScroll();
    });
  }

  void _updateSelectionFromScroll() {
    if (_programmaticScroll) return;
    final viewportObject =
        _contentViewportKey.currentContext?.findRenderObject();
    if (viewportObject is! RenderBox) return;

    RecipeStep? currentStep;
    final scrollPosition = _contentController.position;
    if (scrollPosition.extentBefore <= 2) {
      currentStep = _visibleSteps.firstOrNull;
    } else if (scrollPosition.extentAfter <= 2) {
      currentStep = _visibleSteps.lastOrNull;
    }

    if (currentStep == null) {
      final readingLine = viewportObject.size.height * .35;
      for (final entry in _visibleSteps) {
        final stepObject =
            _contentKeys[entry.id]?.currentContext?.findRenderObject();
        if (stepObject is! RenderBox) continue;
        final top = stepObject
            .localToGlobal(
              Offset.zero,
              ancestor: viewportObject,
            )
            .dy;
        if (top <= readingLine) {
          currentStep = entry;
        } else {
          currentStep ??= entry;
          break;
        }
      }
    }

    if (currentStep != null && currentStep.id != _selectedStepId) {
      _selectStep(currentStep, scrollToContent: false);
    }
  }

  List<RecipeStep> _visibleSteps = const [];

  RecipeStep _preferredStep(
    List<RecipeStep> activeSteps,
    RecipeStep? lastVisitedStep,
  ) {
    if (_selectedStepId != null) {
      final selected =
          activeSteps.where((step) => step.id == _selectedStepId).firstOrNull;
      if (selected != null) return selected;
    }
    if (lastVisitedStep != null) {
      final sameId = activeSteps
          .where((step) => step.id == lastVisitedStep.id)
          .firstOrNull;
      if (sameId != null) return sameId;
      final sameNumber = activeSteps
          .where((step) => step.stepNr == lastVisitedStep.stepNr)
          .firstOrNull;
      if (sameNumber != null) return sameNumber;
    }
    return activeSteps.first;
  }

  void _applyInitialPosition(RecipeStep step) {
    if (_initialPositionApplied) return;
    _initialPositionApplied = true;
    _selectedStepId = step.id;
    _scrollContentTo(step, animate: false);
    _scrollNavigationTo(step, animate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: getTitleStream(_recipeStream)),
      body: StreamBuilder<List<RecipeStep>>(
        stream: _stepsStream,
        builder: (context, stepsSnapshot) {
          if (stepsSnapshot.hasError) {
            return Center(
              child: Text(
                '${Languages.of(context)!.somethingWentWrong} ${stepsSnapshot.error}',
              ),
            );
          }
          if (!stepsSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final activeSteps = [...stepsSnapshot.data!]
            ..sort((a, b) => a.stepNr.compareTo(b.stepNr));
          if (activeSteps.isEmpty) {
            return Center(child: Text(Languages.of(context)!.emptyData));
          }
          _visibleSteps = activeSteps;
          final activeIds = activeSteps.map((step) => step.id).toSet();
          _contentKeys.removeWhere((id, _) => !activeIds.contains(id));

          return FutureBuilder<List<RecipeStep>>(
            future: _lastVisitedStepFuture,
            builder: (context, lastVisitedSnapshot) {
              if (!lastVisitedSnapshot.hasData &&
                  !lastVisitedSnapshot.hasError) {
                return const Center(child: CircularProgressIndicator());
              }
              final preferred = _preferredStep(
                activeSteps,
                lastVisitedSnapshot.data?.firstOrNull,
              );
              _applyInitialPosition(preferred);
              return Column(
                children: [
                  _AllIngredientsPanel(
                    ingredientsStream: _ingredientsStream,
                    ingredientScale: widget.ingredientScale,
                  ),
                  Expanded(
                    child: _StepReader(
                      steps: activeSteps,
                      selectedStepId: _selectedStepId ?? preferred.id,
                      contentController: _contentController,
                      navigationController: _navigationController,
                      contentViewportKey: _contentViewportKey,
                      contentKeys: _contentKeys,
                      recipeTitle: widget.recipe.title,
                      ingredientScale: widget.ingredientScale,
                      finishing: _finishing,
                      onStepSelected: (step) =>
                          _selectStep(step, scrollToContent: true),
                      onDone: _finishRecipe,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _AllIngredientsPanel extends StatelessWidget {
  const _AllIngredientsPanel({
    required this.ingredientsStream,
    required this.ingredientScale,
  });

  final Stream<List<IngredientsOfRecipeResult>> ingredientsStream;
  final double ingredientScale;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return StreamBuilder<List<IngredientsOfRecipeResult>>(
      stream: ingredientsStream,
      builder: (context, snapshot) {
        final ingredients =
            snapshot.data ?? const <IngredientsOfRecipeResult>[];
        if (ingredients.isEmpty) return const SizedBox.shrink();
        final ingredientRows = <Widget>[];
        String? previousSection;
        var isFirst = true;
        for (final ingredient in ingredients) {
          final rawSection = ingredient.sectionName?.trim();
          final section =
              rawSection == null || rawSection.isEmpty ? null : rawSection;
          if (isFirst || section != previousSection) {
            if (section != null) {
              ingredientRows.add(
                Padding(
                  padding: EdgeInsets.only(top: isFirst ? 2 : 12, bottom: 3),
                  child: Text(
                    section,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              );
            } else if (!isFirst) {
              ingredientRows.add(
                Divider(height: 1, color: colors.outlineVariant),
              );
            }
          } else if (!isFirst) {
            ingredientRows.add(
              Divider(height: 1, color: colors.outlineVariant),
            );
          }
          previousSection = section;
          isFirst = false;

          final amount = ingredient.amount == null
              ? null
              : _formatIngredientAmount(
                  ingredient.amount! * ingredientScale,
                );
          final note = ingredient.quantityNote?.trim();
          final quantity = amount != null && ingredient.unit != null
              ? '$amount ${l.unitLabel(ingredient.unit!)}'
              : (note == null || note.isEmpty ? l.quantityNotSpecified : note);
          ingredientRows.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                children: [
                  SizedBox(
                    width: 92,
                    child: Text(
                      quantity,
                      textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 22,
                    color: colors.outlineVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(ingredient.name)),
                ],
              ),
            ),
          );
        }
        return Material(
          color: colors.surfaceContainerLow,
          child: ExpansionTile(
            leading: Icon(Icons.restaurant_menu, color: colors.primary),
            title: Text(
              l.allIngredients,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            shape: Border(
              bottom: BorderSide(color: colors.outlineVariant),
            ),
            collapsedShape: Border(
              bottom: BorderSide(color: colors.outlineVariant),
            ),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * .34,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: ingredientRows,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepReader extends StatelessWidget {
  const _StepReader({
    required this.steps,
    required this.selectedStepId,
    required this.contentController,
    required this.navigationController,
    required this.contentViewportKey,
    required this.contentKeys,
    required this.recipeTitle,
    required this.ingredientScale,
    required this.finishing,
    required this.onStepSelected,
    required this.onDone,
  });

  final List<RecipeStep> steps;
  final int selectedStepId;
  final ScrollController contentController;
  final ScrollController navigationController;
  final GlobalKey contentViewportKey;
  final Map<int, GlobalKey> contentKeys;
  final String recipeTitle;
  final double ingredientScale;
  final bool finishing;
  final ValueChanged<RecipeStep> onStepSelected;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const navigationWidth = 56.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: navigationWidth,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: ListView.builder(
                  controller: navigationController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemExtent: _navigationItemExtent,
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final selected = step.id == selectedStepId;
                    return _StepNavigationItem(
                      step: step,
                      selected: selected,
                      isFirst: index == 0,
                      isLast: index == steps.length - 1,
                      onTap: () => onStepSelected(step),
                    );
                  },
                ),
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              key: contentViewportKey,
              child: Scrollbar(
                controller: contentController,
                child: SingleChildScrollView(
                  controller: contentController,
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var index = 0; index < steps.length; index++) ...[
                        _StepContent(
                          key: contentKeys.putIfAbsent(
                            steps[index].id,
                            () => GlobalKey(),
                          ),
                          step: steps[index],
                          recipeTitle: recipeTitle,
                          ingredientScale: ingredientScale,
                          selected: steps[index].id == selectedStepId,
                        ),
                        if (index < steps.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(),
                          ),
                      ],
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: finishing ? null : onDone,
                          icon: finishing
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline),
                          label: Text(Languages.of(context)!.done),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * .7),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

String _formatIngredientAmount(double amount) {
  final rounded = (amount * 1000).round() / 1000;
  return rounded == rounded.roundToDouble()
      ? rounded.toInt().toString()
      : rounded.toString();
}

class _StepNavigationItem extends StatelessWidget {
  const _StepNavigationItem({
    required this.step,
    required this.selected,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final RecipeStep step;
  final bool selected;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: '${Languages.of(context)!.step} ${step.stepNr}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 27,
                top: isFirst ? _navigationItemExtent / 2 : 0,
                bottom: isLast ? _navigationItemExtent / 2 : 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 2,
                  color: selected
                      ? colors.primary.withAlpha(150)
                      : colors.outlineVariant,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? colors.primary : colors.surface,
                  border: Border.all(
                    color: selected ? colors.primary : colors.outlineVariant,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Text(
                  '${step.stepNr}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: selected
                            ? colors.onPrimary
                            : colors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepContent extends StatelessWidget {
  const _StepContent({
    super.key,
    required this.step,
    required this.recipeTitle,
    required this.ingredientScale,
    required this.selected,
  });

  final RecipeStep step;
  final String recipeTitle;
  final double ingredientScale;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: selected
            ? colors.primaryContainer.withAlpha(72)
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: selected ? colors.primary : Colors.transparent,
            width: 3,
          ),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${Languages.of(context)!.step} ${step.stepNr}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: selected ? colors.onPrimaryContainer : null,
                ),
          ),
          const SizedBox(height: 16),
          RecipeStepView(
            recipeTitle: recipeTitle,
            recipeStep: step,
            ingredientScale: ingredientScale,
            embedded: true,
          ),
        ],
      ),
    );
  }
}
