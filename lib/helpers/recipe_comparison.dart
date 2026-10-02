import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/main.dart';

class RecipeVersionIngredient {
  const RecipeVersionIngredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.quantityNote,
    this.sectionName,
    this.sortOrder = 0,
  });

  final int? id;
  final String name;
  final double? amount;
  final String? unit;
  final String? quantityNote;
  final String? sectionName;
  final int sortOrder;

  String get comparisonKey => '$sortOrder|${sectionName?.trim().toLowerCase()}|'
      '${name.trim().toLowerCase()}|$amount|${unit?.trim().toLowerCase()}|'
      '${quantityNote?.trim().toLowerCase()}';
}

class RecipeVersionStep {
  const RecipeVersionStep({
    required this.stepNr,
    required this.description,
    required this.ingredientNames,
  });

  final int stepNr;
  final String description;
  final List<String> ingredientNames;

  String get comparisonKey {
    final names = ingredientNames
        .map((name) => name.trim().toLowerCase())
        .toList()
      ..sort();
    return '$stepNr|${description.trim()}|${names.join('|')}';
  }
}

class RecipeVersionSnapshot {
  const RecipeVersionSnapshot({
    required this.revision,
    required this.title,
    required this.description,
    this.notes,
    required this.totalTimeMinutes,
    required this.servings,
    required this.imageUrl,
    required this.imageComparisonKey,
    required this.categoryNames,
    required this.ingredients,
    required this.steps,
  });

  final int revision;
  final String title;
  final String? description;
  final String? notes;
  final int? totalTimeMinutes;
  final int? servings;
  final String? imageUrl;
  final String imageComparisonKey;
  final List<String> categoryNames;
  final List<RecipeVersionIngredient> ingredients;
  final List<RecipeVersionStep> steps;
}

class RecipeComparisonRepository {
  static Future<RecipeVersionSnapshot?> fetchRemoteRecipe(int recipeId) async {
    final recipe = await supabase
        .from('recipe')
        .select(
          '${Const.title.key},${Const.description.key},'
          '${Const.notes.key},'
          '${Const.totalTimeMinutes.key},${Const.servings.key},'
          '${Const.image.key},'
          'revision,${Const.updatedAt.key}',
        )
        .eq(Const.id.key, recipeId)
        .isFilter(Const.deletedAt.key, null)
        .maybeSingle();
    if (recipe == null) return null;

    final ingredientLinks = await supabase
        .from('recipe_ingredient')
        .select(
          '${Const.ingredientId.key},${Const.amount.key},${Const.unit.key},'
          '${Const.quantityNote.key},${Const.sectionName.key},'
          '${Const.sortOrder.key}',
        )
        .eq(Const.recipeId.key, recipeId)
        .isFilter(Const.deletedAt.key, null)
        .order(Const.sortOrder.key);
    final stepRows = await supabase
        .from('recipe_step')
        .select(
          '${Const.id.key},${Const.stepNr.key},${Const.description.key}',
        )
        .eq(Const.recipeId.key, recipeId)
        .isFilter(Const.deletedAt.key, null)
        .order(Const.stepNr.key);
    final categoryLinks = await supabase
        .from('recipe_category')
        .select(Const.categoryId.key)
        .eq(Const.recipeId.key, recipeId)
        .isFilter(Const.deletedAt.key, null);

    final ingredientIds = ingredientLinks
        .map((row) => (row[Const.ingredientId.key] as num).toInt())
        .toSet();
    final stepIds =
        stepRows.map((row) => (row[Const.id.key] as num).toInt()).toSet();
    final categoryIds = categoryLinks
        .map((row) => (row[Const.categoryId.key] as num).toInt())
        .toSet();

    final ingredientRows = ingredientIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await supabase
            .from('ingredient')
            .select('${Const.id.key},${Const.name.key}')
            .inFilter(Const.id.key, ingredientIds.toList())
            .isFilter(Const.deletedAt.key, null);
    final stepIngredientRows = stepIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await supabase
            .from('recipe_step_ingredient')
            .select('${Const.recipeStepId.key},${Const.ingredientId.key}')
            .inFilter(Const.recipeStepId.key, stepIds.toList())
            .isFilter(Const.deletedAt.key, null);
    final categoryRows = categoryIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await supabase
            .from('category')
            .select('${Const.id.key},${Const.name.key}')
            .inFilter(Const.id.key, categoryIds.toList())
            .isFilter(Const.deletedAt.key, null);

    final ingredientNames = <int, String>{
      for (final row in ingredientRows)
        (row[Const.id.key] as num).toInt(): row[Const.name.key].toString(),
    };
    final categories = categoryRows
        .map((row) => row[Const.name.key].toString())
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final ingredients = ingredientLinks.map((row) {
      final ingredientId = (row[Const.ingredientId.key] as num).toInt();
      return RecipeVersionIngredient(
        id: ingredientId,
        name: ingredientNames[ingredientId] ?? '#$ingredientId',
        amount: (row[Const.amount.key] as num?)?.toDouble(),
        unit: _nullableString(row[Const.unit.key]),
        quantityNote: _nullableString(row[Const.quantityNote.key]),
        sectionName: _nullableString(row[Const.sectionName.key]),
        sortOrder: (row[Const.sortOrder.key] as num?)?.toInt() ?? 0,
      );
    }).toList();

    final ingredientIdsByStep = <int, List<int>>{};
    for (final row in stepIngredientRows) {
      final stepId = (row[Const.recipeStepId.key] as num).toInt();
      ingredientIdsByStep.putIfAbsent(stepId, () => []).add(
            (row[Const.ingredientId.key] as num).toInt(),
          );
    }
    final steps = stepRows.map((row) {
      final stepId = (row[Const.id.key] as num).toInt();
      final names = (ingredientIdsByStep[stepId] ?? const <int>[])
          .map((id) => ingredientNames[id] ?? '#$id')
          .toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return RecipeVersionStep(
        stepNr: (row[Const.stepNr.key] as num).toInt(),
        description: row[Const.description.key].toString(),
        ingredientNames: names,
      );
    }).toList();

    final imageUrl = _nullableString(recipe[Const.image.key]);
    return RecipeVersionSnapshot(
      revision: (recipe['revision'] as num).toInt(),
      title: recipe[Const.title.key].toString(),
      description: _nullableString(recipe[Const.description.key]),
      notes: _nullableString(recipe[Const.notes.key]),
      totalTimeMinutes: (recipe[Const.totalTimeMinutes.key] as num?)?.toInt(),
      servings: (recipe[Const.servings.key] as num?)?.toInt(),
      imageUrl: imageUrl,
      imageComparisonKey: imageUrl ?? '',
      categoryNames: categories,
      ingredients: ingredients,
      steps: steps,
    );
  }

  static String? _nullableString(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}
