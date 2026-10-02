import 'dart:convert';
import 'dart:typed_data';

import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/recipe_comparison.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/widgets/recipe_image.dart';
import 'package:craftingrecipes/views/recipe_comparison_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Route<bool> recipeEditorRoute({Recipe? recipe}) {
  return PageRouteBuilder<bool>(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CreateRecipeView(recipe: recipe),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );
}

class CreateRecipeView extends StatefulWidget {
  const CreateRecipeView({super.key, this.recipe});

  final Recipe? recipe;

  @override
  State<CreateRecipeView> createState() => _CreateRecipeViewState();
}

class _CreateRecipeViewState extends State<CreateRecipeView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _totalTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final List<_IngredientInput> _ingredients = [];
  final List<String> _ingredientSectionOrder = [];
  final List<_StepInput> _steps = [];
  List<Category> _categories = [];
  final Set<int> _selectedCategoryIds = {};
  bool _isSaving = false;
  bool _isLoading = true;
  bool _loadFailed = false;
  bool _isDiscarding = false;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _removeExistingImage = false;
  String? _initialFormState;
  late int _expectedRevision;

  bool get _isEditing => widget.recipe != null;
  bool get _hasCompleteIngredient =>
      _ingredients.any((ingredient) => ingredient.isComplete);
  bool get _hasCompleteStep =>
      _steps.any((step) => step.descriptionController.text.trim().isNotEmpty);
  bool get _hasPartialIngredient =>
      _ingredients.any((ingredient) => ingredient.isPartial);
  int? get _totalTimeMinutes => int.tryParse(_totalTimeController.text.trim());
  int? get _servings => int.tryParse(_servingsController.text.trim());
  bool get _hasValidTotalTime =>
      _totalTimeController.text.trim().isEmpty ||
      (_totalTimeMinutes != null && _totalTimeMinutes! > 0);
  bool get _hasValidServings =>
      _servingsController.text.trim().isEmpty ||
      (_servings != null && _servings! > 0);
  bool get _canSave =>
      !_isSaving &&
      currentAccount != null &&
      _titleController.text.trim().isNotEmpty &&
      _hasCompleteIngredient &&
      !_hasPartialIngredient &&
      _hasValidTotalTime &&
      _hasValidServings &&
      _hasCompleteStep;

  @override
  void initState() {
    super.initState();
    _expectedRevision = widget.recipe?.revision ?? 1;
    _loadRecipe();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _totalTimeController.dispose();
    _servingsController.dispose();
    for (final ingredient in _ingredients) {
      ingredient.dispose();
    }
    for (final step in _steps) {
      step.dispose();
    }
    super.dispose();
  }

  Future<void> _addIngredient({String? sectionName}) =>
      _openIngredientEditor(initialSectionName: sectionName);

  Future<void> _editIngredient(int index) =>
      _openIngredientEditor(index: index);

  Future<void> _openIngredientEditor({
    int? index,
    String? initialSectionName,
  }) async {
    final editingIngredient = index == null ? null : _ingredients[index];
    final result = await showModalBottomSheet<_IngredientEditorResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _IngredientEditorSheet(
        ingredient: editingIngredient,
        sections: _ingredientSectionOrder,
        initialSectionName: initialSectionName,
      ),
    );

    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _ingredients.add(_IngredientInput(
          name: result.name,
          amount: result.amount,
          unit: result.unit,
          quantityNote: result.quantityNote,
          sectionName: result.sectionName,
        ));
      } else {
        _ingredients[index].setValues(
          name: result.name,
          amount: result.amount,
          unit: result.unit,
          quantityNote: result.quantityNote,
          sectionName: result.sectionName,
        );
      }
      _normalizeIngredientOrder();
    });
  }

  List<Set<_IngredientInput>> _selectedIngredientsByStep() {
    return _steps.map((step) {
      return step.selectedIngredientIndexes
          .where((index) => index >= 0 && index < _ingredients.length)
          .map((index) => _ingredients[index])
          .toSet();
    }).toList();
  }

  void _restoreStepIngredientSelections(
    List<Set<_IngredientInput>> selectedIngredients,
  ) {
    for (var stepIndex = 0; stepIndex < _steps.length; stepIndex++) {
      final selected = selectedIngredients[stepIndex];
      _steps[stepIndex].selectedIngredientIndexes = _ingredients
          .asMap()
          .entries
          .where((entry) => selected.contains(entry.value))
          .map((entry) => entry.key)
          .toSet();
    }
  }

  void _normalizeIngredientOrder() {
    final selectedIngredients = _selectedIngredientsByStep();
    final ordered = <_IngredientInput>[
      ..._ingredients.where((ingredient) => ingredient.sectionName == null),
    ];
    for (final section in _ingredientSectionOrder) {
      ordered.addAll(
        _ingredients.where((ingredient) => ingredient.sectionName == section),
      );
    }
    ordered.addAll(
      _ingredients.where(
        (ingredient) =>
            ingredient.sectionName != null &&
            !_ingredientSectionOrder.contains(ingredient.sectionName),
      ),
    );
    _ingredients
      ..clear()
      ..addAll(ordered);
    _restoreStepIngredientSelections(selectedIngredients);
  }

  void _reorderIngredientsInSection(
    String? sectionName,
    int oldIndex,
    int newIndex,
  ) {
    final selectedIngredients = _selectedIngredientsByStep();
    final group = _ingredients
        .where((ingredient) => ingredient.sectionName == sectionName)
        .toList();
    if (newIndex > oldIndex) newIndex--;
    final moved = group.removeAt(oldIndex);
    group.insert(newIndex, moved);
    var groupIndex = 0;
    for (var index = 0; index < _ingredients.length; index++) {
      if (_ingredients[index].sectionName == sectionName) {
        _ingredients[index] = group[groupIndex++];
      }
    }
    _restoreStepIngredientSelections(selectedIngredients);
  }

  Future<String?> _showIngredientSectionNameDialog({
    String? initialName,
  }) async {
    final l = Languages.of(context)!;
    var name = initialName ?? '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final trimmed = name.trim();
          final duplicate = _ingredientSectionOrder.any(
            (section) =>
                section != initialName &&
                section.toLowerCase() == trimmed.toLowerCase(),
          );
          return AlertDialog(
            title: Text(initialName == null
                ? l.addIngredientSection
                : l.renameIngredientSection),
            content: TextFormField(
              initialValue: name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.ingredientSectionName,
                errorText: duplicate
                    ? l.ingredientSectionNameAlreadyExists(name)
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setDialogState(() => name = value),
              onFieldSubmitted: trimmed.isNotEmpty && !duplicate
                  ? (_) => Navigator.of(dialogContext).pop(trimmed)
                  : null,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: trimmed.isNotEmpty && !duplicate
                    ? () => Navigator.of(dialogContext).pop(trimmed)
                    : null,
                child: Text(l.save),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addIngredientSection() async {
    final name = await _showIngredientSectionNameDialog();
    if (name == null || !mounted) return;
    setState(() => _ingredientSectionOrder.add(name));
  }

  Future<void> _renameIngredientSection(String sectionName) async {
    final name =
        await _showIngredientSectionNameDialog(initialName: sectionName);
    if (name == null || name == sectionName || !mounted) return;
    setState(() {
      final sectionIndex = _ingredientSectionOrder.indexOf(sectionName);
      if (sectionIndex >= 0) _ingredientSectionOrder[sectionIndex] = name;
      for (final ingredient in _ingredients) {
        if (ingredient.sectionName == sectionName) {
          ingredient.sectionName = name;
        }
      }
    });
  }

  Future<void> _removeIngredientSection(String sectionName) async {
    final l = Languages.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.removeIngredientSection),
        content: Text(l.confirmRemoveIngredientSection(sectionName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _ingredientSectionOrder.remove(sectionName);
      for (final ingredient in _ingredients) {
        if (ingredient.sectionName == sectionName) {
          ingredient.sectionName = null;
        }
      }
      _normalizeIngredientOrder();
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index).dispose();
      for (final step in _steps) {
        step.selectedIngredientIndexes.remove(index);
        step.selectedIngredientIndexes =
            step.selectedIngredientIndexes.map((selectedIndex) {
          return selectedIndex > index ? selectedIndex - 1 : selectedIndex;
        }).toSet();
      }
    });
  }

  Future<void> _confirmAndRemoveIngredient(int index) async {
    final l = Languages.of(context)!;
    final ingredientName = _ingredientDeleteName(index);
    final shouldDelete = await _confirmDelete(
      title: '${l.delete} ${l.ingredient.toLowerCase()}?',
      message: l.confirmRemoveFromRecipe(ingredientName),
    );
    if (!shouldDelete || !mounted) return;
    _removeIngredient(index);
  }

  Future<void> _addStep() => _openStepEditor();

  Future<void> _editStep(int index) => _openStepEditor(index: index);

  Future<void> _openStepEditor({int? index}) async {
    final editingStep = index == null ? null : _steps[index];
    final result = await showModalBottomSheet<_StepEditorResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _StepEditorSheet(
        step: editingStep,
        ingredients: _ingredients,
      ),
    );

    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _steps.add(_StepInput(
          description: result.description,
          selectedIngredientIndexes: result.selectedIngredientIndexes,
        ));
      } else {
        _steps[index].setValues(
          description: result.description,
          selectedIngredientIndexes: result.selectedIngredientIndexes,
        );
      }
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index).dispose();
    });
  }

  Future<void> _confirmAndRemoveStep(int index) async {
    final l = Languages.of(context)!;
    final stepName = _stepDeleteName(index);
    final shouldDelete = await _confirmDelete(
      title: '${l.delete} ${l.step.toLowerCase()}?',
      message: l.confirmRemoveFromRecipe(stepName),
    );
    if (!shouldDelete || !mounted) return;
    _removeStep(index);
  }

  Future<bool> _confirmDelete({
    required String title,
    required String message,
  }) async {
    final l = Languages.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l.delete),
            ),
          ],
        );
      },
    );
    return shouldDelete ?? false;
  }

  String _ingredientDeleteName(int index) {
    final l = Languages.of(context)!;
    final name = _ingredients[index].nameController.text.trim();
    return name.isEmpty ? '${l.ingredient} ${index + 1}' : name;
  }

  String _stepDeleteName(int index) {
    final l = Languages.of(context)!;
    final description = _steps[index].descriptionController.text.trim();
    if (description.isEmpty) return '${l.step} ${index + 1}';
    final preview = description.length > 40
        ? '${description.substring(0, 40)}...'
        : description;
    return '${l.step} ${index + 1}: $preview';
  }

  String _currentFormState() {
    final categoryIds = _selectedCategoryIds.toList()..sort();
    return jsonEncode({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'notes': _notesController.text,
      'totalTimeMinutes': _totalTimeController.text,
      'servings': _servingsController.text,
      'image': {
        'selectedName': _selectedImageName,
        'selectedLength': _selectedImageBytes?.length,
        'removeExisting': _removeExistingImage,
      },
      'categoryIds': categoryIds,
      'ingredientSectionOrder': _ingredientSectionOrder,
      'ingredients':
          _ingredients.map((ingredient) => ingredient.toSnapshot()).toList(),
      'steps': _steps.map((step) => step.toSnapshot()).toList(),
    });
  }

  bool get _hasUnsavedChanges {
    final initialFormState = _initialFormState;
    if (initialFormState == null) return false;
    return _currentFormState() != initialFormState;
  }

  Future<bool> _confirmDiscardChanges() async {
    if (!_hasUnsavedChanges) return true;
    final l = Languages.of(context)!;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l.discardChanges),
          content: Text(l.discardChangesMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.keepEditing),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l.discard),
            ),
          ],
        );
      },
    );

    return shouldDiscard ?? false;
  }

  Future<void> _discardChanges() async {
    if (_isSaving) return;
    final shouldDiscard = await _confirmDiscardChanges();
    if (!shouldDiscard || !mounted) return;

    setState(() {
      _isDiscarding = true;
    });
    Navigator.of(context).pop(false);
  }

  Future<void> _saveRecipe() async {
    final l = Languages.of(context)!;
    if (!_formKey.currentState!.validate() || currentAccount == null) {
      return;
    }
    final accountId = currentAccount!;

    final ingredientEntries = _ingredients
        .asMap()
        .entries
        .where((entry) => !entry.value.isEmpty)
        .toList();
    if (ingredientEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.completeIngredientRequired),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    _RecipeSavePayload? payload;
    try {
      final isAllowed = _isEditing
          ? await RecipePermissions.canEditRecipe(widget.recipe!)
          : await RecipePermissions.canCreateRecipe();
      if (!isAllowed) {
        throw Exception(l.viewerCannotEdit);
      }

      final imageUrl = _removeExistingImage ? null : widget.recipe?.image;
      final selectedImageBytes = _selectedImageBytes;

      final ingredientIndexMap = <int, int>{};
      for (final entry in ingredientEntries) {
        ingredientIndexMap[entry.key] = ingredientIndexMap.length;
      }

      final ingredients = ingredientEntries.map((entry) {
        final ingredient = entry.value;
        return {
          'name': ingredient.nameController.text.trim(),
          'amount': ingredient.amount,
          'unit': ingredient.unit,
          Const.quantityNote.key: ingredient.quantityNote,
          Const.sectionName.key: ingredient.sectionName,
          Const.sortOrder.key: ingredientIndexMap[entry.key],
        };
      }).toList();

      final steps = _steps.asMap().entries.map((entry) {
        return {
          'id': entry.value.id,
          'step_nr': entry.key + 1,
          'description': entry.value.descriptionController.text.trim(),
          'image': null,
          'ingredient_indexes': entry.value.selectedIngredientIndexes
              .map((index) => ingredientIndexMap[index])
              .whereType<int>()
              .toList()
            ..sort(),
        };
      }).toList();
      final categoryIds = _selectedCategoryIds.toList()..sort();
      payload = _RecipeSavePayload(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        totalTimeMinutes: _totalTimeMinutes,
        servings: _servings,
        image: imageUrl,
        ingredients: ingredients,
        steps: steps,
        categoryIds: categoryIds,
      );

      if (_isEditing) {
        await DriftToSupabase.updateRecipeWithDetails(
          accountId: accountId,
          recipeId: widget.recipe!.id,
          title: payload.title,
          description: payload.description,
          notes: payload.notes,
          totalTimeMinutes: payload.totalTimeMinutes,
          servings: payload.servings,
          image: payload.image,
          ingredients: payload.ingredients,
          steps: payload.steps,
          categoryIds: payload.categoryIds,
          expectedRevision: _expectedRevision,
          imageBytes: selectedImageBytes,
          imageName: _selectedImageName,
        );
      } else {
        await DriftToSupabase.createRecipeWithDetails(
          accountId: accountId,
          title: payload.title,
          description: payload.description,
          notes: payload.notes,
          totalTimeMinutes: payload.totalTimeMinutes,
          servings: payload.servings,
          image: payload.image,
          ingredients: payload.ingredients,
          steps: payload.steps,
          categoryIds: payload.categoryIds,
          imageBytes: selectedImageBytes,
          imageName: _selectedImageName,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on RecipeEditConflictException {
      if (payload != null) {
        await _resolveRecipeEditConflict(
          accountId: accountId,
          payload: payload,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _isEditing ? l.couldNotUpdateRecipe : l.couldNotCreateRecipe)),
      );
      logger.e('Could not save recipe: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _resolveRecipeEditConflict({
    required int accountId,
    required _RecipeSavePayload payload,
  }) async {
    if (!mounted) return;
    final l = Languages.of(context)!;
    RecipeVersionSnapshot? latest;
    try {
      latest = await RecipeComparisonRepository.fetchRemoteRecipe(
        widget.recipe!.id,
      );
    } catch (error) {
      logger.e('Could not load recipe comparison: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotCompareRecipe)),
      );
      return;
    }
    if (!mounted) return;
    if (latest == null) {
      await _resolveDeletedRecipe(
        accountId: accountId,
        payload: payload,
      );
      return;
    }

    final action = await Navigator.of(context).push<RecipeComparisonAction>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => RecipeComparisonView(
          draft: _draftComparisonSnapshot(payload),
          latest: latest!,
          draftImageBytes: _selectedImageBytes,
        ),
      ),
    );
    if (!mounted) return;
    if (action == null) {
      setState(() => _expectedRevision = latest!.revision);
      return;
    }

    if (action == RecipeComparisonAction.useLatest) {
      try {
        await DriftToSupabase.discardPendingRecipeDraft(widget.recipe!.id);
        await SupabaseToDrift.sync();
        if (mounted) Navigator.of(context).pop(true);
      } catch (error) {
        logger.e('Could not load latest recipe after edit conflict: $error');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotLoadLatestRecipe)),
        );
      }
      return;
    }

    await _saveRecipeAsCopy(
      accountId: accountId,
      payload: payload,
    );
  }

  RecipeVersionSnapshot _draftComparisonSnapshot(
    _RecipeSavePayload payload,
  ) {
    final categoryNamesById = {
      for (final category in _categories) category.id: category.name,
    };
    final categoryNames = payload.categoryIds
        .map((id) => categoryNamesById[id] ?? '#$id')
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final ingredients = payload.ingredients.map((ingredient) {
      return RecipeVersionIngredient(
        id: null,
        name: ingredient['name'].toString(),
        amount: (ingredient['amount'] as num?)?.toDouble(),
        unit: ingredient['unit'] as String?,
        quantityNote: ingredient[Const.quantityNote.key] as String?,
        sectionName: ingredient[Const.sectionName.key] as String?,
        sortOrder: (ingredient[Const.sortOrder.key] as num?)?.toInt() ?? 0,
      );
    }).toList();
    final steps = payload.steps.map((step) {
      final indexes = (step['ingredient_indexes'] as List<dynamic>)
          .map((index) => (index as num).toInt());
      final ingredientNames = indexes
          .where((index) => index >= 0 && index < ingredients.length)
          .map((index) => ingredients[index].name)
          .toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return RecipeVersionStep(
        stepNr: (step['step_nr'] as num).toInt(),
        description: step['description'].toString(),
        ingredientNames: ingredientNames,
      );
    }).toList();

    return RecipeVersionSnapshot(
      revision: _expectedRevision,
      title: payload.title,
      description: payload.description,
      notes: payload.notes,
      totalTimeMinutes: payload.totalTimeMinutes,
      servings: payload.servings,
      imageUrl: payload.image,
      imageComparisonKey:
          _selectedImageBytes == null ? payload.image ?? '' : 'local-image',
      categoryNames: categoryNames,
      ingredients: ingredients,
      steps: steps,
    );
  }

  Future<void> _resolveDeletedRecipe({
    required int accountId,
    required _RecipeSavePayload payload,
  }) async {
    if (!mounted) return;
    final l = Languages.of(context)!;
    final saveAsCopy = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l.recipeDeletedTitle),
          content: Text(l.recipeDeletedRemotely),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l.keepEditing),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l.saveAsCopy),
            ),
          ],
        );
      },
    );

    if (saveAsCopy != true) {
      return;
    }
    if (!mounted) return;

    await _saveRecipeAsCopy(
      accountId: accountId,
      payload: payload,
    );
  }

  Future<void> _saveRecipeAsCopy({
    required int accountId,
    required _RecipeSavePayload payload,
  }) async {
    final l = Languages.of(context)!;
    try {
      await DriftToSupabase.createRecipeWithDetails(
        accountId: accountId,
        title: l.recipeCopyTitle(payload.title),
        description: payload.description,
        notes: payload.notes,
        totalTimeMinutes: payload.totalTimeMinutes,
        servings: payload.servings,
        image: payload.image,
        ingredients: payload.ingredients,
        steps: payload.steps,
        categoryIds: payload.categoryIds,
        imageBytes: _selectedImageBytes,
        imageName: _selectedImageName,
      );
      await DriftToSupabase.discardPendingRecipeDraft(widget.recipe!.id);
      await DriftToSupabase.tryCleanupOrphanedImages(accountId: accountId);
      try {
        await SupabaseToDrift.sync();
      } catch (error) {
        logger.w('Recipe copy saved, but local refresh failed: $error');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.recipeSavedAsCopy)),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      logger.e('Could not save conflicted recipe as a copy: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotCreateRecipe)),
      );
    }
  }

  Future<void> _loadRecipe() async {
    final database = Singleton().getDatabase();
    _categories = await database.allCategoryEntries.first;

    if (!_isEditing) {
      _initialFormState = _currentFormState();
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final recipe = widget.recipe!;
    await SupabaseToDrift.waitForActiveSync();
    var ingredients = await database.getIngredientsByRecipeId(recipe.id).first;
    var steps = await database.getRecipeStepsByRecipeId(recipe.id).first;
    if (ingredients.isEmpty || steps.isEmpty) {
      await SupabaseToDrift.ensureRecipeDetailsLoaded(recipe.id);
      ingredients = await database.getIngredientsByRecipeId(recipe.id).first;
      steps = await database.getRecipeStepsByRecipeId(recipe.id).first;
    }
    if (ingredients.isEmpty || steps.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadFailed = true;
      });
      return;
    }

    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description ?? '';
    _notesController.text = recipe.notes ?? '';
    _totalTimeController.text = recipe.totalTimeMinutes?.toString() ?? '';
    _servingsController.text = recipe.servings?.toString() ?? '';

    final recipeCategories = await database.getCategoriesOfRecipe(recipe.id);
    _selectedCategoryIds
        .addAll(recipeCategories.map((category) => category.id));

    final ingredientIdToIndex = <int, int>{};
    for (final ingredient in ingredients) {
      final sectionName = ingredient.sectionName?.trim();
      if (sectionName != null &&
          sectionName.isNotEmpty &&
          !_ingredientSectionOrder.contains(sectionName)) {
        _ingredientSectionOrder.add(sectionName);
      }
      ingredientIdToIndex[ingredient.id] = _ingredients.length;
      _ingredients.add(_IngredientInput(
        name: ingredient.name,
        amount: ingredient.amount == null
            ? null
            : _formatAmount(ingredient.amount!),
        unit: ingredient.unit,
        quantityNote: ingredient.quantityNote,
        sectionName:
            sectionName == null || sectionName.isEmpty ? null : sectionName,
      ));
    }

    for (final step in steps) {
      final stepInput = _StepInput(
        id: step.id,
        description: step.description,
      );
      final stepIngredients =
          await database.getIngredientsByRecipeStepId(step.id).first;
      for (final ingredient in stepIngredients) {
        final ingredientIndex = ingredientIdToIndex[ingredient.id];
        if (ingredientIndex != null) {
          stepInput.selectedIngredientIndexes.add(ingredientIndex);
        }
      }
      _steps.add(stepInput);
    }
    if (!mounted) return;
    _initialFormState = _currentFormState();
    setState(() {
      _isLoading = false;
      _loadFailed = false;
    });
  }

  Future<void> _retryLoadingRecipe() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });
    await _loadRecipe();
  }

  String _formatAmount(double amount) {
    return amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? l.editRecipe : l.createRecipe),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadFailed) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.editRecipe),
          leading: IconButton(
            tooltip: l.close,
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.recipeDetailsNotReady,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _retryLoadingRecipe,
                  icon: const Icon(Icons.refresh),
                  label: Text(l.tryAgain),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: _isDiscarding,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _discardChanges();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: l.close,
            onPressed: _isSaving ? null : _discardChanges,
            icon: const Icon(Icons.close),
          ),
          title: Text(_isEditing ? l.editRecipe : l.createRecipe),
          actions: [
            IconButton(
              tooltip: l.save,
              onPressed: _canSave ? _saveRecipe : null,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomActionBar(),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 104),
            children: [
              _buildUnsavedState(),
              _FormSection(
                icon: Icons.notes,
                title: l.basics,
                child: _buildBasicsSection(),
              ),
              const SizedBox(height: 20),
              _FormSection(
                icon: Icons.edit_note_outlined,
                title: l.recipeNotes,
                child: TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    hintText: l.recipeNotesHint,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  minLines: 4,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 20),
              _FormSection(
                icon: Icons.image_outlined,
                title: l.recipeImage,
                child: _buildImageSection(),
              ),
              const SizedBox(height: 20),
              _FormSection(
                icon: Icons.label_outline,
                title: l.categorieButtonText,
                child: _buildCategorySection(),
              ),
              const SizedBox(height: 20),
              _FormSection(
                icon: Icons.restaurant_menu,
                title: l.ingredients,
                action: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: l.addIngredientSection,
                      onPressed: _addIngredientSection,
                      icon: const Icon(Icons.playlist_add),
                    ),
                    IconButton(
                      tooltip: l.addIngredient,
                      onPressed: _addIngredient,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                child: _buildIngredientList(),
              ),
              const SizedBox(height: 20),
              _FormSection(
                icon: Icons.format_list_numbered,
                title: l.steps,
                action: IconButton(
                  tooltip: l.addStep,
                  onPressed: _addStep,
                  icon: const Icon(Icons.add),
                ),
                child: _buildStepList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final l = Languages.of(context)!;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_canSave && !_isSaving) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l.recipeSaveRequirements,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSaving ? null : _discardChanges,
                    icon: const Icon(Icons.close),
                    label: Text(l.discard),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _canSave ? _saveRecipe : null,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isEditing ? l.saveChanges : l.saveRecipe),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsavedState() {
    if (!_hasUnsavedChanges) return const SizedBox.shrink();
    final l = Languages.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.edit_note,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            l.unsavedChanges,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicsSection() {
    final l = Languages.of(context)!;
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: l.recipeTitle,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            return value == null || value.trim().isEmpty
                ? l.recipeTitleRequired
                : null;
          },
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: l.description,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _totalTimeController,
          decoration: InputDecoration(
            labelText: l.totalTimeMinutes,
            prefixIcon: const Icon(Icons.schedule),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return null;
            final minutes = int.tryParse(value.trim());
            return minutes == null || minutes <= 0 ? l.invalidTotalTime : null;
          },
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _servingsController,
          decoration: InputDecoration(
            labelText: l.recipeServings,
            prefixIcon: const Icon(Icons.people_outline),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return null;
            final servings = int.tryParse(value.trim());
            return servings == null || servings <= 0 ? l.invalidServings : null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  bool get _hasRecipeImage {
    if (_selectedImageBytes != null) return true;
    return !_removeExistingImage &&
        widget.recipe?.image != null &&
        widget.recipe!.image!.trim().isNotEmpty;
  }

  Future<void> _chooseRecipeImage() async {
    final l = Languages.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                l.chooseImageSource,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.chooseFromGallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.takePhoto),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageName = image.name;
        _removeExistingImage = false;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.imageSelectionFailed)),
      );
      logger.e('Could not select recipe image: $error');
    }
  }

  void _removeRecipeImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageName = null;
      _removeExistingImage = true;
    });
  }

  Widget _buildImageSection() {
    final l = Languages.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _selectedImageBytes != null
                ? Image.memory(
                    _selectedImageBytes!,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  )
                : _hasRecipeImage
                    ? RecipeImage(
                        recipeId: widget.recipe!.id,
                        imageUrl: widget.recipe!.image,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.image_not_supported_outlined,
                                size: 40),
                            const SizedBox(height: 8),
                            Text(l.noImageAvailable),
                          ],
                        ),
                      ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (_hasRecipeImage)
              OutlinedButton.icon(
                onPressed: _chooseRecipeImage,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l.changeImage),
              )
            else
              FilledButton.tonalIcon(
                onPressed: _chooseRecipeImage,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(l.addImage),
              ),
            if (_hasRecipeImage)
              OutlinedButton.icon(
                onPressed: _removeRecipeImage,
                icon: const Icon(Icons.delete_outline),
                label: Text(l.removeImage),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildIngredientList() {
    final l = Languages.of(context)!;
    if (_ingredients.isEmpty && _ingredientSectionOrder.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmptyFormSection(
            icon: Icons.restaurant_menu,
            message: l.noIngredientsAdded,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _addIngredientSection,
            icon: const Icon(Icons.playlist_add),
            label: Text(l.addIngredientSection),
          ),
        ],
      );
    }

    final groups = <String?>[
      if (_ingredients.any((ingredient) => ingredient.sectionName == null))
        null,
      ..._ingredientSectionOrder,
    ];
    return Column(
      children: [
        for (var index = 0; index < groups.length; index++) ...[
          _buildIngredientGroup(groups[index]),
          if (index < groups.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _buildIngredientGroup(String? sectionName) {
    final l = Languages.of(context)!;
    final ingredients = _ingredients
        .where((ingredient) => ingredient.sectionName == sectionName)
        .toList();
    final showHeading =
        sectionName != null || _ingredientSectionOrder.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeading)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    sectionName ?? l.noIngredientSection,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l.addIngredient,
                  onPressed: () => _addIngredient(sectionName: sectionName),
                  icon: const Icon(Icons.add, size: 20),
                ),
                if (sectionName != null) ...[
                  IconButton(
                    tooltip: l.renameIngredientSection,
                    onPressed: () => _renameIngredientSection(sectionName),
                    icon: const Icon(Icons.edit_outlined, size: 20),
                  ),
                  IconButton(
                    tooltip: l.removeIngredientSection,
                    onPressed: () => _removeIngredientSection(sectionName),
                    icon: const Icon(Icons.delete_outline, size: 20),
                  ),
                ],
              ],
            ),
          ),
        if (ingredients.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              l.noIngredientsAdded,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: ingredients.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                _reorderIngredientsInSection(sectionName, oldIndex, newIndex);
              });
            },
            itemBuilder: (context, groupIndex) {
              final ingredient = ingredients[groupIndex];
              final ingredientIndex = _ingredients.indexOf(ingredient);
              return _buildIngredientSummary(
                ingredientIndex,
                key: ObjectKey(ingredient),
                dragIndex: groupIndex,
              );
            },
          ),
      ],
    );
  }

  Widget _buildIngredientSummary(
    int index, {
    required Key key,
    required int dragIndex,
  }) {
    final l = Languages.of(context)!;
    final ingredient = _ingredients[index];
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => _editIngredient(index),
        leading: ReorderableDragStartListener(
          index: dragIndex,
          child: Tooltip(
            message: l.reorderIngredient,
            child: const Icon(Icons.drag_handle),
          ),
        ),
        title: Text(ingredient.displayName),
        subtitle: Text(ingredient.quantityLabel(l)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: l.editIngredient,
              onPressed: () => _editIngredient(index),
              icon: const Icon(Icons.edit),
            ),
            _DeleteButton(
              tooltip: l.removeIngredient,
              onPressed: () => _confirmAndRemoveIngredient(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final l = Languages.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _categories.isEmpty
            ? Text(l.noCategoriesAvailable)
            : Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _categories.map((category) {
                  return FilterChip(
                    label: Text(category.name),
                    selected: _selectedCategoryIds.contains(category.id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategoryIds.add(category.id);
                        } else {
                          _selectedCategoryIds.remove(category.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildStepList() {
    final l = Languages.of(context)!;
    if (_steps.isEmpty) {
      return _EmptyFormSection(
        icon: Icons.format_list_numbered,
        message: l.noStepsAdded,
      );
    }

    return Column(
      children: List.generate(_steps.length, _buildStepSummary),
    );
  }

  Widget _buildStepSummary(int index) {
    final l = Languages.of(context)!;
    final step = _steps[index];
    final ingredientSummary = _stepIngredientSummary(step);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _editStep(index),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(child: Text('${index + 1}')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l.step} ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.descriptionController.text.trim(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ingredientSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l.editStep,
                onPressed: () => _editStep(index),
                icon: const Icon(Icons.edit),
              ),
              _DeleteButton(
                tooltip: l.removeStep,
                onPressed: () => _confirmAndRemoveStep(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _stepIngredientSummary(_StepInput step) {
    final l = Languages.of(context)!;
    final names = step.selectedIngredientIndexes
        .where((index) => index >= 0 && index < _ingredients.length)
        .map((index) => _ingredients[index].displayName)
        .toList();
    if (names.isEmpty) return l.noIngredientsAssigned;
    if (names.length <= 3) return '${l.ingredients}: ${names.join(', ')}';
    return '${l.ingredients}: ${names.take(3).join(', ')} +${names.length - 3} ${l.more}';
  }
}

class _RecipeSavePayload {
  const _RecipeSavePayload({
    required this.title,
    required this.description,
    required this.notes,
    required this.totalTimeMinutes,
    required this.servings,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.categoryIds,
  });

  final String title;
  final String? description;
  final String? notes;
  final int? totalTimeMinutes;
  final int? servings;
  final String? image;
  final List<Map<String, dynamic>> ingredients;
  final List<Map<String, dynamic>> steps;
  final List<int> categoryIds;
}

class _IngredientInput {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final unitController = TextEditingController();
  final quantityNoteController = TextEditingController();
  String? sectionName;

  _IngredientInput({
    String? name,
    String? amount,
    String? unit,
    String? quantityNote,
    this.sectionName,
  }) {
    nameController.text = name ?? '';
    amountController.text = amount ?? '';
    unitController.text = unit ?? '';
    quantityNoteController.text = quantityNote ?? '';
  }

  bool get isEmpty =>
      nameController.text.trim().isEmpty &&
      amountController.text.trim().isEmpty &&
      unitController.text.trim().isEmpty &&
      quantityNoteController.text.trim().isEmpty;

  bool get isComplete =>
      nameController.text.trim().isNotEmpty &&
      ((!hasAmount && unit == null) ||
          (amount != null && amount! > 0 && unit != null));

  bool get isPartial => !isEmpty && !isComplete;

  double? get amount => parseAmount(amountController.text);
  bool get hasAmount => amountController.text.trim().isNotEmpty;
  String? get unit {
    final value = unitController.text.trim();
    return value.isEmpty ? null : value;
  }

  String? get quantityNote {
    final value = quantityNoteController.text.trim();
    return value.isEmpty ? null : value;
  }

  String get displayName => nameController.text.trim();

  String quantityLabel(Languages l) {
    final parsedAmount = amount;
    final selectedUnit = unit;
    if (parsedAmount != null && selectedUnit != null) {
      final formattedAmount = parsedAmount == parsedAmount.roundToDouble()
          ? parsedAmount.toInt().toString()
          : parsedAmount.toString();
      return '$formattedAmount ${l.unitLabel(selectedUnit)}';
    }
    return quantityNote ?? l.quantityNotSpecified;
  }

  static double? parseAmount(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  void setValues({
    required String name,
    required String? amount,
    required String? unit,
    required String? quantityNote,
    required String? sectionName,
  }) {
    nameController.text = name;
    amountController.text = amount ?? '';
    unitController.text = unit ?? '';
    quantityNoteController.text = quantityNote ?? '';
    this.sectionName = sectionName;
  }

  Map<String, String?> toSnapshot() {
    return {
      'name': nameController.text,
      'amount': amountController.text,
      'unit': unitController.text,
      'quantityNote': quantityNoteController.text,
      'sectionName': sectionName,
    };
  }

  void dispose() {
    nameController.dispose();
    amountController.dispose();
    unitController.dispose();
    quantityNoteController.dispose();
  }
}

class _StepInput {
  final descriptionController = TextEditingController();
  final int? id;
  Set<int> selectedIngredientIndexes = {};

  _StepInput({
    this.id,
    String? description,
    Set<int>? selectedIngredientIndexes,
  }) {
    descriptionController.text = description ?? '';
    this.selectedIngredientIndexes =
        Set<int>.from(selectedIngredientIndexes ?? {});
  }

  void setValues({
    required String description,
    required Set<int> selectedIngredientIndexes,
  }) {
    descriptionController.text = description;
    this.selectedIngredientIndexes = Set<int>.from(selectedIngredientIndexes);
  }

  Map<String, Object> toSnapshot() {
    final selectedIndexes = selectedIngredientIndexes.toList()..sort();
    return {
      'description': descriptionController.text,
      'selectedIngredientIndexes': selectedIndexes,
    };
  }

  void dispose() {
    descriptionController.dispose();
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.icon,
    required this.title,
    required this.child,
    this.action,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (action != null) action!,
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    required this.tooltip,
    required this.onPressed,
  });

  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: const Icon(Icons.delete),
    );
  }
}

class _EmptyFormSection extends StatelessWidget {
  const _EmptyFormSection({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _IngredientEditorResult {
  const _IngredientEditorResult({
    required this.name,
    required this.amount,
    required this.unit,
    required this.quantityNote,
    required this.sectionName,
  });

  final String name;
  final String? amount;
  final String? unit;
  final String? quantityNote;
  final String? sectionName;
}

const _recipeIngredientUnitPriority = <String>[
  'g',
  'ml',
  'piece',
  'kg',
  'l',
  'tsp',
  'tbsp',
  'cup',
  'pinch',
  'clove',
  'slice',
  'package',
  'can',
  'bottle',
  'handful',
  'bunch',
  'sprig',
  'drop',
  'dl',
  'cl',
  'mg',
  'oz',
  'lb',
  'fl_oz',
];

List<MeasurementUnit> _sortRecipeIngredientUnits(
  List<MeasurementUnit> units,
) {
  final priority = {
    for (var index = 0; index < _recipeIngredientUnitPriority.length; index++)
      _recipeIngredientUnitPriority[index]: index,
  };
  final sorted = [...units];
  sorted.sort((first, second) {
    final firstPriority = priority[first.code] ?? priority.length;
    final secondPriority = priority[second.code] ?? priority.length;
    final priorityComparison = firstPriority.compareTo(secondPriority);
    if (priorityComparison != 0) return priorityComparison;
    final orderComparison = first.sortOrder.compareTo(second.sortOrder);
    if (orderComparison != 0) return orderComparison;
    return first.code.compareTo(second.code);
  });
  return sorted;
}

class _IngredientEditorSheet extends StatefulWidget {
  _IngredientEditorSheet({
    required List<String> sections,
    this.ingredient,
    this.initialSectionName,
  }) : sections = List<String>.unmodifiable(sections);

  final _IngredientInput? ingredient;
  final List<String> sections;
  final String? initialSectionName;

  @override
  State<_IngredientEditorSheet> createState() => _IngredientEditorSheetState();
}

class _IngredientEditorSheetState extends State<_IngredientEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _quantityNoteController;
  late final Future<List<MeasurementUnit>> _unitsFuture;
  String? _selectedUnitCode;
  String? _selectedSectionName;
  bool _showUnitError = false;

  bool get _isEditing => widget.ingredient != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.ingredient?.nameController.text ?? '',
    );
    _amountController = TextEditingController(
      text: widget.ingredient?.amountController.text ?? '',
    );
    _quantityNoteController = TextEditingController(
      text: widget.ingredient?.quantityNoteController.text ?? '',
    );
    final existingUnit = widget.ingredient?.unitController.text.trim() ?? '';
    _selectedUnitCode = existingUnit.isEmpty ? null : existingUnit;
    _selectedSectionName =
        widget.ingredient?.sectionName ?? widget.initialSectionName;
    _unitsFuture = Singleton()
        .getDatabase()
        .getSelectableMeasurementUnits()
        .then(_sortRecipeIngredientUnits);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _quantityNoteController.dispose();
    super.dispose();
  }

  void _submit() {
    final formIsValid = _formKey.currentState!.validate();
    final hasAmount = _amountController.text.trim().isNotEmpty;
    final hasUnit = _selectedUnitCode != null;
    setState(() => _showUnitError = hasAmount && !hasUnit);
    if (!formIsValid || hasAmount != hasUnit) return;
    Navigator.of(context).pop(
      _IngredientEditorResult(
        name: _nameController.text.trim(),
        amount: hasAmount ? _amountController.text.trim() : null,
        unit: _selectedUnitCode,
        quantityNote: _nullableText(_quantityNoteController.text),
        sectionName: _selectedSectionName,
      ),
    );
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _unitPickerLabel(MeasurementUnit unit, Languages l) {
    final name = l.languageCode == 'de' ? unit.nameDe : unit.nameEn;
    final displayCode = l.unitLabel(unit.code);
    if (displayCode.toLowerCase() == name.toLowerCase()) return name;
    return '$displayCode - $name';
  }

  Future<void> _showUnitPicker(List<MeasurementUnit> units) async {
    if (units.isEmpty) return;
    FocusScope.of(context).unfocus();
    final l = Languages.of(context)!;
    final initialIndex = units.indexWhere(
      (unit) => unit.code == _selectedUnitCode,
    );
    var selectedIndex = initialIndex < 0 ? 0 : initialIndex;
    final controller = FixedExtentScrollController(
      initialItem: selectedIndex,
    );
    final selectedCode = await showCupertinoModalPopup<String>(
      context: context,
      builder: (popupContext) {
        final backgroundColor = CupertinoDynamicColor.resolve(
          CupertinoColors.systemBackground,
          popupContext,
        );
        return Container(
          height: 330,
          color: backgroundColor,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.of(popupContext).pop(),
                      child: Text(l.cancel),
                    ),
                    const Spacer(),
                    Text(
                      l.unit,
                      style: CupertinoTheme.of(popupContext)
                          .textTheme
                          .navTitleTextStyle,
                    ),
                    const Spacer(),
                    CupertinoButton(
                      onPressed: () => Navigator.of(popupContext)
                          .pop(units[selectedIndex].code),
                      child: Text(l.done),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 42,
                    useMagnifier: true,
                    magnification: 1.08,
                    onSelectedItemChanged: (index) {
                      selectedIndex = index;
                    },
                    children: units
                        .map(
                          (unit) => Center(
                            child: Text(_unitPickerLabel(unit, l)),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    controller.dispose();
    if (selectedCode == null || !mounted) return;
    setState(() {
      _selectedUnitCode = selectedCode;
      _showUnitError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final sectionOptions = widget.sections
        .map((section) => section.trim())
        .where((section) => section.isNotEmpty)
        .toSet()
        .toList();
    final selectedSection = _selectedSectionName?.trim();
    if (selectedSection != null &&
        selectedSection.isNotEmpty &&
        !sectionOptions.contains(selectedSection)) {
      sectionOptions.add(selectedSection);
    }
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? l.editIngredient : l.addIngredient,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l.ingredientName,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l.ingredientNameRequired
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedSection ?? '',
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l.ingredientSection,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(l.noIngredientSection),
                    ),
                    ...sectionOptions.map(
                      (section) => DropdownMenuItem(
                        value: section,
                        child: Text(
                          section,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSectionName =
                          value == null || value.isEmpty ? null : value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: l.optionalAmount,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return _selectedUnitCode == null
                                ? null
                                : l.amountRequired;
                          }
                          final amount = _IngredientInput.parseAmount(value);
                          if (amount == null) {
                            return l.invalidAmount;
                          }
                          return amount <= 0 ? l.amountAboveZero : null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FutureBuilder<List<MeasurementUnit>>(
                        future: _unitsFuture,
                        builder: (context, snapshot) {
                          final units = snapshot.data ?? [];
                          final selectedUnit = units
                              .where(
                                (unit) => unit.code == _selectedUnitCode,
                              )
                              .firstOrNull;
                          return InkWell(
                            onTap: units.isEmpty
                                ? null
                                : () => _showUnitPicker(units),
                            borderRadius: BorderRadius.circular(4),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: l.optionalUnit,
                                errorText:
                                    _showUnitError ? l.unitRequired : null,
                                border: const OutlineInputBorder(),
                                suffixIcon: selectedUnit == null
                                    ? const Icon(Icons.unfold_more_outlined)
                                    : IconButton(
                                        tooltip: l.clearSelection,
                                        onPressed: () {
                                          setState(() {
                                            _selectedUnitCode = null;
                                            _showUnitError = false;
                                          });
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                              ),
                              child: snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const CupertinoActivityIndicator()
                                  : Text(
                                      selectedUnit == null
                                          ? (units.isEmpty
                                              ? l.noUnitsAvailable
                                              : l.notSpecified)
                                          : _unitPickerLabel(selectedUnit, l),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityNoteController,
                  decoration: InputDecoration(
                    labelText: l.ingredientQuantityNote,
                    hintText: l.ingredientQuantityNoteHint,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(_isEditing ? l.save : l.addIngredient),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepEditorResult {
  const _StepEditorResult({
    required this.description,
    required this.selectedIngredientIndexes,
  });

  final String description;
  final Set<int> selectedIngredientIndexes;
}

class _StepEditorSheet extends StatefulWidget {
  const _StepEditorSheet({
    required this.ingredients,
    this.step,
  });

  final List<_IngredientInput> ingredients;
  final _StepInput? step;

  @override
  State<_StepEditorSheet> createState() => _StepEditorSheetState();
}

class _StepEditorSheetState extends State<_StepEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final Set<int> _selectedIngredientIndexes;

  bool get _isEditing => widget.step != null;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.step?.descriptionController.text ?? '',
    );
    _selectedIngredientIndexes =
        Set<int>.from(widget.step?.selectedIngredientIndexes ?? {});
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _StepEditorResult(
        description: _descriptionController.text.trim(),
        selectedIngredientIndexes: Set<int>.from(
          _selectedIngredientIndexes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? l.editStep : l.addStep,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: l.stepInstruction,
                    border: const OutlineInputBorder(),
                  ),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l.stepTextRequired
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  l.ingredientsInStep,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: widget.ingredients.isEmpty
                      ? Center(
                          child: Text(
                            l.addIngredientsFirst,
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.ingredients.length,
                          itemBuilder: (context, ingredientIndex) {
                            final ingredient =
                                widget.ingredients[ingredientIndex];
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: _selectedIngredientIndexes
                                  .contains(ingredientIndex),
                              title: Text(ingredient.displayName),
                              subtitle: Text(ingredient.quantityLabel(l)),
                              onChanged: (selected) {
                                setState(() {
                                  if (selected ?? false) {
                                    _selectedIngredientIndexes
                                        .add(ingredientIndex);
                                  } else {
                                    _selectedIngredientIndexes
                                        .remove(ingredientIndex);
                                  }
                                });
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(_isEditing ? l.save : l.addStep),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
