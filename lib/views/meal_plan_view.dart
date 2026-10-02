import 'dart:async';
import 'dart:math' as math;

import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/recipe_view.dart';
import 'package:craftingrecipes/widgets/recipe_picker_sheet.dart';
import 'package:craftingrecipes/widgets/shared_access_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const _mealSlots = ['breakfast', 'lunch', 'dinner', 'snack'];

class MealPlanView extends StatefulWidget {
  const MealPlanView({super.key});

  @override
  State<MealPlanView> createState() => _MealPlanViewState();
}

class _MealPlanViewState extends State<MealPlanView> {
  final ScrollController _dayScrollController = ScrollController();
  late DateTime _weekStart;
  late DateTime _selectedDay;
  late final Stream<List<MealPlan>> _plansStream;
  late final Stream<List<SharedResourceInvitation>> _invitationsStream;
  late final Stream<List<Recipe>> _recipesStream;
  int? _selectedMealPlanId = currentProfile;
  bool _saving = false;
  bool _positionedCurrentWeek = false;

  DateTime get _weekEnd => _weekStart.add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _selectedDay = _dateOnly(DateTime.now());
    _weekStart = _startOfWeek(_selectedDay);
    final accountId = currentAccount;
    _plansStream = accountId == null
        ? Stream.value(const <MealPlan>[])
        : Singleton().getDatabase().watchMealPlansForAccount(accountId);
    _invitationsStream = accountId == null
        ? Stream.value(const <SharedResourceInvitation>[])
        : Singleton().getDatabase().watchPendingMealPlanInvitations(accountId);
    _recipesStream = Singleton().getDatabase().watchSelectableRecipes();
  }

  Future<void> _respondToInvitation(
    SharedResourceInvitation invitation,
    bool accept,
  ) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    await _runAction(
      () => DriftToSupabase.respondToMealPlanInvitation(
        accountId: accountId,
        mealPlanId: invitation.resourceId,
        accept: accept,
      ),
    );
    if (accept && mounted) {
      setState(() => _selectedMealPlanId = invitation.resourceId);
    }
  }

  Widget _invitationPanel() => StreamBuilder<List<SharedResourceInvitation>>(
        stream: _invitationsStream,
        builder: (context, snapshot) => SharedInvitationsPanel(
          invitations: snapshot.data ?? const [],
          onAccept: (invitation) => _respondToInvitation(invitation, true),
          onDecline: (invitation) => _respondToInvitation(invitation, false),
        ),
      );

  @override
  void dispose() {
    _dayScrollController.dispose();
    super.dispose();
  }

  Stream<List<MealPlanEntry>> _watchCurrentWeek(int mealPlanId) {
    return Singleton().getDatabase().watchMealPlanEntriesForWeek(
          mealPlanId,
          _weekStart,
          _weekEnd,
        );
  }

  void _setWeek(DateTime date, {bool selectDate = false}) {
    setState(() {
      final newWeekStart = _startOfWeek(date);
      if (selectDate) {
        _selectedDay = _dateOnly(date);
      } else {
        final weekdayOffset = _selectedDay.difference(_weekStart).inDays;
        _selectedDay = newWeekStart.add(Duration(days: weekdayOffset));
      }
      _weekStart = newWeekStart;
      _positionedCurrentWeek = false;
    });
  }

  void _selectDay(DateTime date) {
    final normalized = _dateOnly(date);
    if (!_sameDate(_startOfWeek(normalized), _weekStart)) {
      _setWeek(normalized, selectDate: true);
      return;
    }
    setState(() => _selectedDay = normalized);
  }

  Future<void> _pickWeek() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _weekStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) _setWeek(picked, selectDate: true);
  }

  Future<void> _openMealEditor({
    required DateTime initialDate,
    required String initialSlot,
    required List<Recipe> recipes,
    required List<MealPlanEntry> entries,
    MealPlanEntry? entry,
    BuildContext? presentationContext,
  }) async {
    if (_saving || _selectedMealPlanId == null || currentAccount == null) {
      return;
    }
    final modalHost = presentationContext ?? context;
    final result = await showModalBottomSheet<_MealEditorResult>(
      context: modalHost,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      isDismissible: false,
      showDragHandle: false,
      builder: (context) => _MealEntryEditor(
        entry: entry,
        initialDate: initialDate,
        initialSlot: initialSlot,
        recipes: recipes,
      ),
    );
    if (result == null || !mounted || !modalHost.mounted) return;

    if (result.deleteEntry) {
      if (entry != null) {
        await _confirmAndDelete(
          entry,
          recipes,
          presentationContext: modalHost,
        );
      }
      return;
    }

    final draft = result.draft;
    if (draft == null) return;
    final sameCell = entry != null &&
        _sameDate(entry.plannedDate, draft.plannedDate) &&
        entry.mealSlot == draft.mealSlot;
    final sortOrder = sameCell
        ? entry.sortOrder
        : entries
            .where((candidate) =>
                candidate.id != entry?.id &&
                _sameDate(candidate.plannedDate, draft.plannedDate) &&
                candidate.mealSlot == draft.mealSlot)
            .length;

    await _runAction(() async {
      if (entry == null) {
        await DriftToSupabase.createMealPlanEntry(
          accountId: currentAccount!,
          mealPlanId: _selectedMealPlanId!,
          plannedDate: draft.plannedDate,
          mealSlot: draft.mealSlot,
          recipeId: draft.recipeId,
          customTitle: draft.customTitle,
          note: draft.note,
          servings: draft.servings,
          sortOrder: sortOrder,
        );
      } else {
        await DriftToSupabase.updateMealPlanEntry(
          accountId: currentAccount!,
          mealPlanId: _selectedMealPlanId!,
          entryId: entry.id,
          plannedDate: draft.plannedDate,
          mealSlot: draft.mealSlot,
          recipeId: draft.recipeId,
          customTitle: draft.customTitle,
          note: draft.note,
          servings: draft.servings,
          sortOrder: sortOrder,
        );
      }
    });
  }

  Future<void> _confirmAndDelete(MealPlanEntry entry, List<Recipe> recipes,
      {BuildContext? presentationContext}) async {
    final dialogHost = presentationContext ?? context;
    final l = Languages.of(dialogHost)!;
    final title = _entryTitle(entry, recipes, l);
    final confirmed = await showDialog<bool>(
      context: dialogHost,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteMeal),
        content: Text(l.confirmDeleteMeal(title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogHost).colorScheme.error,
              foregroundColor: Theme.of(dialogHost).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _runAction(
      () => DriftToSupabase.deleteMealPlanEntry(
        accountId: currentAccount!,
        mealPlanId: _selectedMealPlanId!,
        entryId: entry.id,
      ),
    );
  }

  Future<void> _runAction(Future<void> Function() action) async {
    final l = Languages.of(context)!;
    setState(() => _saving = true);
    try {
      await action();
    } catch (error) {
      logger.e('Meal plan operation failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotSaveMeal)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _openRecipe(Recipe recipe, {BuildContext? navigationContext}) {
    Navigator.of(navigationContext ?? context).push(
      appPageRoute(
        builder: (context) => RecipeView(
          recipe: recipe,
          open: false,
          additionalData: null,
        ),
        fullScreenSwipeBack: true,
      ),
    );
  }

  Future<void> _openFullWeek({
    required MealPlan plan,
    required bool canModify,
  }) async {
    final canControlOrientation = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (canControlOrientation) {
      await SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    if (!mounted) {
      if (canControlOrientation) {
        await _restoreAppOrientations();
      }
      return;
    }

    try {
      await Navigator.of(context, rootNavigator: true).push(
        appPageRoute<void>(
          fullscreenDialog: true,
          builder: (fullScreenContext) => _FullscreenWeekPlanner(
            title: plan.name,
            weekStart: _weekStart,
            focusDate: _selectedDay,
            entriesStream: _watchCurrentWeek(plan.id),
            recipesStream: _recipesStream,
            canModify: canModify,
            onAdd: (date, slot, entries, recipes) => _openMealEditor(
              initialDate: date,
              initialSlot: slot,
              recipes: recipes,
              entries: entries,
              presentationContext: fullScreenContext,
            ),
            onEntryTap: (entry, entries, recipes) {
              if (canModify) {
                return _openMealEditor(
                  initialDate: entry.plannedDate,
                  initialSlot: entry.mealSlot,
                  recipes: recipes,
                  entries: entries,
                  entry: entry,
                  presentationContext: fullScreenContext,
                );
              }
              final recipe = recipes
                  .where((candidate) => candidate.id == entry.recipeId)
                  .firstOrNull;
              if (recipe != null) {
                _openRecipe(recipe, navigationContext: fullScreenContext);
              }
              return Future.value();
            },
            onRecipeTap: (entry, recipes) {
              final recipe = recipes
                  .where((candidate) => candidate.id == entry.recipeId)
                  .firstOrNull;
              if (recipe != null) {
                _openRecipe(recipe, navigationContext: fullScreenContext);
              }
            },
          ),
        ),
      );
    } finally {
      if (canControlOrientation) {
        await _restoreAppOrientations();
      }
    }
  }

  Future<void> _restoreAppOrientations() =>
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

  Future<void> _createPlan() async {
    final accountId = currentAccount;
    if (accountId == null) return;
    final name = await _showPlanNameDialog();
    if (name == null || !mounted) return;
    await _runAction(() async {
      final plan = await DriftToSupabase.createMealPlan(
        accountId: accountId,
        name: name,
      );
      if (mounted) setState(() => _selectedMealPlanId = plan.id);
    });
  }

  Future<String?> _showPlanNameDialog({MealPlan? plan}) async {
    final l = Languages.of(context)!;
    var draftName = plan?.name ?? '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final valid = draftName.trim().isNotEmpty;
          return AlertDialog(
            title: Text(plan == null ? l.createMealPlan : l.renameMealPlan),
            content: TextFormField(
              initialValue: draftName,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.mealPlanName,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setDialogState(() => draftName = value),
              onFieldSubmitted: valid
                  ? (_) => Navigator.of(dialogContext).pop(draftName.trim())
                  : null,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: valid
                    ? () => Navigator.of(dialogContext).pop(draftName.trim())
                    : null,
                child: Text(l.save),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _renamePlan(MealPlan plan) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    final name = await _showPlanNameDialog(plan: plan);
    if (name == null || name == plan.name || !mounted) return;
    await _runAction(
      () => DriftToSupabase.renameMealPlan(
        accountId: accountId,
        mealPlanId: plan.id,
        name: name,
      ),
    );
  }

  Future<void> _deletePlan(MealPlan plan) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteMealPlan),
        content: Text(l.confirmDeleteMealPlan(plan.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _runAction(() async {
      await DriftToSupabase.deleteMealPlan(
        accountId: accountId,
        mealPlanId: plan.id,
      );
      if (mounted) setState(() => _selectedMealPlanId = null);
    });
  }

  Future<void> _sharePlan(MealPlan plan) async {
    final accountId = currentAccount;
    if (accountId == null || plan.accountId != accountId) return;
    await SupabaseToDrift.waitForActiveSync();
    final database = Singleton().getDatabase();
    final members = await database.watchMealPlanMembers(plan.id).first;
    final accounts = await database.getAcceptedFriendAccounts(accountId);
    if (!mounted) return;
    await showSharedAccessDialog(
      context: context,
      resourceName: plan.name,
      ownerAccountId: accountId,
      accounts: accounts,
      initialMembers: members
          .map((member) => SharedAccessMember(
                accountId: member.accountId,
                permission: member.permission,
                status: member.status,
              ))
          .toList(),
      onSetMember: (memberAccountId, permission) =>
          DriftToSupabase.setMealPlanMember(
        ownerAccountId: accountId,
        mealPlanId: plan.id,
        memberAccountId: memberAccountId,
        permission: permission,
      ),
      onRemoveMember: (memberAccountId) async {
        final currentMembers =
            await database.watchMealPlanMembers(plan.id).first;
        final member = currentMembers
            .where((item) => item.accountId == memberAccountId)
            .firstOrNull;
        if (member != null) {
          await DriftToSupabase.removeMealPlanMember(
            ownerAccountId: accountId,
            member: member,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return Center(child: Text(l.accountNotAvailable));
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerLow,
      child: StreamBuilder<List<MealPlan>>(
        stream: _plansStream,
        builder: (context, planSnapshot) {
          final plans = planSnapshot.data ?? const <MealPlan>[];
          if (planSnapshot.connectionState == ConnectionState.waiting &&
              !planSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (plans.isEmpty) {
            return StreamBuilder<bool>(
              stream: RecipePermissions.watchCanModifyContent(),
              builder: (context, snapshot) => ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _invitationPanel(),
                  const SizedBox(height: 20),
                  Center(
                    child: FilledButton.icon(
                      onPressed: snapshot.data == true ? _createPlan : null,
                      icon: const Icon(Icons.add),
                      label: Text(l.createMealPlan),
                    ),
                  ),
                ],
              ),
            );
          }
          final selected = plans
                  .where((plan) => plan.id == _selectedMealPlanId)
                  .firstOrNull ??
              plans.first;
          _selectedMealPlanId = selected.id;
          return StreamBuilder<bool>(
            stream: RecipePermissions.watchCanModifyContent(),
            builder: (context, contentPermissionSnapshot) =>
                StreamBuilder<bool>(
              stream: Singleton()
                  .getDatabase()
                  .watchCanEditMealPlan(accountId, selected.id),
              builder: (context, planPermissionSnapshot) {
                final canCreateContent = contentPermissionSnapshot.data == true;
                final canEditPlan =
                    canCreateContent && planPermissionSnapshot.data == true;
                final ownsPlan = selected.accountId == accountId;
                return StreamBuilder<List<Recipe>>(
                  stream: _recipesStream,
                  builder: (context, recipeSnapshot) =>
                      StreamBuilder<List<MealPlanEntry>>(
                    stream: _watchCurrentWeek(selected.id),
                    builder: (context, entrySnapshot) {
                      if ((recipeSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              entrySnapshot.connectionState ==
                                  ConnectionState.waiting) &&
                          !entrySnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final recipes = recipeSnapshot.data ?? const <Recipe>[];
                      final entries =
                          entrySnapshot.data ?? const <MealPlanEntry>[];
                      return LayoutBuilder(
                        builder: (context, constraints) => ListView(
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
                          children: [
                            Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 1240),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _invitationPanel(),
                                    _buildHeading(
                                      l,
                                      plans: plans,
                                      selected: selected,
                                      canCreate: canCreateContent,
                                      canRename: canEditPlan,
                                      canManageAccess:
                                          ownsPlan && canCreateContent,
                                      canSaveTemplate:
                                          canCreateContent && !_saving,
                                      entries: entries,
                                    ),
                                    const SizedBox(height: 10),
                                    SharedWithSummary(
                                      resourceType: SharedResourceType.mealPlan,
                                      resourceId: selected.id,
                                      ownerAccountId: selected.accountId,
                                      currentAccountId: accountId,
                                    ),
                                    const SizedBox(height: 14),
                                    _buildWeekControls(
                                      l,
                                      canManageWeek: ownsPlan &&
                                          canCreateContent &&
                                          !_saving,
                                      onOpenFullWeek: () => _openFullWeek(
                                        plan: selected,
                                        canModify: canEditPlan && !_saving,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (constraints.maxWidth >= 760)
                                      _WeeklyCalendar(
                                        weekStart: _weekStart,
                                        entries: entries,
                                        recipes: recipes,
                                        canModify: canEditPlan && !_saving,
                                        wideLayout: true,
                                        dayScrollController:
                                            _dayScrollController,
                                        positionCurrentWeek:
                                            _positionMobileCalendar,
                                        onAdd: (date, slot) => _openMealEditor(
                                          initialDate: date,
                                          initialSlot: slot,
                                          recipes: recipes,
                                          entries: entries,
                                        ),
                                        onEntryTap: (entry) {
                                          if (canEditPlan) {
                                            _openMealEditor(
                                              initialDate: entry.plannedDate,
                                              initialSlot: entry.mealSlot,
                                              recipes: recipes,
                                              entries: entries,
                                              entry: entry,
                                            );
                                            return;
                                          }
                                          final recipe = recipes
                                              .where((recipe) =>
                                                  recipe.id == entry.recipeId)
                                              .firstOrNull;
                                          if (recipe != null) {
                                            _openRecipe(recipe);
                                          }
                                        },
                                        onRecipeTap: (entry) {
                                          final recipe = recipes
                                              .where((recipe) =>
                                                  recipe.id == entry.recipeId)
                                              .firstOrNull;
                                          if (recipe != null) {
                                            _openRecipe(recipe);
                                          }
                                        },
                                      )
                                    else
                                      _CompactWeekPlanner(
                                        weekStart: _weekStart,
                                        selectedDate: _selectedDay,
                                        entries: entries,
                                        recipes: recipes,
                                        canModify: canEditPlan && !_saving,
                                        onDateSelected: _selectDay,
                                        onAdd: (date, slot) => _openMealEditor(
                                          initialDate: date,
                                          initialSlot: slot,
                                          recipes: recipes,
                                          entries: entries,
                                        ),
                                        onEntryTap: (entry) {
                                          if (canEditPlan) {
                                            _openMealEditor(
                                              initialDate: entry.plannedDate,
                                              initialSlot: entry.mealSlot,
                                              recipes: recipes,
                                              entries: entries,
                                              entry: entry,
                                            );
                                            return;
                                          }
                                          final recipe = recipes
                                              .where((recipe) =>
                                                  recipe.id == entry.recipeId)
                                              .firstOrNull;
                                          if (recipe != null) {
                                            _openRecipe(recipe);
                                          }
                                        },
                                        onRecipeTap: (entry) {
                                          final recipe = recipes
                                              .where((recipe) =>
                                                  recipe.id == entry.recipeId)
                                              .firstOrNull;
                                          if (recipe != null) {
                                            _openRecipe(recipe);
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeading(
    Languages l, {
    required List<MealPlan> plans,
    required MealPlan selected,
    required bool canCreate,
    required bool canRename,
    required bool canManageAccess,
    required bool canSaveTemplate,
    required List<MealPlanEntry> entries,
  }) {
    final theme = Theme.of(context);
    final selector = DropdownButtonFormField<int>(
      value: selected.id,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l.mealPlan,
        prefixIcon: const Icon(Icons.calendar_view_week_outlined),
        border: const OutlineInputBorder(),
      ),
      items: plans
          .map((plan) => DropdownMenuItem(
                value: plan.id,
                child: Text(plan.name, overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: (id) {
        if (id != null) setState(() => _selectedMealPlanId = id);
      },
    );
    final actions = <Widget>[
      IconButton(
        tooltip: l.renameMealPlan,
        onPressed: canRename && !_saving ? () => _renamePlan(selected) : null,
        icon: const Icon(Icons.edit_outlined),
      ),
      IconButton(
        tooltip: l.deleteMealPlan,
        style: IconButton.styleFrom(foregroundColor: theme.colorScheme.error),
        onPressed:
            canManageAccess && !_saving ? () => _deletePlan(selected) : null,
        icon: const Icon(Icons.delete_outline),
      ),
      Tooltip(
        message:
            entries.isEmpty ? l.emptyWeekCannotBeSaved : l.saveWeekAsTemplate,
        child: IconButton(
          onPressed:
              canSaveTemplate && entries.isNotEmpty ? _saveTemplate : null,
          icon: const Icon(Icons.bookmark_add_outlined),
        ),
      ),
      IconButton(
        tooltip: l.manageAccess,
        onPressed:
            canManageAccess && !_saving ? () => _sharePlan(selected) : null,
        icon: const Icon(Icons.group_add_outlined),
      ),
    ];
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.mealPlan,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: l.createMealPlan,
              onPressed: canCreate && !_saving ? _createPlan : null,
              icon: const Icon(Icons.add),
            ),
            IconButton(
              tooltip: l.mealPlanTemplates,
              onPressed: canCreate && !_saving
                  ? () => _openTemplates(allowApply: false)
                  : null,
              icon: const Icon(Icons.bookmarks_outlined),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 560) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  selector,
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions,
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: selector),
                const SizedBox(width: 4),
                ...actions,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeekControls(
    Languages l, {
    required bool canManageWeek,
    required VoidCallback onOpenFullWeek,
  }) {
    final locale = l.languageCode;
    final end = _weekEnd.subtract(const Duration(days: 1));
    final range = _weekStart.year == end.year
        ? '${DateFormat.MMMd(locale).format(_weekStart)} – '
            '${DateFormat.MMMd(locale).format(end)}, ${end.year}'
        : '${DateFormat.yMMMd(locale).format(_weekStart)} – '
            '${DateFormat.yMMMd(locale).format(end)}';
    final navigation = Row(
      children: [
        IconButton(
          tooltip: l.previousWeek,
          visualDensity: VisualDensity.compact,
          onPressed: () => _setWeek(
            _weekStart.subtract(const Duration(days: 7)),
          ),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: _pickWeek,
            icon: const Icon(Icons.date_range_outlined),
            label: Text(
              range,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        IconButton(
          tooltip: l.nextWeek,
          visualDensity: VisualDensity.compact,
          onPressed: () => _setWeek(
            _weekStart.add(const Duration(days: 7)),
          ),
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton(
          tooltip: l.today,
          visualDensity: VisualDensity.compact,
          onPressed: () => _setWeek(DateTime.now(), selectDate: true),
          icon: const Icon(Icons.today_outlined),
        ),
        IconButton(
          tooltip: l.openFullWeek,
          visualDensity: VisualDensity.compact,
          onPressed: onOpenFullWeek,
          icon: const Icon(Icons.fullscreen_outlined),
        ),
      ],
    );
    final applyButton = FilledButton.tonalIcon(
      onPressed: canManageWeek ? () => _openTemplates(allowApply: true) : null,
      icon: const Icon(Icons.playlist_add_outlined),
      label: Text(l.applyMeals),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 620) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  navigation,
                  if (canManageWeek)
                    Align(alignment: Alignment.centerRight, child: applyButton),
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: navigation),
                if (canManageWeek) ...[
                  const SizedBox(width: 10),
                  applyButton,
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _copyPreviousWeek({required bool replace}) async {
    final l = Languages.of(context)!;
    await _runAction(() async {
      await SupabaseToDrift.waitForActiveSync();
      await DriftToSupabase.copyMealPlanWeek(
        accountId: currentAccount!,
        mealPlanId: _selectedMealPlanId!,
        sourceWeekStart: _weekStart.subtract(const Duration(days: 7)),
        targetWeekStart: _weekStart,
        replace: replace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.weekCopied)));
      }
    });
  }

  Future<void> _saveTemplate() async {
    final l = Languages.of(context)!;
    var draftName = '';
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final valid = draftName.trim().isNotEmpty;
          return AlertDialog(
            title: Text(l.saveWeekAsTemplate),
            content: TextFormField(
              initialValue: draftName,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.templateName,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setDialogState(() => draftName = value),
              onFieldSubmitted: valid
                  ? (_) => Navigator.of(dialogContext).pop(draftName.trim())
                  : null,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: valid
                    ? () => Navigator.of(dialogContext).pop(draftName.trim())
                    : null,
                child: Text(l.save),
              ),
            ],
          );
        },
      ),
    );
    if (name == null || !mounted) return;
    await _runAction(() async {
      await SupabaseToDrift.waitForActiveSync();
      final freshEntries =
          await Singleton().getDatabase().getMealPlanEntriesForWeek(
                _selectedMealPlanId!,
                _weekStart,
                _weekStart.add(const Duration(days: 7)),
              );
      await DriftToSupabase.saveMealPlanTemplate(
        accountId: currentAccount!,
        name: name,
        weekStart: _weekStart,
        entries: freshEntries,
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.templateSaved)));
      }
    });
  }

  Future<String?> _showTemplateNameDialog(MealPlanTemplate template) {
    final l = Languages.of(context)!;
    var draftName = template.name;
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final valid = draftName.trim().isNotEmpty;
          return AlertDialog(
            title: Text(l.renameTemplate),
            content: TextFormField(
              initialValue: draftName,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.templateName,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setDialogState(() => draftName = value),
              onFieldSubmitted: valid
                  ? (_) => Navigator.of(dialogContext).pop(draftName.trim())
                  : null,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: valid
                    ? () => Navigator.of(dialogContext).pop(draftName.trim())
                    : null,
                child: Text(l.save),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _confirmDeleteTemplate(MealPlanTemplate template) async {
    final l = Languages.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l.deleteTemplate),
            content: Text(l.confirmDeleteTemplate(template.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l.delete),
              ),
            ],
          ),
        ) ==
        true;
  }

  Future<void> _showTemplatePreview(
    _MealPlanTemplateSummary summary,
    List<Recipe> recipes,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final l = Languages.of(sheetContext)!;
        final baseMonday = DateTime(2024, 1, 1);
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(sheetContext).height * .82,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              summary.template.name,
                              style: Theme.of(sheetContext)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(l.mealCount(summary.entries.length)),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l.close,
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: summary.entries.isEmpty
                      ? Center(child: Text(l.noMealsToApply))
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                          children: [
                            for (var day = 0; day < 7; day++) ...[
                              if (summary.entries
                                  .any((entry) => entry.dayOffset == day)) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 12, 4, 4),
                                  child: Text(
                                    DateFormat.EEEE(l.languageCode).format(
                                      baseMonday.add(Duration(days: day)),
                                    ),
                                    style: Theme.of(sheetContext)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                for (final entry in summary.entries.where(
                                  (entry) => entry.dayOffset == day,
                                ))
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    leading:
                                        const Icon(Icons.restaurant_outlined),
                                    title: Text(_templateEntryTitle(
                                      entry,
                                      recipes,
                                      l,
                                    )),
                                    subtitle:
                                        Text(_slotLabel(l, entry.mealSlot)),
                                  ),
                              ],
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openTemplates({required bool allowApply}) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    await SupabaseToDrift.waitForActiveSync();
    final database = Singleton().getDatabase();
    final templates = await database.getMealPlanTemplates(accountId);
    final summaries = <_MealPlanTemplateSummary>[];
    for (final template in templates) {
      summaries.add(_MealPlanTemplateSummary(
        template: template,
        entries: await database.getMealPlanTemplateEntries(template.id),
      ));
    }
    final recipes = await Singleton().getDatabase().getSelectableRecipes();
    final previousEntries = allowApply && _selectedMealPlanId != null
        ? await database.getMealPlanEntriesForWeek(
            _selectedMealPlanId!,
            _weekStart.subtract(const Duration(days: 7)),
            _weekStart,
          )
        : const <MealPlanEntry>[];
    if (!mounted) return;
    final selection = await showModalBottomSheet<_MealPlanApplyChoice>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final l = Languages.of(sheetContext)!;
          String preview(Iterable<String> titles) {
            final values = titles.where((title) => title.isNotEmpty).take(3);
            return values.isEmpty ? l.noMealsToApply : values.join(' · ');
          }

          Widget applyActions(_MealPlanApplyChoice source, bool enabled) {
            return Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: enabled
                      ? () => Navigator.of(sheetContext).pop(
                            source.copyWith(replace: false),
                          )
                      : null,
                  child: Text(l.addToCurrentWeek),
                ),
                FilledButton.tonal(
                  onPressed: enabled
                      ? () => Navigator.of(sheetContext).pop(
                            source.copyWith(replace: true),
                          )
                      : null,
                  child: Text(l.replaceCurrentWeek),
                ),
              ],
            );
          }

          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(sheetContext).height * .86,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            allowApply ? l.applyMeals : l.mealPlanTemplates,
                            style: Theme.of(sheetContext)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          tooltip: l.close,
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                      children: [
                        if (allowApply) ...[
                          _TemplateSectionHeading(title: l.previousWeek),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            leading: const Icon(Icons.history_outlined),
                            title: Text(l.copyPreviousWeek),
                            subtitle: Text(
                              '${l.mealCount(previousEntries.length)}\n'
                              '${preview(previousEntries.map(
                                (entry) => _entryTitle(entry, recipes, l),
                              ))}',
                            ),
                            isThreeLine: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: applyActions(
                              const _MealPlanApplyChoice.previousWeek(),
                              previousEntries.isNotEmpty,
                            ),
                          ),
                          const Divider(height: 28),
                        ],
                        _TemplateSectionHeading(title: l.savedTemplates),
                        if (summaries.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 36),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.bookmarks_outlined,
                                  size: 36,
                                  color: Theme.of(sheetContext)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l.noMealPlanTemplates,
                                  style: Theme.of(sheetContext)
                                      .textTheme
                                      .titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l.noMealPlanTemplatesDescription,
                                  style: Theme.of(sheetContext)
                                      .textTheme
                                      .bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else
                          for (final summary in summaries) ...[
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              leading: const Icon(
                                Icons.calendar_view_week_outlined,
                              ),
                              title: Text(
                                summary.template.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${l.mealCount(summary.entries.length)} · '
                                '${l.createdAt} '
                                '${DateFormat.yMMMd(l.languageCode).format(summary.template.createdAt.toLocal())}\n'
                                '${preview(summary.entries.map(
                                  (entry) => _templateEntryTitle(
                                    entry,
                                    recipes,
                                    l,
                                  ),
                                ))}',
                              ),
                              isThreeLine: true,
                              onTap: () =>
                                  _showTemplatePreview(summary, recipes),
                            ),
                            if (allowApply)
                              Align(
                                alignment: Alignment.centerRight,
                                child: applyActions(
                                  _MealPlanApplyChoice.template(
                                      summary.template),
                                  summary.entries.isNotEmpty,
                                ),
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    tooltip: l.previewTemplate,
                                    onPressed: () =>
                                        _showTemplatePreview(summary, recipes),
                                    icon: const Icon(Icons.visibility_outlined),
                                  ),
                                  IconButton(
                                    tooltip: l.renameTemplate,
                                    onPressed: () async {
                                      final name =
                                          await _showTemplateNameDialog(
                                        summary.template,
                                      );
                                      if (name == null ||
                                          name == summary.template.name) {
                                        return;
                                      }
                                      MealPlanTemplate? renamed;
                                      await _runAction(() async {
                                        renamed = await DriftToSupabase
                                            .renameMealPlanTemplate(
                                          accountId: accountId,
                                          templateId: summary.template.id,
                                          name: name,
                                        );
                                      });
                                      if (renamed != null &&
                                          sheetContext.mounted) {
                                        setSheetState(() {
                                          final index =
                                              summaries.indexOf(summary);
                                          summaries[index] = summary.copyWith(
                                            template: renamed!,
                                          );
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: l.deleteTemplate,
                                    style: IconButton.styleFrom(
                                      foregroundColor: Theme.of(sheetContext)
                                          .colorScheme
                                          .error,
                                    ),
                                    onPressed: () async {
                                      if (!await _confirmDeleteTemplate(
                                        summary.template,
                                      )) {
                                        return;
                                      }
                                      var deleted = false;
                                      await _runAction(() async {
                                        await DriftToSupabase
                                            .deleteMealPlanTemplate(
                                          accountId: accountId,
                                          templateId: summary.template.id,
                                        );
                                        deleted = true;
                                      });
                                      if (deleted && sheetContext.mounted) {
                                        setSheetState(
                                          () => summaries.remove(summary),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            const Divider(height: 20),
                          ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (!allowApply || selection == null || !mounted) return;
    if (selection.previousWeek) {
      await _copyPreviousWeek(replace: selection.replace);
      return;
    }
    final template = selection.template;
    if (template == null) return;
    final l = Languages.of(context)!;
    await _runAction(() async {
      await DriftToSupabase.applyMealPlanTemplate(
        accountId: accountId,
        mealPlanId: _selectedMealPlanId!,
        templateId: template.id,
        targetWeekStart: _weekStart,
        replace: selection.replace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.templateApplied)));
      }
    });
  }

  void _positionMobileCalendar(double dayWidth) {
    if (_positionedCurrentWeek) return;
    _positionedCurrentWeek = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_dayScrollController.hasClients) return;
      final today = DateTime.now();
      final isCurrentWeek = !today.isBefore(_weekStart) &&
          today.isBefore(_weekStart.add(const Duration(days: 7)));
      final target = isCurrentWeek ? (today.weekday - 1) * dayWidth : 0.0;
      _dayScrollController.jumpTo(
        target.clamp(0.0, _dayScrollController.position.maxScrollExtent),
      );
    });
  }
}

class _CompactWeekPlanner extends StatelessWidget {
  const _CompactWeekPlanner({
    required this.weekStart,
    required this.selectedDate,
    required this.entries,
    required this.recipes,
    required this.canModify,
    required this.onDateSelected,
    required this.onAdd,
    required this.onEntryTap,
    required this.onRecipeTap,
  });

  final DateTime weekStart;
  final DateTime selectedDate;
  final List<MealPlanEntry> entries;
  final List<Recipe> recipes;
  final bool canModify;
  final ValueChanged<DateTime> onDateSelected;
  final void Function(DateTime, String) onAdd;
  final ValueChanged<MealPlanEntry> onEntryTap;
  final ValueChanged<MealPlanEntry> onRecipeTap;

  void _moveDay(int offset) {
    onDateSelected(selectedDate.add(Duration(days: offset)));
  }

  List<MealPlanEntry> _entriesFor(String slot) {
    final result = entries
        .where((entry) =>
            _sameDate(entry.plannedDate, selectedDate) &&
            entry.mealSlot == slot)
        .toList();
    _sortMealEntries(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final days = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(5, 7, 5, 8),
            color: colors.surfaceContainerLow,
            child: Row(
              children: [
                for (final day in days)
                  Expanded(
                    child: _DaySelector(
                      date: day,
                      selected: _sameDate(day, selectedDate),
                      hasMeals: entries.any(
                        (entry) => _sameDate(entry.plannedDate, day),
                      ),
                      onTap: () => onDateSelected(day),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity < -250) _moveDay(1);
              if (velocity > 250) _moveDay(-1);
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Column(
                key: ValueKey(_dateOnly(selectedDate)),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                    child: Text(
                      DateFormat.yMMMMEEEEd(l.languageCode)
                          .format(selectedDate),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  for (var index = 0; index < _mealSlots.length; index++)
                    _CompactMealSection(
                      date: selectedDate,
                      slot: _mealSlots[index],
                      entries: _entriesFor(_mealSlots[index]),
                      recipes: recipes,
                      canModify: canModify,
                      showDivider: index != _mealSlots.length - 1,
                      onAdd: () => onAdd(selectedDate, _mealSlots[index]),
                      onEntryTap: onEntryTap,
                      onRecipeTap: onRecipeTap,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector({
    required this.date,
    required this.selected,
    required this.hasMeals,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool hasMeals;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isToday = _sameDate(date, DateTime.now());
    final fullDate = DateFormat.yMMMMEEEEd(l.languageCode).format(date);
    return Semantics(
      button: true,
      selected: selected,
      label: fullDate,
      child: Tooltip(
        message: fullDate,
        child: Material(
          color: selected ? colors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 58,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        DateFormat.E(l.languageCode).format(date),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: selected
                                  ? colors.onPrimaryContainer
                                  : colors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    height: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${date.day}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: selected
                                  ? colors.onPrimaryContainer
                                  : colors.onSurface,
                              fontWeight:
                                  isToday || selected ? FontWeight.w800 : null,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                    child: hasMeals
                        ? Center(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: selected
                                    ? colors.onPrimaryContainer
                                    : colors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactMealSection extends StatelessWidget {
  const _CompactMealSection({
    required this.date,
    required this.slot,
    required this.entries,
    required this.recipes,
    required this.canModify,
    required this.showDivider,
    required this.onAdd,
    required this.onEntryTap,
    required this.onRecipeTap,
  });

  final DateTime date;
  final String slot;
  final List<MealPlanEntry> entries;
  final List<Recipe> recipes;
  final bool canModify;
  final bool showDivider;
  final VoidCallback onAdd;
  final ValueChanged<MealPlanEntry> onEntryTap;
  final ValueChanged<MealPlanEntry> onRecipeTap;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _slotLabel(l, slot),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (canModify)
                IconButton(
                  tooltip: l.addMeal,
                  visualDensity: VisualDensity.compact,
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 20),
                ),
            ],
          ),
          if (entries.isEmpty)
            Padding(
              padding: EdgeInsets.only(
                bottom: 12,
                right: canModify ? 0 : 8,
              ),
              child: Text(
                l.noMealsPlanned,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            )
          else
            for (var index = 0; index < entries.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _MealCard(
                  entry: entries[index],
                  date: date,
                  slot: slot,
                  colorVariant: index,
                  recipes: recipes,
                  canModify: canModify,
                  onTap: () => onEntryTap(entries[index]),
                  onOpenRecipe: entries[index].recipeId == null
                      ? null
                      : () => onRecipeTap(entries[index]),
                ),
              ),
          if (showDivider) const Divider(height: 1),
        ],
      ),
    );
  }
}

class _FullscreenWeekPlanner extends StatefulWidget {
  const _FullscreenWeekPlanner({
    required this.title,
    required this.weekStart,
    required this.focusDate,
    required this.entriesStream,
    required this.recipesStream,
    required this.canModify,
    required this.onAdd,
    required this.onEntryTap,
    required this.onRecipeTap,
  });

  final String title;
  final DateTime weekStart;
  final DateTime focusDate;
  final Stream<List<MealPlanEntry>> entriesStream;
  final Stream<List<Recipe>> recipesStream;
  final bool canModify;
  final Future<void> Function(
    DateTime date,
    String slot,
    List<MealPlanEntry> entries,
    List<Recipe> recipes,
  ) onAdd;
  final Future<void> Function(
    MealPlanEntry entry,
    List<MealPlanEntry> entries,
    List<Recipe> recipes,
  ) onEntryTap;
  final void Function(MealPlanEntry entry, List<Recipe> recipes) onRecipeTap;

  @override
  State<_FullscreenWeekPlanner> createState() => _FullscreenWeekPlannerState();
}

class _FullscreenWeekPlannerState extends State<_FullscreenWeekPlanner> {
  final ScrollController _dayScrollController = ScrollController();
  bool _positioned = false;

  @override
  void dispose() {
    _dayScrollController.dispose();
    super.dispose();
  }

  void _positionCalendar(double dayWidth) {
    if (_positioned) return;
    _positioned = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_dayScrollController.hasClients) return;
      final dayIndex = widget.focusDate.difference(widget.weekStart).inDays;
      final target = dayIndex.clamp(0, 6).toDouble() * dayWidth;
      _dayScrollController.jumpTo(
        target.clamp(0.0, _dayScrollController.position.maxScrollExtent),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final weekEnd = widget.weekStart.add(const Duration(days: 6));
    final range = '${DateFormat.MMMd(l.languageCode).format(widget.weekStart)} '
        '- ${DateFormat.yMMMd(l.languageCode).format(weekEnd)}';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        leading: IconButton(
          tooltip: l.close,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, overflow: TextOverflow.ellipsis),
            Text(
              range,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        left: true,
        right: true,
        bottom: true,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: StreamBuilder<List<Recipe>>(
            stream: widget.recipesStream,
            builder: (context, recipeSnapshot) =>
                StreamBuilder<List<MealPlanEntry>>(
              stream: widget.entriesStream,
              builder: (context, entrySnapshot) {
                if ((!recipeSnapshot.hasData || !entrySnapshot.hasData) &&
                    (recipeSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        entrySnapshot.connectionState ==
                            ConnectionState.waiting)) {
                  return const Center(child: CircularProgressIndicator());
                }
                final recipes = recipeSnapshot.data ?? const <Recipe>[];
                final entries = entrySnapshot.data ?? const <MealPlanEntry>[];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    const calendarPadding = 6.0;
                    return Padding(
                      padding: const EdgeInsets.all(calendarPadding),
                      child: _WeeklyCalendar(
                        weekStart: widget.weekStart,
                        entries: entries,
                        recipes: recipes,
                        canModify: widget.canModify,
                        wideLayout: true,
                        compactHeight: math.max(
                            0, constraints.maxHeight - calendarPadding * 2),
                        dayScrollController: _dayScrollController,
                        positionCurrentWeek: _positionCalendar,
                        onAdd: (date, slot) =>
                            widget.onAdd(date, slot, entries, recipes),
                        onEntryTap: (entry) =>
                            widget.onEntryTap(entry, entries, recipes),
                        onRecipeTap: (entry) =>
                            widget.onRecipeTap(entry, recipes),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyCalendar extends StatelessWidget {
  const _WeeklyCalendar({
    required this.weekStart,
    required this.entries,
    required this.recipes,
    required this.canModify,
    required this.wideLayout,
    required this.dayScrollController,
    required this.positionCurrentWeek,
    required this.onAdd,
    required this.onEntryTap,
    required this.onRecipeTap,
    this.compactHeight,
  });

  final DateTime weekStart;
  final List<MealPlanEntry> entries;
  final List<Recipe> recipes;
  final bool canModify;
  final bool wideLayout;
  final ScrollController dayScrollController;
  final ValueChanged<double> positionCurrentWeek;
  final void Function(DateTime, String) onAdd;
  final ValueChanged<MealPlanEntry> onEntryTap;
  final ValueChanged<MealPlanEntry> onRecipeTap;
  final double? compactHeight;

  static const double _mobileDayWidth = 154;
  static const double _mobileSlotWidth = 78;
  static const double _wideSlotWidth = 108;
  static const double _headerHeight = 64;
  static const double _minimumMealRowHeight = 106;
  static const double _mealCellControlsHeight = 42;

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );
    final isCompact = compactHeight != null;
    final headerHeight =
        isCompact ? (compactHeight! * 0.16).clamp(36.0, 46.0) : _headerHeight;
    final compactRowHeight = isCompact
        ? math.max(0.0, (compactHeight! - headerHeight) / _mealSlots.length)
        : null;
    final rowHeights = {
      for (final slot in _mealSlots)
        slot: compactRowHeight ?? _rowHeight(slot, days),
    };
    final calendar = wideLayout
        ? _wideCalendar(
            context,
            days,
            rowHeights,
            headerHeight: headerHeight,
            compact: isCompact,
          )
        : _mobileCalendar(
            context,
            days,
            rowHeights,
            headerHeight: headerHeight,
          );
    final material = Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: calendar,
    );
    if (!isCompact) return material;
    return SizedBox(height: compactHeight, child: material);
  }

  double _rowHeight(String slot, List<DateTime> days) {
    final largestCellHeight = days.map((date) {
      final entries = _entriesFor(date, slot);
      if (entries.isEmpty) return 0.0;
      return entries.map(_mealCardHeight).reduce((a, b) => a + b) +
          math.max(0, entries.length - 1) * 4;
    }).fold<double>(0, math.max);
    return math
        .max(
          _minimumMealRowHeight,
          _mealCellControlsHeight + largestCellHeight,
        )
        .toDouble();
  }

  Widget _wideCalendar(
    BuildContext context,
    List<DateTime> days,
    Map<String, double> rowHeights, {
    required double headerHeight,
    required bool compact,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: compact ? 66 : _wideSlotWidth,
          child: _SlotRail(
            rowHeights: rowHeights,
            headerHeight: headerHeight,
            compact: compact,
          ),
        ),
        for (final day in days)
          Expanded(
            child: _DayColumn(
              date: day,
              rowHeights: rowHeights,
              entriesFor: _entriesFor,
              recipes: recipes,
              canModify: canModify,
              headerHeight: headerHeight,
              compact: compact,
              onAdd: onAdd,
              onEntryTap: onEntryTap,
              onRecipeTap: onRecipeTap,
            ),
          ),
      ],
    );
  }

  Widget _mobileCalendar(
    BuildContext context,
    List<DateTime> days,
    Map<String, double> rowHeights, {
    required double headerHeight,
  }) {
    positionCurrentWeek(_mobileDayWidth);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _mobileSlotWidth,
          child: _SlotRail(
            rowHeights: rowHeights,
            headerHeight: headerHeight,
            compact: false,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: dayScrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final day in days)
                  SizedBox(
                    width: _mobileDayWidth,
                    child: _DayColumn(
                      date: day,
                      rowHeights: rowHeights,
                      entriesFor: _entriesFor,
                      recipes: recipes,
                      canModify: canModify,
                      headerHeight: headerHeight,
                      compact: false,
                      onAdd: onAdd,
                      onEntryTap: onEntryTap,
                      onRecipeTap: onRecipeTap,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<MealPlanEntry> _entriesFor(DateTime date, String slot) {
    final result = entries
        .where((entry) =>
            _sameDate(entry.plannedDate, date) && entry.mealSlot == slot)
        .toList();
    result.sort((a, b) {
      final orderComparison = a.sortOrder.compareTo(b.sortOrder);
      if (orderComparison != 0) return orderComparison;
      final createdComparison = a.createdAt.compareTo(b.createdAt);
      if (createdComparison != 0) return createdComparison;
      return a.id.compareTo(b.id);
    });
    return result;
  }
}

class _SlotRail extends StatelessWidget {
  const _SlotRail({
    required this.rowHeights,
    required this.headerHeight,
    required this.compact,
  });

  final Map<String, double> rowHeights;
  final double headerHeight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          height: headerHeight,
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            border: Border(
              right: BorderSide(color: colors.outlineVariant),
              bottom: BorderSide(color: colors.outlineVariant),
            ),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.schedule_outlined, size: 21),
        ),
        for (final slot in _mealSlots)
          Container(
            height: rowHeights[slot],
            padding: EdgeInsets.symmetric(horizontal: compact ? 3 : 7),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              border: Border(
                right: BorderSide(color: colors.outlineVariant),
                bottom: BorderSide(color: colors.outlineVariant),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _slotLabel(l, slot),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: (compact
                      ? Theme.of(context).textTheme.labelSmall
                      : Theme.of(context).textTheme.labelMedium)
                  ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.date,
    required this.rowHeights,
    required this.entriesFor,
    required this.recipes,
    required this.canModify,
    required this.headerHeight,
    required this.compact,
    required this.onAdd,
    required this.onEntryTap,
    required this.onRecipeTap,
  });

  final DateTime date;
  final Map<String, double> rowHeights;
  final List<MealPlanEntry> Function(DateTime, String) entriesFor;
  final List<Recipe> recipes;
  final bool canModify;
  final double headerHeight;
  final bool compact;
  final void Function(DateTime, String) onAdd;
  final ValueChanged<MealPlanEntry> onEntryTap;
  final ValueChanged<MealPlanEntry> onRecipeTap;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isToday = _sameDate(date, DateTime.now());
    return Column(
      children: [
        Container(
          height: headerHeight,
          decoration: BoxDecoration(
            color: isToday ? colors.primaryContainer : colors.surfaceContainer,
            border: Border(
              right: BorderSide(color: colors.outlineVariant),
              bottom: BorderSide(color: colors.outlineVariant),
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat.E(l.languageCode).format(date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (compact
                        ? Theme.of(context).textTheme.labelSmall
                        : Theme.of(context).textTheme.labelMedium)
                    ?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                DateFormat.MMMd(l.languageCode).format(date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: compact
                    ? Theme.of(context).textTheme.labelSmall
                    : Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        for (final slot in _mealSlots)
          _MealCell(
            date: date,
            slot: slot,
            height: rowHeights[slot]!,
            entries: entriesFor(date, slot),
            recipes: recipes,
            canModify: canModify,
            compact: compact,
            onAdd: () => onAdd(date, slot),
            onEntryTap: onEntryTap,
            onRecipeTap: onRecipeTap,
          ),
      ],
    );
  }
}

class _MealCell extends StatelessWidget {
  const _MealCell({
    required this.date,
    required this.slot,
    required this.height,
    required this.entries,
    required this.recipes,
    required this.canModify,
    required this.compact,
    required this.onAdd,
    required this.onEntryTap,
    required this.onRecipeTap,
  });

  final DateTime date;
  final String slot;
  final double height;
  final List<MealPlanEntry> entries;
  final List<Recipe> recipes;
  final bool canModify;
  final bool compact;
  final VoidCallback onAdd;
  final ValueChanged<MealPlanEntry> onEntryTap;
  final ValueChanged<MealPlanEntry> onRecipeTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (compact) {
      return Container(
        height: height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: colors.outlineVariant),
            bottom: BorderSide(color: colors.outlineVariant),
          ),
        ),
        child: Stack(
          children: [
            if (entries.isNotEmpty)
              Positioned.fill(
                child: ListView.separated(
                  padding: EdgeInsets.only(right: canModify ? 20 : 0),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemBuilder: (context, index) => _MealCard(
                    entry: entries[index],
                    date: date,
                    slot: slot,
                    colorVariant: index,
                    recipes: recipes,
                    canModify: canModify,
                    compact: true,
                    onTap: () => onEntryTap(entries[index]),
                    onOpenRecipe: entries[index].recipeId == null
                        ? null
                        : () => onRecipeTap(entries[index]),
                  ),
                ),
              ),
            if (canModify)
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox.square(
                  dimension: 22,
                  child: IconButton(
                    tooltip: Languages.of(context)!.addMeal,
                    padding: EdgeInsets.zero,
                    iconSize: 16,
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: colors.outlineVariant),
          bottom: BorderSide(color: colors.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (canModify)
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox.square(
                dimension: 32,
                child: IconButton(
                  tooltip: Languages.of(context)!.addMeal,
                  padding: EdgeInsets.zero,
                  iconSize: 19,
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                ),
              ),
            )
          else
            const SizedBox(height: 6),
          for (var index = 0; index < entries.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == entries.length - 1 ? 0 : 4,
              ),
              child: _MealCard(
                entry: entries[index],
                date: date,
                slot: slot,
                colorVariant: index,
                recipes: recipes,
                canModify: canModify,
                compact: false,
                onTap: () => onEntryTap(entries[index]),
                onOpenRecipe: entries[index].recipeId == null
                    ? null
                    : () => onRecipeTap(entries[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.entry,
    required this.date,
    required this.slot,
    required this.colorVariant,
    required this.recipes,
    required this.canModify,
    this.compact = false,
    required this.onTap,
    required this.onOpenRecipe,
  });

  final MealPlanEntry entry;
  final DateTime date;
  final String slot;
  final int colorVariant;
  final List<Recipe> recipes;
  final bool canModify;
  final bool compact;
  final VoidCallback onTap;
  final VoidCallback? onOpenRecipe;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final availableRecipe = recipes
        .where(
            (recipe) => recipe.id == entry.recipeId && recipe.deletedAt == null)
        .firstOrNull;
    final hasRecipeReference = entry.recipeId != null ||
        entry.recipeTitleSnapshot?.trim().isNotEmpty == true;
    final unavailableRecipe = hasRecipeReference && availableRecipe == null;
    final title = _entryTitle(entry, recipes, l);
    final cardColors = _mealCardColors(
      colors,
      date: date,
      slot: slot,
      variant: colorVariant,
    );
    return Material(
      color: cardColors.background,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canModify || availableRecipe != null ? onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 4 : 7,
            vertical: compact ? 3 : 7,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: compact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cardColors.foreground,
                          ),
                    ),
                    if (unavailableRecipe && !compact) ...[
                      const SizedBox(height: 2),
                      Text(
                        l.recipeUnavailable,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: cardColors.foreground.withAlpha(220),
                            ),
                      ),
                    ],
                    if (compact &&
                        (entry.servings != null ||
                            entry.note?.trim().isNotEmpty == true)) ...[
                      const SizedBox(height: 1),
                      Text(
                        [
                          if (entry.servings != null)
                            '${entry.servings} ${l.servings}',
                          if (entry.note?.trim().isNotEmpty == true)
                            entry.note!.trim(),
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: cardColors.foreground.withAlpha(220),
                            ),
                      ),
                    ] else if (entry.servings != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${entry.servings} ${l.servings}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: cardColors.foreground.withAlpha(210),
                            ),
                      ),
                    ],
                    if (!compact && entry.note?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        entry.note!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cardColors.foreground.withAlpha(220),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (unavailableRecipe && compact)
                Tooltip(
                  message: l.recipeUnavailable,
                  child: Icon(
                    Icons.link_off_outlined,
                    size: 14,
                    color: cardColors.foreground,
                  ),
                )
              else if (onOpenRecipe != null && availableRecipe != null)
                SizedBox.square(
                  dimension: compact ? 20 : 30,
                  child: IconButton(
                    tooltip: l.openRecipe,
                    padding: EdgeInsets.zero,
                    iconSize: compact ? 13 : 17,
                    color: cardColors.foreground,
                    onPressed: onOpenRecipe,
                    icon: const Icon(Icons.open_in_new),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

double _mealCardHeight(MealPlanEntry entry) {
  var height = 54.0;
  if (entry.servings != null) height += 18;
  if (entry.note?.trim().isNotEmpty == true) height += 18;
  return height;
}

({Color background, Color foreground}) _mealCardColors(
  ColorScheme colors, {
  required DateTime date,
  required String slot,
  required int variant,
}) {
  const goldenAngle = 137.508;
  final dayNumber =
      DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
          Duration.millisecondsPerDay;
  final slotIndex = math.max(0, _mealSlots.indexOf(slot));
  final slotSeed = dayNumber * _mealSlots.length + slotIndex;
  final hue = (slotSeed.abs() * goldenAngle) % 360;
  final isDark = colors.brightness == Brightness.dark;
  const lightBackgrounds = [0.84, 0.79, 0.88, 0.82];
  const darkBackgrounds = [0.28, 0.23, 0.33, 0.26];
  const saturations = [0.62, 0.70, 0.55, 0.66];
  final paletteIndex = variant % lightBackgrounds.length;
  return (
    background: HSLColor.fromAHSL(
      1,
      hue,
      saturations[paletteIndex],
      isDark ? darkBackgrounds[paletteIndex] : lightBackgrounds[paletteIndex],
    ).toColor(),
    foreground: HSLColor.fromAHSL(
      1,
      hue,
      isDark ? 0.58 : 0.72,
      isDark ? 0.92 : 0.16,
    ).toColor(),
  );
}

enum _MealKind { recipe, custom }

class _MealPlanTemplateSummary {
  const _MealPlanTemplateSummary({
    required this.template,
    required this.entries,
  });

  final MealPlanTemplate template;
  final List<MealPlanTemplateEntry> entries;

  _MealPlanTemplateSummary copyWith({MealPlanTemplate? template}) =>
      _MealPlanTemplateSummary(
        template: template ?? this.template,
        entries: entries,
      );
}

class _MealPlanApplyChoice {
  const _MealPlanApplyChoice.previousWeek({this.replace = false})
      : previousWeek = true,
        template = null;

  const _MealPlanApplyChoice.template(
    this.template, {
    this.replace = false,
  }) : previousWeek = false;

  final bool previousWeek;
  final MealPlanTemplate? template;
  final bool replace;

  _MealPlanApplyChoice copyWith({required bool replace}) => previousWeek
      ? _MealPlanApplyChoice.previousWeek(replace: replace)
      : _MealPlanApplyChoice.template(template, replace: replace);
}

class _TemplateSectionHeading extends StatelessWidget {
  const _TemplateSectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      );
}

class _MealEntryEditor extends StatefulWidget {
  const _MealEntryEditor({
    required this.entry,
    required this.initialDate,
    required this.initialSlot,
    required this.recipes,
  });

  final MealPlanEntry? entry;
  final DateTime initialDate;
  final String initialSlot;
  final List<Recipe> recipes;

  @override
  State<_MealEntryEditor> createState() => _MealEntryEditorState();
}

class _MealEntryEditorState extends State<_MealEntryEditor> {
  late DateTime _plannedDate;
  late String _mealSlot;
  late _MealKind _kind;
  int? _recipeId;
  late final TextEditingController _customTitleController;
  late final TextEditingController _noteController;
  late final TextEditingController _servingsController;
  late final DateTime _initialPlannedDate;
  late final String _initialMealSlot;
  late final _MealKind _initialKind;
  late final int? _initialRecipeId;
  late final String _initialCustomTitle;
  late final String _initialNote;
  late final String _initialServings;
  bool _allowClose = false;
  bool _closePromptOpen = false;
  bool _dragging = false;
  double _dragOffset = 0;

  bool get _hasValidServings {
    final value = _servingsController.text.trim();
    if (value.isEmpty) return true;
    final parsed = int.tryParse(value);
    return parsed != null && parsed > 0;
  }

  bool get _canSave =>
      _hasValidServings &&
      switch (_kind) {
        _MealKind.recipe => _recipeId != null,
        _MealKind.custom => _customTitleController.text.trim().isNotEmpty,
      };

  bool get _hasUnsavedChanges {
    if (!_sameDate(_plannedDate, _initialPlannedDate) ||
        _mealSlot != _initialMealSlot ||
        _kind != _initialKind ||
        _noteController.text != _initialNote ||
        _servingsController.text != _initialServings) {
      return true;
    }
    return switch (_kind) {
      _MealKind.recipe => _recipeId != _initialRecipeId,
      _MealKind.custom => _customTitleController.text != _initialCustomTitle,
    };
  }

  @override
  void initState() {
    super.initState();
    _plannedDate = _dateOnly(widget.entry?.plannedDate ?? widget.initialDate);
    _mealSlot = widget.entry?.mealSlot ?? widget.initialSlot;
    _recipeId = widget.entry?.recipeId;
    final hasUnavailableRecipeSnapshot =
        widget.entry?.recipeTitleSnapshot?.trim().isNotEmpty == true &&
            widget.entry?.customTitle?.trim().isNotEmpty != true;
    _kind = widget.entry == null ||
            _recipeId != null ||
            hasUnavailableRecipeSnapshot
        ? _MealKind.recipe
        : _MealKind.custom;
    _customTitleController = TextEditingController(
      text: widget.entry?.customTitle ?? '',
    )..addListener(_refresh);
    _noteController = TextEditingController(text: widget.entry?.note ?? '')
      ..addListener(_refresh);
    _servingsController = TextEditingController(
      text: widget.entry?.servings?.toString() ?? '',
    )..addListener(_refresh);
    _initialPlannedDate = _plannedDate;
    _initialMealSlot = _mealSlot;
    _initialKind = _kind;
    _initialRecipeId = _recipeId;
    _initialCustomTitle = _customTitleController.text;
    _initialNote = _noteController.text;
    _initialServings = _servingsController.text;
  }

  @override
  void dispose() {
    _customTitleController.removeListener(_refresh);
    _noteController.removeListener(_refresh);
    _servingsController.removeListener(_refresh);
    _customTitleController.dispose();
    _noteController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<bool> _confirmDiscardChanges() async {
    if (!_hasUnsavedChanges) return true;
    final l = Languages.of(context)!;
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.discardChanges),
        content: Text(l.discardMealChangesMessage),
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
      ),
    );
    return shouldDiscard ?? false;
  }

  Future<void> _requestClose() async {
    if (_closePromptOpen) return;
    _closePromptOpen = true;
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final shouldClose = await _confirmDiscardChanges();
      if (!shouldClose || !mounted) return;
      setState(() => _allowClose = true);
      Navigator.of(context).pop();
    } finally {
      _closePromptOpen = false;
    }
  }

  void _closeWithResult(_MealEditorResult result) {
    setState(() => _allowClose = true);
    Navigator.of(context).pop(result);
  }

  void _startDismissDrag(DragStartDetails details) {
    setState(() => _dragging = true);
  }

  void _updateDismissDrag(DragUpdateDetails details) {
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy).clamp(0, 180);
    });
  }

  Future<void> _endDismissDrag(DragEndDetails details) async {
    final shouldClose = _dragOffset >= 64 ||
        (details.primaryVelocity != null && details.primaryVelocity! > 650);
    setState(() {
      _dragging = false;
      _dragOffset = 0;
    });
    if (shouldClose) await _requestClose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plannedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _plannedDate = _dateOnly(picked));
    }
  }

  Future<void> _pickRecipe() async {
    final recipeId = await showRecipePickerSheet(
      context: context,
      selectedRecipeId: _recipeId,
    );
    if (recipeId != null) {
      final selectedRecipe =
          (await Singleton().getDatabase().getRecipeById(recipeId).first)
              .where((recipe) => recipe.deletedAt == null)
              .firstOrNull;
      if (!mounted) return;
      setState(() {
        _recipeId = recipeId;
        if (_servingsController.text.trim().isEmpty) {
          final defaultServings = selectedRecipe?.servings;
          if (defaultServings != null) {
            _servingsController.text = defaultServings.toString();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return TapRegion(
      onTapOutside: (_) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          _requestClose();
        }
      },
      child: PopScope<_MealEditorResult>(
        canPop: _allowClose || !_hasUnsavedChanges,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) await _requestClose();
        },
        child: AnimatedContainer(
          duration:
              _dragging ? Duration.zero : const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _dragOffset, 0),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragStart: _startDismissDrag,
                        onVerticalDragUpdate: _updateDismissDrag,
                        onVerticalDragEnd: _endDismissDrag,
                        child: SizedBox(
                          height: 28,
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withAlpha(90),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.entry == null ? l.addMeal : l.editMeal,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 18),
                      SegmentedButton<_MealKind>(
                        segments: [
                          ButtonSegment(
                            value: _MealKind.recipe,
                            icon: const Icon(Icons.restaurant_menu),
                            label: Text(l.recipeMeal),
                          ),
                          ButtonSegment(
                            value: _MealKind.custom,
                            icon: const Icon(Icons.edit_outlined),
                            label: Text(l.customMeal),
                          ),
                        ],
                        selected: {_kind},
                        onSelectionChanged: (selection) {
                          setState(() => _kind = selection.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final dateButton = OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(
                              DateFormat.yMMMMd(l.languageCode)
                                  .format(_plannedDate),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                          final slotDropdown = DropdownButtonFormField<String>(
                            value: _mealSlot,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.schedule_outlined),
                              border: OutlineInputBorder(),
                            ),
                            items: _mealSlots
                                .map(
                                  (slot) => DropdownMenuItem(
                                    value: slot,
                                    child: Text(_slotLabel(l, slot)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _mealSlot = value);
                              }
                            },
                          );
                          if (constraints.maxWidth < 500) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                dateButton,
                                const SizedBox(height: 12),
                                slotDropdown,
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: dateButton),
                              const SizedBox(width: 12),
                              Expanded(child: slotDropdown),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_kind == _MealKind.recipe)
                        StreamBuilder<List<Recipe>>(
                          stream: _recipeId == null
                              ? Stream.value(const <Recipe>[])
                              : Singleton()
                                  .getDatabase()
                                  .getRecipeById(_recipeId!),
                          builder: (context, recipeSnapshot) {
                            final selectedRecipe = recipeSnapshot.data
                                ?.where((recipe) => recipe.deletedAt == null)
                                .firstOrNull;
                            final selectedTitle = selectedRecipe?.title ??
                                (_recipeId == widget.entry?.recipeId
                                    ? widget.entry?.recipeTitleSnapshot
                                    : null);
                            final unavailableRecipe = selectedRecipe == null &&
                                selectedTitle?.trim().isNotEmpty == true;
                            return InkWell(
                              onTap: _pickRecipe,
                              borderRadius: BorderRadius.circular(4),
                              child: InputDecorator(
                                isEmpty: selectedTitle == null,
                                decoration: InputDecoration(
                                  labelText: l.selectRecipe,
                                  helperText: unavailableRecipe
                                      ? l.recipeUnavailable
                                      : null,
                                  prefixIcon: const Icon(Icons.restaurant_menu),
                                  border: const OutlineInputBorder(),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: selectedTitle == null
                                          ? const SizedBox(height: 20)
                                          : Text(
                                              selectedTitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      else
                        TextField(
                          controller: _customTitleController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: l.customMealTitle,
                            prefixIcon: const Icon(Icons.edit_outlined),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _servingsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l.plannedServings,
                          prefixIcon: const Icon(Icons.people_outline),
                          border: const OutlineInputBorder(),
                          errorText:
                              _servingsController.text.trim().isNotEmpty &&
                                      (int.tryParse(_servingsController.text
                                                  .trim()) ==
                                              null ||
                                          int.parse(_servingsController.text
                                                  .trim()) <=
                                              0)
                                  ? l.invalidServings
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _noteController,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 2,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: l.mealNote,
                          prefixIcon: const Icon(Icons.notes_outlined),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (widget.entry != null)
                            IconButton(
                              tooltip: l.deleteMeal,
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () => _closeWithResult(
                                const _MealEditorResult.delete(),
                              ),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          const Spacer(),
                          TextButton(
                            onPressed: _requestClose,
                            child: Text(l.cancel),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _canSave
                                ? () => _closeWithResult(
                                      _MealEditorResult.save(
                                        _MealDraft(
                                          plannedDate: _plannedDate,
                                          mealSlot: _mealSlot,
                                          recipeId: _kind == _MealKind.recipe
                                              ? _recipeId
                                              : null,
                                          customTitle: _kind == _MealKind.custom
                                              ? _customTitleController.text
                                                  .trim()
                                              : null,
                                          note: _noteController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _noteController.text.trim(),
                                          servings: int.tryParse(
                                            _servingsController.text.trim(),
                                          ),
                                        ),
                                      ),
                                    )
                                : null,
                            child: Text(l.save),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MealDraft {
  const _MealDraft({
    required this.plannedDate,
    required this.mealSlot,
    this.recipeId,
    this.customTitle,
    this.note,
    this.servings,
  });

  final DateTime plannedDate;
  final String mealSlot;
  final int? recipeId;
  final String? customTitle;
  final String? note;
  final int? servings;
}

class _MealEditorResult {
  const _MealEditorResult.save(this.draft) : deleteEntry = false;
  const _MealEditorResult.delete()
      : draft = null,
        deleteEntry = true;

  final _MealDraft? draft;
  final bool deleteEntry;
}

String _slotLabel(Languages l, String slot) {
  return switch (slot) {
    'breakfast' => l.breakfast,
    'lunch' => l.lunch,
    'dinner' => l.dinner,
    'snack' => l.snack,
    _ => slot,
  };
}

String _entryTitle(
  MealPlanEntry entry,
  List<Recipe> recipes,
  Languages l,
) {
  if (entry.customTitle?.trim().isNotEmpty == true) {
    return entry.customTitle!.trim();
  }
  final liveTitle =
      recipes.where((recipe) => recipe.id == entry.recipeId).firstOrNull?.title;
  if (liveTitle != null) return liveTitle;
  final savedTitle = entry.recipeTitleSnapshot?.trim();
  return savedTitle?.isNotEmpty == true ? savedTitle! : l.recipeUnavailable;
}

String _templateEntryTitle(
  MealPlanTemplateEntry entry,
  List<Recipe> recipes,
  Languages l,
) {
  if (entry.customTitle?.trim().isNotEmpty == true) {
    return entry.customTitle!.trim();
  }
  final liveTitle =
      recipes.where((recipe) => recipe.id == entry.recipeId).firstOrNull?.title;
  if (liveTitle != null) return liveTitle;
  final savedTitle = entry.recipeTitleSnapshot?.trim();
  if (savedTitle?.isNotEmpty == true) {
    return '$savedTitle · ${l.recipeUnavailable}';
  }
  return l.recipeUnavailable;
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _startOfWeek(DateTime date) {
  final normalized = _dateOnly(date);
  return normalized.subtract(Duration(days: normalized.weekday - 1));
}

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

void _sortMealEntries(List<MealPlanEntry> entries) {
  entries.sort((a, b) {
    final orderComparison = a.sortOrder.compareTo(b.sortOrder);
    if (orderComparison != 0) return orderComparison;
    final createdComparison = a.createdAt.compareTo(b.createdAt);
    if (createdComparison != 0) return createdComparison;
    return a.id.compareTo(b.id);
  });
}
