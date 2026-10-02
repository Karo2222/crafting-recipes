import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/widgets/shopping_category_picker.dart';
import 'package:craftingrecipes/widgets/shared_access_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum _ShoppingListDisplayMode { detailed, quick }

const int _generalShoppingSectionValue = 0;

class ShoppingListsView extends StatefulWidget {
  const ShoppingListsView({super.key});

  @override
  State<ShoppingListsView> createState() => ShoppingListsViewState();
}

class ShoppingListsViewState extends State<ShoppingListsView> {
  int? _selectedListId;
  bool _saving = false;
  _ShoppingListDisplayMode _displayMode = _ShoppingListDisplayMode.quick;
  final Set<int> _updatingItemIds = {};
  late final Stream<List<ShoppingList>> _shoppingListsStream;
  late final Stream<List<SharedResourceInvitation>> _invitationsStream;
  late final Future<List<ShoppingCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = SupabaseToDrift.ensureShoppingCategoriesLoaded();
    final accountId = currentAccount;
    _shoppingListsStream = accountId == null
        ? Stream.value(const <ShoppingList>[])
        : Singleton().getDatabase().watchShoppingListsForAccount(accountId);
    _invitationsStream = accountId == null
        ? Stream.value(const <SharedResourceInvitation>[])
        : Singleton()
            .getDatabase()
            .watchPendingShoppingListInvitations(accountId);
    _loadDisplayMode();
  }

  Future<bool> openShoppingList(int shoppingListId) async {
    final accountId = currentAccount;
    if (accountId == null) return false;
    await SupabaseToDrift.waitForActiveSync();
    final availableLists =
        await Singleton().getDatabase().getShoppingListsForAccount(accountId);
    if (!availableLists.any((list) => list.id == shoppingListId)) {
      return false;
    }
    if (mounted) setState(() => _selectedListId = shoppingListId);
    return mounted;
  }

  Future<void> _loadDisplayMode() async {
    final preferences = await Singleton().getPrefInstance();
    final quickMode = preferences.getBool('shopping_list_quick_mode') ?? true;
    if (mounted) {
      setState(() {
        _displayMode = quickMode
            ? _ShoppingListDisplayMode.quick
            : _ShoppingListDisplayMode.detailed;
      });
    }
  }

  Future<void> _setDisplayMode(_ShoppingListDisplayMode mode) async {
    if (_displayMode == mode) return;
    setState(() => _displayMode = mode);
    final preferences = await Singleton().getPrefInstance();
    await preferences.setBool(
      'shopping_list_quick_mode',
      mode == _ShoppingListDisplayMode.quick,
    );
  }

  Future<void> _respondToInvitation(
    SharedResourceInvitation invitation,
    bool accept,
  ) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    await _runAction(
      () => DriftToSupabase.respondToShoppingListInvitation(
        accountId: accountId,
        shoppingListId: invitation.resourceId,
        accept: accept,
      ),
      errorMessage: Languages.of(context)!.somethingWentWrong,
    );
    if (accept && mounted) {
      setState(() => _selectedListId = invitation.resourceId);
    }
  }

  Future<void> _runAction(
    Future<void> Function() action, {
    required String errorMessage,
    String Function(Object error)? errorMessageBuilder,
  }) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await action();
    } catch (error) {
      logger.e('Shopping list operation failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessageBuilder?.call(error) ?? errorMessage),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<String?> _showListNameDialog({ShoppingList? list}) async {
    final l = Languages.of(context)!;
    var name = list?.name ?? '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final valid = name.trim().isNotEmpty;
          return AlertDialog(
            title: Text(
              list == null ? l.createShoppingList : l.renameShoppingList,
            ),
            content: TextFormField(
              initialValue: name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.shoppingListName,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setDialogState(() => name = value),
              onFieldSubmitted: valid
                  ? (_) => Navigator.of(dialogContext).pop(name.trim())
                  : null,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: valid
                    ? () => Navigator.of(dialogContext).pop(name.trim())
                    : null,
                child: Text(l.save),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<String?> _showSectionNameDialog({
    ShoppingListSection? section,
    Set<String> existingNames = const {},
  }) async {
    final l = Languages.of(context)!;
    var name = section?.name ?? '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final trimmedName = name.trim();
          final nameAlreadyExists =
              existingNames.contains(trimmedName.toLowerCase());
          final valid = trimmedName.isNotEmpty && !nameAlreadyExists;
          return AlertDialog(
            title: Text(
              section == null ? l.addShoppingSection : l.renameShoppingSection,
            ),
            content: TextFormField(
              initialValue: name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l.shoppingSectionName,
                errorText: nameAlreadyExists
                    ? l.shoppingSectionNameAlreadyExists(trimmedName)
                    : null,
                errorMaxLines: 2,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setDialogState(() => name = value),
              onFieldSubmitted: valid
                  ? (_) => Navigator.of(dialogContext).pop(name.trim())
                  : null,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: valid
                    ? () => Navigator.of(dialogContext).pop(name.trim())
                    : null,
                child: Text(section == null ? l.create : l.save),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createList() async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    final name = await _showListNameDialog();
    if (name == null || !mounted) return;
    await _runAction(
      () async {
        final list = await DriftToSupabase.createShoppingList(
          accountId: accountId,
          name: name,
        );
        if (mounted) setState(() => _selectedListId = list.id);
      },
      errorMessage: l.couldNotSaveShoppingList,
    );
  }

  Future<void> _renameList(ShoppingList list) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    final name = await _showListNameDialog(list: list);
    if (name == null || name == list.name || !mounted) return;
    await _runAction(
      () => DriftToSupabase.renameShoppingList(
        accountId: accountId,
        shoppingListId: list.id,
        name: name,
      ),
      errorMessage: l.couldNotSaveShoppingList,
    );
  }

  Future<void> _deleteList(ShoppingList list) async {
    final l = Languages.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteShoppingList),
        content: Text(l.confirmDeleteShoppingList(list.name)),
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
    if (confirmed != true || !mounted || currentAccount == null) return;
    await _runAction(
      () async {
        await DriftToSupabase.deleteShoppingList(
          accountId: currentAccount!,
          shoppingListId: list.id,
        );
        if (mounted) setState(() => _selectedListId = null);
      },
      errorMessage: l.couldNotSaveShoppingList,
    );
  }

  Future<void> _shareList(ShoppingList list) async {
    final accountId = currentAccount;
    if (accountId == null || list.accountId != accountId) return;
    await SupabaseToDrift.waitForActiveSync();
    final database = Singleton().getDatabase();
    final members = await database.watchShoppingListMembers(list.id).first;
    final accounts = await database.getAcceptedFriendAccounts(accountId);
    if (!mounted) return;
    await showSharedAccessDialog(
      context: context,
      resourceName: list.name,
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
          DriftToSupabase.setShoppingListMember(
        ownerAccountId: accountId,
        shoppingListId: list.id,
        memberAccountId: memberAccountId,
        permission: permission,
      ),
      onRemoveMember: (memberAccountId) async {
        final currentMembers =
            await database.watchShoppingListMembers(list.id).first;
        final member = currentMembers
            .where((item) => item.accountId == memberAccountId)
            .firstOrNull;
        if (member != null) {
          await DriftToSupabase.removeShoppingListMember(
            ownerAccountId: accountId,
            member: member,
          );
        }
      },
    );
  }

  Future<void> _addItem(ShoppingList list) async {
    final l = Languages.of(context)!;
    await SupabaseToDrift.waitForActiveSync();
    final sections = await Singleton()
        .getDatabase()
        .watchShoppingListSections(list.id)
        .first;
    if (!mounted) return;
    final draft = await showDialog<ShoppingItemDraft>(
      context: context,
      builder: (context) => _ShoppingItemDialog(
        categoriesFuture: _categoriesFuture,
        sections: sections,
      ),
    );
    if (draft == null || !mounted || currentAccount == null) return;
    await _runAction(
      () => DriftToSupabase.addShoppingListItem(
        accountId: currentAccount!,
        shoppingListId: list.id,
        name: draft.name,
        amount: draft.amount,
        unit: draft.unit,
        note: draft.note,
        sectionId: draft.sectionId,
        shoppingCategoryCode: draft.shoppingCategoryCode,
      ),
      errorMessage: l.couldNotSaveShoppingItem,
    );
  }

  Future<bool> _addQuickItem(
    ShoppingList list,
    String name,
    int? sectionId,
  ) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    final trimmedName = name.trim();
    if (accountId == null || trimmedName.isEmpty) return false;
    try {
      await DriftToSupabase.addShoppingListItem(
        accountId: accountId,
        shoppingListId: list.id,
        name: trimmedName,
        sectionId: sectionId,
      );
      return true;
    } catch (error) {
      logger.e('Could not quickly add shopping item: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotSaveShoppingItem)),
        );
      }
      return false;
    }
  }

  Future<bool> _renameQuickItem(
    ShoppingListItem item,
    String name,
  ) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    final trimmedName = name.trim();
    if (accountId == null || trimmedName.isEmpty) return false;
    if (trimmedName == item.name) return true;
    try {
      await DriftToSupabase.updateShoppingListItem(
        accountId: accountId,
        itemId: item.id,
        name: trimmedName,
        amount: item.amount,
        unit: item.unit,
        note: item.note,
        sectionId: item.sectionId,
        shoppingCategoryCode: item.shoppingCategoryCode,
      );
      return true;
    } catch (error) {
      logger.e('Could not quickly rename shopping item: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotSaveShoppingItem)),
        );
      }
      return false;
    }
  }

  Future<void> _editItem(ShoppingListItem item) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    await SupabaseToDrift.waitForActiveSync();
    final sections = await Singleton()
        .getDatabase()
        .watchShoppingListSections(item.shoppingListId)
        .first;
    if (!mounted) return;
    final draft = await showDialog<ShoppingItemDraft>(
      context: context,
      builder: (context) => _ShoppingItemDialog(
        categoriesFuture: _categoriesFuture,
        sections: sections,
        item: item,
      ),
    );
    if (draft == null || !mounted) return;
    await _runAction(
      () async {
        await DriftToSupabase.updateShoppingListItem(
          accountId: accountId,
          itemId: item.id,
          name: draft.name,
          amount: draft.amount,
          unit: draft.unit,
          note: draft.note,
          sectionId: draft.sectionId,
          shoppingCategoryCode: draft.shoppingCategoryCode,
        );
        if (item.ingredientId != null &&
            draft.shoppingCategoryCode != item.shoppingCategoryCode) {
          await DriftToSupabase.setIngredientShoppingCategory(
            accountId: accountId,
            ingredientId: item.ingredientId!,
            shoppingCategoryCode: draft.shoppingCategoryCode,
          );
        }
      },
      errorMessage: l.couldNotSaveShoppingItem,
    );
  }

  Future<void> _toggleItem(ShoppingListItem item, bool checked) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null || !_updatingItemIds.add(item.id)) return;
    try {
      await DriftToSupabase.setShoppingListItemChecked(
        accountId: accountId,
        itemId: item.id,
        checked: checked,
      );
    } catch (error) {
      logger.e('Could not update shopping item: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotSaveShoppingItem)),
      );
    } finally {
      _updatingItemIds.remove(item.id);
    }
  }

  Future<void> _createSection(ShoppingList list) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    await SupabaseToDrift.waitForActiveSync();
    final sections = await Singleton()
        .getDatabase()
        .watchShoppingListSections(list.id)
        .first;
    final name = await _showSectionNameDialog(
      existingNames:
          sections.map((section) => section.name.trim().toLowerCase()).toSet(),
    );
    if (name == null || !mounted) return;
    await _runAction(
      () => DriftToSupabase.createShoppingListSection(
        accountId: accountId,
        shoppingListId: list.id,
        name: name,
      ),
      errorMessage: l.couldNotSaveShoppingSection,
      errorMessageBuilder: (error) =>
          error is ShoppingListSectionNameAlreadyExistsException
              ? l.shoppingSectionNameAlreadyExists(error.name)
              : l.couldNotSaveShoppingSection,
    );
  }

  Future<void> _renameSection(ShoppingListSection section) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    await SupabaseToDrift.waitForActiveSync();
    final sections = await Singleton()
        .getDatabase()
        .watchShoppingListSections(section.shoppingListId)
        .first;
    final name = await _showSectionNameDialog(
      section: section,
      existingNames: sections
          .where((candidate) => candidate.id != section.id)
          .map((candidate) => candidate.name.trim().toLowerCase())
          .toSet(),
    );
    if (name == null || name == section.name || !mounted) return;
    await _runAction(
      () => DriftToSupabase.renameShoppingListSection(
        accountId: accountId,
        sectionId: section.id,
        name: name,
      ),
      errorMessage: l.couldNotSaveShoppingSection,
      errorMessageBuilder: (error) =>
          error is ShoppingListSectionNameAlreadyExistsException
              ? l.shoppingSectionNameAlreadyExists(error.name)
              : l.couldNotSaveShoppingSection,
    );
  }

  Future<void> _deleteSection(ShoppingListSection section) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteShoppingSection),
        content: Text(l.confirmDeleteShoppingSection(section.name)),
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
    await _runAction(
      () => DriftToSupabase.deleteShoppingListSection(
        accountId: accountId,
        sectionId: section.id,
      ),
      errorMessage: l.couldNotSaveShoppingSection,
    );
  }

  Future<void> _moveItemToSection(
    ShoppingListItem item,
    int? sectionId,
  ) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null || item.sectionId == sectionId) return;
    try {
      await DriftToSupabase.moveShoppingListItemToSection(
        accountId: accountId,
        itemId: item.id,
        sectionId: sectionId,
      );
    } catch (error) {
      logger.e('Could not move shopping item: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotSaveShoppingItem)),
      );
    }
  }

  Future<void> _removeItemConfirmed(ShoppingListItem item) async {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (!mounted || accountId == null || !_updatingItemIds.add(item.id)) return;
    try {
      await DriftToSupabase.deleteShoppingListItem(
        accountId: accountId,
        itemId: item.id,
      );
    } catch (error) {
      logger.e('Could not remove shopping item: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotSaveShoppingItem)),
        );
      }
    } finally {
      _updatingItemIds.remove(item.id);
    }
  }

  Future<void> _removeCheckedItems(List<ShoppingListItem> items) async {
    if (items.isEmpty) return;
    final l = Languages.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.removeCheckedShoppingItems(items.length)),
        content: Text(l.confirmRemoveCheckedShoppingItems(items.length)),
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
    for (final item in items) {
      await _removeItemConfirmed(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) {
      return Center(child: Text(l.accountNotAvailable));
    }

    return StreamBuilder<bool>(
      stream: RecipePermissions.watchCanModifyContent(),
      builder: (context, permissionSnapshot) {
        final canModify = permissionSnapshot.data == true;
        return StreamBuilder<List<ShoppingList>>(
          stream: _shoppingListsStream,
          builder: (context, snapshot) {
            final lists = snapshot.data ?? const <ShoppingList>[];
            final selected = lists.where((list) {
                  return list.id == _selectedListId;
                }).firstOrNull ??
                lists.firstOrNull;

            return StreamBuilder<bool>(
              stream: selected == null
                  ? Stream.value(false)
                  : Singleton()
                      .getDatabase()
                      .watchCanEditShoppingList(accountId, selected.id),
              builder: (context, accessSnapshot) {
                final canEditSelected = canModify &&
                    accessSnapshot.data == true &&
                    selected != null;
                final ownsSelected = selected?.accountId == accountId;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: ListView(
                      keyboardDismissBehavior:
                          _displayMode == _ShoppingListDisplayMode.quick
                              ? ScrollViewKeyboardDismissBehavior.onDrag
                              : ScrollViewKeyboardDismissBehavior.manual,
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l.shoppingLists,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            if (canModify)
                              IconButton(
                                tooltip: l.createShoppingList,
                                onPressed: _saving ? null : _createList,
                                icon: const Icon(Icons.add),
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        StreamBuilder<List<SharedResourceInvitation>>(
                          stream: _invitationsStream,
                          builder: (context, invitationSnapshot) =>
                              SharedInvitationsPanel(
                            invitations: invitationSnapshot.data ?? const [],
                            onAccept: (invitation) =>
                                _respondToInvitation(invitation, true),
                            onDecline: (invitation) =>
                                _respondToInvitation(invitation, false),
                          ),
                        ),
                        StreamBuilder<List<SharedResourceInvitation>>(
                          stream: _invitationsStream,
                          builder: (context, invitationSnapshot) =>
                              invitationSnapshot.data?.isNotEmpty == true
                                  ? const SizedBox(height: 18)
                                  : const SizedBox.shrink(),
                        ),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const Center(child: CircularProgressIndicator())
                        else if (lists.isEmpty)
                          _EmptyShoppingLists(
                            canModify: canModify,
                            onCreate: _createList,
                          )
                        else ...[
                          _ShoppingListSelector(
                            lists: lists,
                            selected: selected!,
                            canRename: canEditSelected && !_saving,
                            canManage: ownsSelected && canModify && !_saving,
                            onSelected: (id) =>
                                setState(() => _selectedListId = id),
                            onRename: () => _renameList(selected),
                            onDelete: () => _deleteList(selected),
                            onShare: () => _shareList(selected),
                          ),
                          const SizedBox(height: 10),
                          SharedWithSummary(
                            resourceType: SharedResourceType.shoppingList,
                            resourceId: selected.id,
                            ownerAccountId: selected.accountId,
                            currentAccountId: accountId,
                          ),
                          const SizedBox(height: 18),
                          _ShoppingItems(
                            list: selected,
                            categoriesFuture: _categoriesFuture,
                            canModify: canEditSelected && !_saving,
                            displayMode: _displayMode,
                            onDisplayModeChanged: _setDisplayMode,
                            onQuickAdd: _addQuickItem,
                            onQuickRename: _renameQuickItem,
                            onToggle: _toggleItem,
                            onEdit: _editItem,
                            onCreateSection: _createSection,
                            onRenameSection: _renameSection,
                            onDeleteSection: _deleteSection,
                            onMoveToSection: _moveItemToSection,
                            onRemove: _removeItemConfirmed,
                            onRemoveChecked: _removeCheckedItems,
                          ),
                          if (canEditSelected &&
                              _displayMode ==
                                  _ShoppingListDisplayMode.detailed) ...[
                            const SizedBox(height: 18),
                            FilledButton.icon(
                              onPressed:
                                  _saving ? null : () => _addItem(selected),
                              icon: const Icon(Icons.add),
                              label: Text(l.addShoppingItem),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ShoppingListSelector extends StatelessWidget {
  const _ShoppingListSelector({
    required this.lists,
    required this.selected,
    required this.canRename,
    required this.canManage,
    required this.onSelected,
    required this.onRename,
    required this.onDelete,
    required this.onShare,
  });

  final List<ShoppingList> lists;
  final ShoppingList selected;
  final bool canRename;
  final bool canManage;
  final ValueChanged<int> onSelected;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selected.id,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l.shoppingList,
              prefixIcon: const Icon(Icons.list_alt_outlined),
              border: const OutlineInputBorder(),
            ),
            items: lists
                .map(
                  (list) => DropdownMenuItem<int>(
                    value: list.id,
                    child: Text(
                      list.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (id) {
              if (id != null) onSelected(id);
            },
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          tooltip: l.renameShoppingList,
          onPressed: canRename ? onRename : null,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: l.manageAccess,
          onPressed: canManage ? onShare : null,
          icon: const Icon(Icons.group_add_outlined),
        ),
        IconButton(
          tooltip: l.deleteShoppingList,
          onPressed: canManage ? onDelete : null,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}

class _ShoppingItems extends StatefulWidget {
  const _ShoppingItems({
    required this.list,
    required this.categoriesFuture,
    required this.canModify,
    required this.displayMode,
    required this.onDisplayModeChanged,
    required this.onQuickAdd,
    required this.onQuickRename,
    required this.onToggle,
    required this.onEdit,
    required this.onCreateSection,
    required this.onRenameSection,
    required this.onDeleteSection,
    required this.onMoveToSection,
    required this.onRemove,
    required this.onRemoveChecked,
  });

  final ShoppingList list;
  final Future<List<ShoppingCategory>> categoriesFuture;
  final bool canModify;
  final _ShoppingListDisplayMode displayMode;
  final ValueChanged<_ShoppingListDisplayMode> onDisplayModeChanged;
  final Future<bool> Function(ShoppingList, String, int?) onQuickAdd;
  final Future<bool> Function(ShoppingListItem, String) onQuickRename;
  final Future<void> Function(ShoppingListItem, bool) onToggle;
  final Future<void> Function(ShoppingListItem) onEdit;
  final Future<void> Function(ShoppingList) onCreateSection;
  final Future<void> Function(ShoppingListSection) onRenameSection;
  final Future<void> Function(ShoppingListSection) onDeleteSection;
  final Future<void> Function(ShoppingListItem, int?) onMoveToSection;
  final Future<void> Function(ShoppingListItem) onRemove;
  final Future<void> Function(List<ShoppingListItem>) onRemoveChecked;

  @override
  State<_ShoppingItems> createState() => _ShoppingItemsState();
}

class _ShoppingItemsState extends State<_ShoppingItems> {
  late Stream<List<ShoppingListItem>> _itemsStream;
  late Stream<List<ShoppingListSection>> _sectionsStream;
  final Map<String, TextEditingController> _quickEntryControllers = {};
  final Map<String, FocusNode> _quickEntryFocusNodes = {};
  final Map<String, GlobalKey> _quickEntryKeys = {};
  final Set<String> _collapsedSections = {};
  bool _quickAddInProgress = false;
  int? _previousItemCount;

  @override
  void initState() {
    super.initState();
    _itemsStream =
        Singleton().getDatabase().watchShoppingListItems(widget.list.id);
    _sectionsStream =
        Singleton().getDatabase().watchShoppingListSections(widget.list.id);
  }

  @override
  void didUpdateWidget(covariant _ShoppingItems oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list.id != widget.list.id) {
      _itemsStream =
          Singleton().getDatabase().watchShoppingListItems(widget.list.id);
      _sectionsStream =
          Singleton().getDatabase().watchShoppingListSections(widget.list.id);
      _previousItemCount = null;
    }
  }

  @override
  void dispose() {
    for (final controller in _quickEntryControllers.values) {
      controller.dispose();
    }
    for (final focusNode in _quickEntryFocusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String _quickEntryId(int? sectionId) =>
      '${widget.list.id}:${sectionId ?? _generalShoppingSectionValue}';

  bool _isSectionCollapsed(int? sectionId) =>
      _collapsedSections.contains(_quickEntryId(sectionId));

  void _toggleSection(int? sectionId) {
    setState(() {
      final entryId = _quickEntryId(sectionId);
      if (!_collapsedSections.remove(entryId)) {
        _collapsedSections.add(entryId);
      }
    });
  }

  TextEditingController _quickController(int? sectionId) =>
      _quickEntryControllers.putIfAbsent(
        _quickEntryId(sectionId),
        TextEditingController.new,
      );

  FocusNode _quickFocusNode(int? sectionId) {
    final entryId = _quickEntryId(sectionId);
    return _quickEntryFocusNodes.putIfAbsent(entryId, () {
      final focusNode = FocusNode();
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          _submitQuickItem(_quickController(sectionId).text, sectionId);
        }
      });
      return focusNode;
    });
  }

  GlobalKey _quickEntryKey(int? sectionId) =>
      _quickEntryKeys.putIfAbsent(_quickEntryId(sectionId), GlobalKey.new);

  Future<void> _submitQuickItem(String value, int? sectionId) async {
    final name = value.trim();
    if (name.isEmpty || _quickAddInProgress || !widget.canModify) return;
    final controller = _quickController(sectionId);
    _quickAddInProgress = true;
    controller.clear();
    final saved = await widget.onQuickAdd(widget.list, name, sectionId);
    if (!saved && controller.text.isEmpty) {
      controller.text = name;
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );
    }
    _quickAddInProgress = false;
  }

  void _keepQuickEntryVisible(int itemCount) {
    final itemWasAdded =
        _previousItemCount != null && itemCount > _previousItemCount!;
    _previousItemCount = itemCount;
    if (!itemWasAdded || widget.displayMode != _ShoppingListDisplayMode.quick) {
      return;
    }
    final focusedEntry = _quickEntryFocusNodes.entries
        .where((entry) => entry.value.hasFocus)
        .firstOrNull;
    if (focusedEntry == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final entryContext = _quickEntryKeys[focusedEntry.key]?.currentContext;
      if (!mounted || entryContext == null) return;
      Scrollable.ensureVisible(
        entryContext,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return SlidableAutoCloseBehavior(
      child: FutureBuilder<List<ShoppingCategory>>(
        future: widget.categoriesFuture,
        builder: (context, categorySnapshot) =>
            StreamBuilder<List<ShoppingListSection>>(
          stream: _sectionsStream,
          builder: (context, sectionSnapshot) =>
              StreamBuilder<List<ShoppingListItem>>(
            stream: _itemsStream,
            builder: (context, itemSnapshot) {
              final items = itemSnapshot.data ?? const <ShoppingListItem>[];
              final sections =
                  sectionSnapshot.data ?? const <ShoppingListSection>[];
              final checkedItems = items.where((item) => item.checked).toList();
              _keepQuickEntryVisible(items.length);
              final categories =
                  categorySnapshot.data ?? const <ShoppingCategory>[];
              final waiting = itemSnapshot.connectionState ==
                      ConnectionState.waiting ||
                  sectionSnapshot.connectionState == ConnectionState.waiting ||
                  categorySnapshot.connectionState == ConnectionState.waiting;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.shoppingItems,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (widget.canModify) ...[
                        const SizedBox(width: 8),
                        Tooltip(
                          message: l.addShoppingSection,
                          child: TextButton.icon(
                            onPressed: () =>
                                widget.onCreateSection(widget.list),
                            icon: const Icon(
                              Icons.add_business_outlined,
                              size: 18,
                            ),
                            label: Text(l.addShoppingSection),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SegmentedButton<_ShoppingListDisplayMode>(
                            showSelectedIcon: false,
                            segments: [
                              ButtonSegment(
                                value: _ShoppingListDisplayMode.quick,
                                icon: const Icon(
                                  Icons.edit_note_outlined,
                                  size: 18,
                                ),
                                label: Text(l.quickShoppingList),
                                tooltip: l.quickShoppingList,
                              ),
                              ButtonSegment(
                                value: _ShoppingListDisplayMode.detailed,
                                icon: const Icon(
                                  Icons.view_agenda_outlined,
                                  size: 18,
                                ),
                                label: Text(l.detailedShoppingList),
                                tooltip: l.detailedShoppingList,
                              ),
                            ],
                            selected: {widget.displayMode},
                            onSelectionChanged: (selection) {
                              widget.onDisplayModeChanged(selection.first);
                            },
                          ),
                        ),
                      ),
                      if (widget.canModify) ...[
                        const SizedBox(width: 8),
                        SizedBox.square(
                          dimension: 40,
                          child: Visibility(
                            visible: checkedItems.isNotEmpty,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            child: IconButton(
                              tooltip: l.removeCheckedShoppingItems(
                                checkedItems.length,
                              ),
                              padding: const EdgeInsets.all(8),
                              onPressed: () =>
                                  widget.onRemoveChecked(checkedItems),
                              icon: Badge.count(
                                count: checkedItems.length,
                                child: const Icon(Icons.delete_outline),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (waiting)
                    const Center(child: CircularProgressIndicator())
                  else
                    ..._buildStoreSections(
                      context: context,
                      items: items,
                      sections: sections,
                      categories: categories,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStoreSections({
    required BuildContext context,
    required List<ShoppingListItem> items,
    required List<ShoppingListSection> sections,
    required List<ShoppingCategory> categories,
  }) {
    final knownSectionIds = sections.map((section) => section.id).toSet();
    final storeSections = <ShoppingListSection?>[null, ...sections];
    final children = <Widget>[];
    for (var index = 0; index < storeSections.length; index++) {
      final section = storeSections[index];
      final sectionItems = section == null
          ? items
              .where((item) =>
                  item.sectionId == null ||
                  !knownSectionIds.contains(item.sectionId))
              .toList()
          : items.where((item) => item.sectionId == section.id).toList();
      children.add(
        _buildStoreSection(
          context: context,
          section: section,
          items: sectionItems,
          categories: categories,
        ),
      );
      if (index < storeSections.length - 1) {
        children.add(const SizedBox(height: 12));
      }
    }
    if (items.isEmpty &&
        sections.isEmpty &&
        widget.displayMode == _ShoppingListDisplayMode.detailed) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 22),
          child: Center(child: Text(Languages.of(context)!.noShoppingItems)),
        ),
      );
    }
    return children;
  }

  Widget _buildStoreSection({
    required BuildContext context,
    required ShoppingListSection? section,
    required List<ShoppingListItem> items,
    required List<ShoppingCategory> categories,
  }) {
    final sectionId = section?.id;
    final collapsed = _isSectionCollapsed(sectionId);
    return DragTarget<ShoppingListItem>(
      onWillAcceptWithDetails: (details) =>
          widget.canModify &&
          details.data.shoppingListId == widget.list.id &&
          details.data.sectionId != sectionId,
      onAcceptWithDetails: (details) =>
          widget.onMoveToSection(details.data, sectionId),
      builder: (context, candidates, rejected) {
        final highlighted = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            color: highlighted
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerLowest,
            border: Border.all(
              color: highlighted
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
              width: highlighted ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ShoppingSectionHeader(
                section: section,
                itemCount: items.length,
                canModify: widget.canModify,
                highlighted: highlighted,
                collapsed: collapsed,
                onToggleCollapsed: () => _toggleSection(sectionId),
                onRename: section == null
                    ? null
                    : () => widget.onRenameSection(section),
                onDelete: section == null
                    ? null
                    : () => widget.onDeleteSection(section),
              ),
              if (collapsed)
                const SizedBox.shrink()
              else if (highlighted && items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(Languages.of(context)!.dropShoppingItemHere),
                  ),
                )
              else if (widget.displayMode == _ShoppingListDisplayMode.quick)
                Column(
                  children: [
                    _buildQuickItems(context, items),
                    if (widget.canModify)
                      _QuickShoppingEntryRow(
                        key: _quickEntryKey(sectionId),
                        controller: _quickController(sectionId),
                        focusNode: _quickFocusNode(sectionId),
                        onSubmitted: (value) =>
                            _submitQuickItem(value, sectionId),
                      ),
                  ],
                )
              else
                ..._buildCategorySections(
                  context: context,
                  items: items,
                  categories: categories,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickItems(
    BuildContext context,
    List<ShoppingListItem> items,
  ) {
    final sortedItems = [...items]..sort((a, b) {
        final createdComparison = a.createdAt.compareTo(b.createdAt);
        if (createdComparison != 0) return createdComparison;
        return a.id.compareTo(b.id);
      });
    return Column(
      children: [
        ...sortedItems.map(
          (item) => _buildDraggableItem(
            context,
            item,
            _ShoppingItemSlidable(
              item: item,
              canModify: widget.canModify,
              onRemove: widget.onRemove,
              child: _QuickShoppingItemRow(
                item: item,
                canModify: widget.canModify,
                onToggle: widget.onToggle,
                onRename: widget.onQuickRename,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableItem(
    BuildContext context,
    ShoppingListItem item,
    Widget child,
  ) {
    if (!widget.canModify) return child;
    final feedback = Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(6),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_indicator, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final desktopDrag = kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;
    if (desktopDrag) {
      return Draggable<ShoppingListItem>(
        data: item,
        maxSimultaneousDrags: 1,
        feedback: feedback,
        childWhenDragging: Opacity(opacity: 0.35, child: child),
        child: child,
      );
    }
    return LongPressDraggable<ShoppingListItem>(
      data: item,
      delay: const Duration(milliseconds: 280),
      maxSimultaneousDrags: 1,
      feedback: feedback,
      childWhenDragging: Opacity(opacity: 0.35, child: child),
      child: child,
    );
  }

  List<Widget> _buildCategorySections({
    required BuildContext context,
    required List<ShoppingListItem> items,
    required List<ShoppingCategory> categories,
  }) {
    final categoryByCode = {
      for (final category in categories) category.code: category,
    };
    final orderedCategories = [...categories];
    if (!categoryByCode.containsKey('other')) {
      orderedCategories.add(_fallbackCategory());
    }

    return orderedCategories.expand((category) {
      final categoryItems = items
          .where((item) => item.shoppingCategoryCode == category.code)
          .toList()
        ..sort((a, b) {
          final checkedComparison =
              (a.checked ? 1 : 0).compareTo(b.checked ? 1 : 0);
          if (checkedComparison != 0) return checkedComparison;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      if (categoryItems.isEmpty) return const <Widget>[];
      return <Widget>[
        _ShoppingCategoryHeader(category: category),
        const SizedBox(height: 8),
        ...categoryItems.map(
          (item) => _buildDraggableItem(
            context,
            item,
            _ShoppingItemSlidable(
              item: item,
              canModify: widget.canModify,
              onRemove: widget.onRemove,
              child: _ShoppingItemTile(
                item: item,
                canModify: widget.canModify,
                onToggle: widget.onToggle,
                onEdit: widget.onEdit,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ];
    }).toList();
  }

  ShoppingCategory _fallbackCategory() {
    final now = DateTime.fromMillisecondsSinceEpoch(0);
    return ShoppingCategory(
      code: 'other',
      nameEn: 'Other',
      nameDe: 'Sonstiges',
      sortOrder: 999,
      createdAt: now,
      createdBy: 0,
      updatedAt: now,
      updatedBy: 0,
    );
  }
}

class _ShoppingSectionHeader extends StatelessWidget {
  const _ShoppingSectionHeader({
    required this.section,
    required this.itemCount,
    required this.canModify,
    required this.highlighted,
    required this.collapsed,
    required this.onToggleCollapsed,
    required this.onRename,
    required this.onDelete,
  });

  final ShoppingListSection? section;
  final int itemCount;
  final bool canModify;
  final bool highlighted;
  final bool collapsed;
  final VoidCallback onToggleCollapsed;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final color = highlighted
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onSurface;
    final sectionName = section?.name ?? l.generalShoppingSection;
    return Row(
      children: [
        Icon(
          section == null ? Icons.inventory_2_outlined : Icons.store_outlined,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$sectionName ($itemCount)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          tooltip: collapsed
              ? l.expandShoppingSection(sectionName)
              : l.collapseShoppingSection(sectionName),
          onPressed: onToggleCollapsed,
          iconSize: 27,
          style: IconButton.styleFrom(
            minimumSize: const Size.square(44),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            foregroundColor: color,
          ),
          icon: AnimatedRotation(
            turns: collapsed ? 0 : 0.5,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            child: const Icon(Icons.expand_more_rounded),
          ),
        ),
        if (canModify && section != null)
          PopupMenuButton<_SectionAction>(
            tooltip: l.shoppingSections,
            onSelected: (action) {
              switch (action) {
                case _SectionAction.rename:
                  onRename?.call();
                case _SectionAction.delete:
                  onDelete?.call();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _SectionAction.rename,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(l.renameShoppingSection),
                ),
              ),
              PopupMenuItem(
                value: _SectionAction.delete,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_outline),
                  title: Text(l.deleteShoppingSection),
                ),
              ),
            ],
          )
      ],
    );
  }
}

enum _SectionAction { rename, delete }

class _ShoppingItemSlidable extends StatelessWidget {
  const _ShoppingItemSlidable({
    required this.item,
    required this.canModify,
    required this.onRemove,
    required this.child,
  });

  final ShoppingListItem item;
  final bool canModify;
  final Future<void> Function(ShoppingListItem) onRemove;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!canModify) return child;
    final l = Languages.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final actionRatio = (68 / constraints.maxWidth).clamp(0.08, 0.3);
        return Slidable(
          key: ValueKey('shopping-item-${item.id}'),
          groupTag: 'shopping-list-${item.shoppingListId}',
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: actionRatio,
            children: [
              CustomSlidableAction(
                onPressed: (_) async => onRemove(item),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                borderRadius: BorderRadius.circular(6),
                child: Tooltip(
                  message: l.removeShoppingItem,
                  child: const Icon(Icons.delete_outline),
                ),
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

class _QuickShoppingItemRow extends StatefulWidget {
  const _QuickShoppingItemRow({
    required this.item,
    required this.canModify,
    required this.onToggle,
    required this.onRename,
  });

  final ShoppingListItem item;
  final bool canModify;
  final Future<void> Function(ShoppingListItem, bool) onToggle;
  final Future<bool> Function(ShoppingListItem, String) onRename;

  @override
  State<_QuickShoppingItemRow> createState() => _QuickShoppingItemRowState();
}

class _QuickShoppingItemRowState extends State<_QuickShoppingItemRow> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item.name);
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant _QuickShoppingItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing && oldWidget.item.name != widget.item.name) {
      _controller.text = widget.item.name;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _editing) _submitName();
  }

  void _startEditing() {
    if (!widget.canModify || _editing) return;
    setState(() => _editing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    });
  }

  Future<void> _submitName() async {
    if (_saving || !_editing) return;
    final name = _controller.text.trim();
    if (name.isEmpty) {
      _controller.text = widget.item.name;
      setState(() => _editing = false);
      return;
    }
    _saving = true;
    final saved = await widget.onRename(widget.item, name);
    _saving = false;
    if (!mounted) return;
    if (!saved) _controller.text = widget.item.name;
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final amount = widget.item.amount == null
        ? null
        : widget.item.unit == null
            ? _formatAmount(widget.item.amount!)
            : '${_formatAmount(widget.item.amount!)} ${l.unitLabel(widget.item.unit!)}';
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            _ShoppingCheckbox(
              value: widget.item.checked,
              onChanged: widget.canModify
                  ? (checked) {
                      if (checked != null) {
                        widget.onToggle(widget.item, checked);
                      }
                    }
                  : null,
            ),
            Expanded(
              child: _editing
                  ? TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _submitName,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    )
                  : InkWell(
                      onTap: _startEditing,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          widget.item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: widget.item.checked
                                ? TextDecoration.lineThrough
                                : null,
                            color: widget.item.checked
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                      ),
                    ),
            ),
            if (amount != null && !_editing) ...[
              const SizedBox(width: 10),
              Text(
                amount,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _QuickShoppingEntryRow extends StatelessWidget {
  const _QuickShoppingEntryRow({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: l.addShoppingItem,
            onPressed: () => onSubmitted(controller.text),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => onSubmitted(controller.text),
              decoration: InputDecoration(
                hintText: l.quickAddShoppingItem,
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShoppingCategoryHeader extends StatelessWidget {
  const _ShoppingCategoryHeader({required this.category});

  final ShoppingCategory category;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Row(
      children: [
        Icon(
          shoppingCategoryIcon(category.code),
          size: 19,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          shoppingCategoryLabel(category, l.languageCode),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _ShoppingItemTile extends StatelessWidget {
  const _ShoppingItemTile({
    required this.item,
    required this.canModify,
    required this.onToggle,
    required this.onEdit,
  });

  final ShoppingListItem item;
  final bool canModify;
  final Future<void> Function(ShoppingListItem, bool) onToggle;
  final Future<void> Function(ShoppingListItem) onEdit;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
        child: Row(
          children: [
            _ShoppingCheckbox(
              value: item.checked,
              onChanged: canModify
                  ? (checked) {
                      if (checked != null) onToggle(item, checked);
                    }
                  : null,
            ),
            Expanded(
              child: InkWell(
                onTap: canModify ? () => onEdit(item) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration:
                              item.checked ? TextDecoration.lineThrough : null,
                          color: item.checked
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : null,
                        ),
                      ),
                      if (item.amount != null && item.unit != null)
                        Text(
                          '${_formatAmount(item.amount!)} ${l.unitLabel(item.unit!)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      if (item.note?.trim().isNotEmpty == true)
                        Text(
                          item.note!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: l.editShoppingItem,
              onPressed: canModify ? () => onEdit(item) : null,
              icon: const Icon(Icons.edit_outlined),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _ShoppingCheckbox extends StatelessWidget {
  const _ShoppingCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 52,
        child: Transform.scale(
          scale: 1.2,
          child: Checkbox(value: value, onChanged: onChanged),
        ),
      );
}

class _EmptyShoppingLists extends StatelessWidget {
  const _EmptyShoppingLists({
    required this.canModify,
    required this.onCreate,
  });

  final bool canModify;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 52,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 14),
          Text(
            l.noShoppingLists,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (canModify) ...[
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: Text(l.createFirstShoppingList),
            ),
          ],
        ],
      ),
    );
  }
}

class ShoppingItemDraft {
  const ShoppingItemDraft({
    required this.name,
    required this.shoppingCategoryCode,
    this.sectionId,
    this.amount,
    this.unit,
    this.note,
  });

  final String name;
  final String shoppingCategoryCode;
  final int? sectionId;
  final double? amount;
  final String? unit;
  final String? note;
}

class _ShoppingItemDialog extends StatefulWidget {
  const _ShoppingItemDialog({
    required this.categoriesFuture,
    required this.sections,
    this.item,
  });

  final Future<List<ShoppingCategory>> categoriesFuture;
  final List<ShoppingListSection> sections;
  final ShoppingListItem? item;

  @override
  State<_ShoppingItemDialog> createState() => _ShoppingItemDialogState();
}

class _ShoppingItemDialogState extends State<_ShoppingItemDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late final Future<List<MeasurementUnit>> _unitsFuture;
  String? _unit;
  int? _sectionId;
  String _shoppingCategoryCode = 'other';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _amountController = TextEditingController(
      text: widget.item?.amount == null
          ? ''
          : _formatAmount(widget.item!.amount!),
    );
    _noteController = TextEditingController(text: widget.item?.note ?? '');
    _unit = widget.item?.unit;
    final itemSectionId = widget.item?.sectionId;
    _sectionId = widget.sections.any(
      (section) => section.id == itemSectionId,
    )
        ? itemSectionId
        : null;
    _shoppingCategoryCode =
        widget.item?.shoppingCategoryCode ?? _shoppingCategoryCode;
    _unitsFuture = Singleton()
        .getDatabase()
        .getSelectableMeasurementUnits()
        .then(_sortShoppingItemUnits);
    _nameController.addListener(_refresh);
    _amountController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_refresh);
    _amountController.removeListener(_refresh);
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double? get _amount {
    final value = _amountController.text.trim();
    if (value.isEmpty) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }

  bool get _valid {
    if (_nameController.text.trim().isEmpty) return false;
    if (_amountController.text.trim().isEmpty) return true;
    return _amount != null && _amount! > 0;
  }

  Future<void> _pickUnit(List<MeasurementUnit> units) async {
    if (units.isEmpty) return;
    final l = Languages.of(context)!;
    var index = units.indexWhere((unit) => unit.code == _unit);
    if (index < 0) index = 0;
    var selected = units[index].code;
    final controller = FixedExtentScrollController(initialItem: index);
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: 280,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(l.done),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: controller,
                  itemExtent: 42,
                  onSelectedItemChanged: (selectedIndex) {
                    selected = units[selectedIndex].code;
                  },
                  children: units
                      .map(
                        (unit) => Center(
                          child: Text(l.unitLabel(unit.code)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    controller.dispose();
    if (mounted) setState(() => _unit = selected);
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return AlertDialog(
      title: Text(
        widget.item == null ? l.addShoppingItem : l.editShoppingItem,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.shoppingItemName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<int>(
              value: _sectionId ?? _generalShoppingSectionValue,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l.moveToShoppingSection,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: _generalShoppingSectionValue,
                  child: Text(l.generalShoppingSection),
                ),
                ...widget.sections.map(
                  (section) => DropdownMenuItem(
                    value: section.id,
                    child: Text(
                      section.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _sectionId =
                      value == _generalShoppingSectionValue ? null : value;
                });
              },
            ),
            const SizedBox(height: 14),
            FutureBuilder<List<ShoppingCategory>>(
              future: widget.categoriesFuture,
              builder: (context, snapshot) {
                final categories = snapshot.data ?? const <ShoppingCategory>[];
                final hasSelectedCategory = categories.any(
                  (category) => category.code == _shoppingCategoryCode,
                );
                if (!hasSelectedCategory && categories.isNotEmpty) {
                  _shoppingCategoryCode = categories.first.code;
                }
                return DropdownButtonFormField<String>(
                  value: categories.isEmpty ? null : _shoppingCategoryCode,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l.supermarketCategory,
                    border: const OutlineInputBorder(),
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem<String>(
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
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _shoppingCategoryCode = value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: l.optionalQuantity,
                border: const OutlineInputBorder(),
              ),
            ),
            if (_amountController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              FutureBuilder<List<MeasurementUnit>>(
                future: _unitsFuture,
                builder: (context, snapshot) {
                  final units = snapshot.data ?? const <MeasurementUnit>[];
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: units.isEmpty ? null : () => _pickUnit(units),
                      icon: const Icon(Icons.straighten),
                      label: Text(
                        _unit == null ? l.unit : l.unitLabel(_unit!),
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 14),
            TextField(
              controller: _noteController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.shoppingItemNote,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _valid
              ? () => Navigator.of(context).pop(
                    ShoppingItemDraft(
                      name: _nameController.text.trim(),
                      shoppingCategoryCode: _shoppingCategoryCode,
                      sectionId: _sectionId,
                      amount: _amount,
                      unit: _amount == null ? null : _unit,
                      note: _noteController.text.trim().isEmpty
                          ? null
                          : _noteController.text.trim(),
                    ),
                  )
              : null,
          child: Text(widget.item == null ? l.addShoppingItem : l.save),
        ),
      ],
    );
  }
}

const _shoppingItemUnitPriority = <String>[
  'piece',
  'package',
  'can',
  'bottle',
  'bunch',
  'slice',
  'clove',
  'handful',
  'sprig',
  'cup',
  'tbsp',
  'tsp',
  'pinch',
  'drop',
  'g',
  'kg',
  'ml',
  'l',
  'cl',
  'dl',
  'mg',
  'oz',
  'lb',
  'fl_oz',
];

List<MeasurementUnit> _sortShoppingItemUnits(List<MeasurementUnit> units) {
  final priority = {
    for (var index = 0; index < _shoppingItemUnitPriority.length; index++)
      _shoppingItemUnitPriority[index]: index,
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

String _formatAmount(double amount) {
  return amount == amount.roundToDouble()
      ? amount.toInt().toString()
      : amount.toString();
}
