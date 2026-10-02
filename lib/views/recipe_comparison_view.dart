import 'dart:typed_data';

import 'package:craftingrecipes/helpers/recipe_comparison.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:flutter/material.dart';

enum RecipeComparisonAction { useLatest, saveAsCopy }

class RecipeComparisonView extends StatelessWidget {
  const RecipeComparisonView({
    super.key,
    required this.draft,
    required this.latest,
    this.draftImageBytes,
  });

  final RecipeVersionSnapshot draft;
  final RecipeVersionSnapshot latest;
  final Uint8List? draftImageBytes;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l.keepEditing,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: Text(l.compareRecipeChanges),
      ),
      bottomNavigationBar: _ComparisonActions(
        onKeepEditing: () => Navigator.of(context).pop(),
        onUseLatest: () => Navigator.of(context).pop(
          RecipeComparisonAction.useLatest,
        ),
        onSaveAsCopy: () => Navigator.of(context).pop(
          RecipeComparisonAction.saveAsCopy,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.recipeComparisonMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  _VersionHeadings(),
                  const SizedBox(height: 14),
                  _ComparisonSection(
                    icon: Icons.notes_outlined,
                    title: l.basics,
                    children: [
                      _TextComparison(
                        label: l.recipeTitle,
                        draft: draft.title,
                        latest: latest.title,
                      ),
                      _TextComparison(
                        label: l.description,
                        draft: draft.description,
                        latest: latest.description,
                      ),
                      _TextComparison(
                        label: l.recipeNotes,
                        draft: draft.notes,
                        latest: latest.notes,
                      ),
                      _TextComparison(
                        label: l.totalTime,
                        draft: _duration(l, draft.totalTimeMinutes),
                        latest: _duration(l, latest.totalTimeMinutes),
                      ),
                      _TextComparison(
                        label: l.servings,
                        draft: draft.servings?.toString(),
                        latest: latest.servings?.toString(),
                      ),
                      _ImageComparison(
                        draftUrl: draft.imageUrl,
                        latestUrl: latest.imageUrl,
                        draftBytes: draftImageBytes,
                        changed: draft.imageComparisonKey !=
                            latest.imageComparisonKey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _ComparisonSection(
                    icon: Icons.label_outline,
                    title: l.categorieButtonText,
                    children: [
                      _TextComparison(
                        label: l.categorieButtonText,
                        draft: _categories(l, draft.categoryNames),
                        latest: _categories(l, latest.categoryNames),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _ComparisonSection(
                    icon: Icons.restaurant_menu,
                    title: l.ingredients,
                    children: [
                      _TextComparison(
                        label: l.ingredients,
                        draft: _ingredients(l, draft.ingredients),
                        latest: _ingredients(l, latest.ingredients),
                        draftComparisonKey: _ingredientKey(draft.ingredients),
                        latestComparisonKey: _ingredientKey(latest.ingredients),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _ComparisonSection(
                    icon: Icons.format_list_numbered,
                    title: l.steps,
                    children: [
                      _TextComparison(
                        label: l.steps,
                        draft: _steps(l, draft.steps),
                        latest: _steps(l, latest.steps),
                        draftComparisonKey: _stepKey(draft.steps),
                        latestComparisonKey: _stepKey(latest.steps),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _duration(Languages l, int? minutes) =>
      minutes == null ? l.notSpecified : l.formatDuration(minutes);

  String _categories(Languages l, List<String> names) =>
      names.isEmpty ? l.notSpecified : names.join(', ');

  String _ingredients(
    Languages l,
    List<RecipeVersionIngredient> ingredients,
  ) {
    if (ingredients.isEmpty) return l.noIngredientsAdded;
    String? previousSection;
    final lines = <String>[];
    final hasNamedSections = ingredients.any(
      (ingredient) => ingredient.sectionName?.trim().isNotEmpty == true,
    );
    var isFirst = true;
    for (final ingredient in ingredients) {
      final rawSection = ingredient.sectionName?.trim();
      final section =
          rawSection == null || rawSection.isEmpty ? null : rawSection;
      if ((isFirst || section != previousSection) &&
          (section != null || hasNamedSections)) {
        lines.add(section ?? l.noIngredientSection);
      }
      previousSection = section;
      isFirst = false;
      final amount = ingredient.amount;
      final quantity = amount != null && ingredient.unit != null
          ? '${_formatAmount(amount)} ${l.unitLabel(ingredient.unit!)}'
          : (ingredient.quantityNote?.trim().isNotEmpty ?? false)
              ? ingredient.quantityNote!.trim()
              : l.quantityNotSpecified;
      lines.add('$quantity  |  ${ingredient.name}');
    }
    return lines.join('\n');
  }

  String _steps(Languages l, List<RecipeVersionStep> steps) {
    if (steps.isEmpty) return l.noStepsAdded;
    return steps.map((step) {
      final assigned = step.ingredientNames.isEmpty
          ? ''
          : '\n${l.ingredients}: ${step.ingredientNames.join(', ')}';
      return '${step.stepNr}. ${step.description}$assigned';
    }).join('\n\n');
  }

  String _ingredientKey(List<RecipeVersionIngredient> ingredients) {
    final keys = ingredients.map((item) => item.comparisonKey).toList();
    return keys.join('\n');
  }

  String _stepKey(List<RecipeVersionStep> steps) =>
      steps.map((step) => step.comparisonKey).join('\n');

  String _formatAmount(double amount) => amount == amount.roundToDouble()
      ? amount.toInt().toString()
      : amount.toString();
}

class _VersionHeadings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) return const SizedBox.shrink();
        return Row(
          children: [
            const SizedBox(width: 180),
            Expanded(child: _VersionHeading(text: l.yourVersion)),
            const SizedBox(width: 12),
            Expanded(child: _VersionHeading(text: l.latestVersion)),
          ],
        );
      },
    );
  }
}

class _VersionHeading extends StatelessWidget {
  const _VersionHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  const _ComparisonSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class _TextComparison extends StatelessWidget {
  const _TextComparison({
    required this.label,
    required this.draft,
    required this.latest,
    this.draftComparisonKey,
    this.latestComparisonKey,
  });

  final String label;
  final String? draft;
  final String? latest;
  final String? draftComparisonKey;
  final String? latestComparisonKey;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final draftText =
        draft?.trim().isNotEmpty == true ? draft! : l.notSpecified;
    final latestText =
        latest?.trim().isNotEmpty == true ? latest! : l.notSpecified;
    final changed = (draftComparisonKey ?? draftText.trim()) !=
        (latestComparisonKey ?? latestText.trim());
    return _ComparisonRow(
      label: label,
      changed: changed,
      draft: Text(draftText),
      latest: Text(latestText),
    );
  }
}

class _ImageComparison extends StatelessWidget {
  const _ImageComparison({
    required this.draftUrl,
    required this.latestUrl,
    required this.draftBytes,
    required this.changed,
  });

  final String? draftUrl;
  final String? latestUrl;
  final Uint8List? draftBytes;
  final bool changed;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return _ComparisonRow(
      label: l.recipeImage,
      changed: changed,
      draft: _ComparisonImage(url: draftUrl, bytes: draftBytes),
      latest: _ComparisonImage(url: latestUrl),
    );
  }
}

class _ComparisonImage extends StatelessWidget {
  const _ComparisonImage({this.url, this.bytes});

  final String? url;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    final imageBytes = bytes;
    final imageUrl = url?.trim();
    final placeholder = Container(
      height: 120,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Text(Languages.of(context)!.noImageAvailable),
    );
    if (imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          imageBytes,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }
    if (imageUrl == null || imageUrl.isEmpty) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.changed,
    required this.draft,
    required this.latest,
  });

  final String label;
  final bool changed;
  final Widget draft;
  final Widget latest;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final labelWidget = Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        if (changed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              l.changed,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 700) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 180, child: labelWidget),
                Expanded(child: _VersionPanel(changed: changed, child: draft)),
                const SizedBox(width: 12),
                Expanded(
                  child: _VersionPanel(changed: changed, child: latest),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              labelWidget,
              const SizedBox(height: 8),
              Text(l.yourVersion,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              _VersionPanel(changed: changed, child: draft),
              const SizedBox(height: 8),
              Text(
                l.latestVersion,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              _VersionPanel(changed: changed, child: latest),
            ],
          );
        },
      ),
    );
  }
}

class _VersionPanel extends StatelessWidget {
  const _VersionPanel({required this.changed, required this.child});

  final bool changed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: changed
            ? colors.tertiaryContainer.withValues(alpha: 0.28)
            : colors.surfaceContainerLow,
        border: Border.all(
          color: changed ? colors.tertiary : colors.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _ComparisonActions extends StatelessWidget {
  const _ComparisonActions({
    required this.onKeepEditing,
    required this.onUseLatest,
    required this.onSaveAsCopy,
  });

  final VoidCallback onKeepEditing;
  final VoidCallback onUseLatest;
  final VoidCallback onSaveAsCopy;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            alignment: WrapAlignment.end,
            runAlignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: onKeepEditing,
                child: Text(l.keepEditing),
              ),
              OutlinedButton(
                onPressed: onUseLatest,
                child: Text(l.useLatestVersion),
              ),
              FilledButton(
                onPressed: onSaveAsCopy,
                child: Text(l.saveAsCopy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
