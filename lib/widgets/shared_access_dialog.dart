import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:flutter/material.dart';

enum SharedResourceType { shoppingList, mealPlan }

class SharedWithSummary extends StatefulWidget {
  const SharedWithSummary({
    super.key,
    required this.resourceType,
    required this.resourceId,
    required this.ownerAccountId,
    required this.currentAccountId,
  });

  final SharedResourceType resourceType;
  final int resourceId;
  final int ownerAccountId;
  final int currentAccountId;

  @override
  State<SharedWithSummary> createState() => _SharedWithSummaryState();
}

class _SharedWithSummaryState extends State<SharedWithSummary> {
  late Stream<List<SharedResourceParticipant>> _participantsStream;

  @override
  void initState() {
    super.initState();
    _participantsStream = _createStream();
  }

  @override
  void didUpdateWidget(covariant SharedWithSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resourceType != widget.resourceType ||
        oldWidget.resourceId != widget.resourceId ||
        oldWidget.ownerAccountId != widget.ownerAccountId) {
      _participantsStream = _createStream();
    }
  }

  Stream<List<SharedResourceParticipant>> _createStream() {
    final database = Singleton().getDatabase();
    return switch (widget.resourceType) {
      SharedResourceType.shoppingList => database.watchShoppingListParticipants(
          widget.resourceId,
          widget.ownerAccountId,
        ),
      SharedResourceType.mealPlan => database.watchMealPlanParticipants(
          widget.resourceId,
          widget.ownerAccountId,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final theme = Theme.of(context);
    return StreamBuilder<List<SharedResourceParticipant>>(
      stream: _participantsStream,
      builder: (context, snapshot) {
        final participants = (snapshot.data ?? const [])
            .where((participant) =>
                participant.account.id != widget.currentAccountId)
            .toList();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Icon(
                Icons.group_outlined,
                size: 18,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.sharedWith,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (participants.isEmpty)
                    Text(
                      l.noSharedMembers,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: participants
                          .map((participant) => _ParticipantChip(
                                participant: participant,
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ParticipantChip extends StatelessWidget {
  const _ParticipantChip({required this.participant});

  final SharedResourceParticipant participant;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final pending = participant.status == 'pending';
    final detail = participant.isOwner
        ? l.owner
        : pending
            ? l.invitationPending
            : null;
    final label = detail == null
        ? participant.account.accountName
        : '${participant.account.accountName} · $detail';
    return Chip(
      avatar: Icon(
        pending ? Icons.schedule_outlined : Icons.person_outline,
        size: 16,
      ),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide(
        color: pending
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }
}

class SharedAccessMember {
  const SharedAccessMember({
    required this.accountId,
    required this.permission,
    required this.status,
  });

  final int accountId;
  final String permission;
  final String status;

  SharedAccessMember copyWith({String? permission, String? status}) =>
      SharedAccessMember(
        accountId: accountId,
        permission: permission ?? this.permission,
        status: status ?? this.status,
      );
}

Future<void> showSharedAccessDialog({
  required BuildContext context,
  required String resourceName,
  required int ownerAccountId,
  required List<Account> accounts,
  required List<SharedAccessMember> initialMembers,
  required Future<void> Function(int accountId, String permission) onSetMember,
  required Future<void> Function(int accountId) onRemoveMember,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _SharedAccessDialog(
      resourceName: resourceName,
      ownerAccountId: ownerAccountId,
      accounts: accounts,
      initialMembers: initialMembers,
      onSetMember: onSetMember,
      onRemoveMember: onRemoveMember,
    ),
  );
}

class _SharedAccessDialog extends StatefulWidget {
  const _SharedAccessDialog({
    required this.resourceName,
    required this.ownerAccountId,
    required this.accounts,
    required this.initialMembers,
    required this.onSetMember,
    required this.onRemoveMember,
  });

  final String resourceName;
  final int ownerAccountId;
  final List<Account> accounts;
  final List<SharedAccessMember> initialMembers;
  final Future<void> Function(int accountId, String permission) onSetMember;
  final Future<void> Function(int accountId) onRemoveMember;

  @override
  State<_SharedAccessDialog> createState() => _SharedAccessDialogState();
}

class _SharedAccessDialogState extends State<_SharedAccessDialog> {
  late List<SharedAccessMember> _members;
  String _query = '';
  int? _selectedAccountId;
  String _newPermission = 'viewer';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _members = [...widget.initialMembers];
  }

  Account? _account(int id) =>
      widget.accounts.where((account) => account.id == id).firstOrNull;

  List<Account> get _searchResults {
    final query = _query.trim().toLowerCase();
    final matches = widget.accounts
        .where((account) =>
            account.id != widget.ownerAccountId &&
            (query.isEmpty ||
                account.accountName.trim().toLowerCase().contains(query)))
        .toList()
      ..sort((a, b) {
        final aName = a.accountName.trim().toLowerCase();
        final bName = b.accountName.trim().toLowerCase();
        final prefixComparison = (bName.startsWith(query) ? 1 : 0)
            .compareTo(aName.startsWith(query) ? 1 : 0);
        return prefixComparison != 0
            ? prefixComparison
            : aName.compareTo(bName);
      });
    return matches.take(query.isEmpty ? 5 : 8).toList();
  }

  List<SharedAccessMember> get _activeMembers =>
      _members.where((member) => member.status != 'declined').toList();

  Future<void> _invite(Account account) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.onSetMember(account.id, _newPermission);
      if (!mounted) return;
      setState(() {
        final invitation = SharedAccessMember(
          accountId: account.id,
          permission: _newPermission,
          status: 'pending',
        );
        final index = _members.indexWhere(
          (member) => member.accountId == account.id,
        );
        if (index == -1) {
          _members.add(invitation);
        } else {
          _members[index] = invitation;
        }
        _query = '';
        _selectedAccountId = null;
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePermission(
    SharedAccessMember member,
    String permission,
  ) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.onSetMember(member.accountId, permission);
      if (!mounted) return;
      setState(() {
        final index = _members.indexWhere(
          (candidate) => candidate.accountId == member.accountId,
        );
        _members[index] = member.copyWith(permission: permission);
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _remove(SharedAccessMember member) async {
    if (_saving) return;
    final l = Languages.of(context)!;
    final accountName =
        _account(member.accountId)?.accountName ?? '#${member.accountId}';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.removeAccess),
        content: Text(
          l.confirmRemoveAccess(accountName, widget.resourceName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.removeAccess),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await widget.onRemoveMember(member.accountId);
      if (!mounted) return;
      setState(() => _members.removeWhere(
            (candidate) => candidate.accountId == member.accountId,
          ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final results = _searchResults;
    final selectedAccount = _selectedAccountId == null
        ? null
        : widget.accounts
            .where((account) => account.id == _selectedAccountId)
            .firstOrNull;
    final selectedMember = selectedAccount == null
        ? null
        : _activeMembers
            .where((member) => member.accountId == selectedAccount.id)
            .firstOrNull;
    return AlertDialog(
      title: Text(l.manageAccess),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.resourceName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: l.searchFriends,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  helperText: l.onlyFriendsCanBeInvited,
                ),
                textInputAction: TextInputAction.search,
                autocorrect: false,
                onChanged: (value) => setState(() {
                  _query = value;
                  _selectedAccountId = null;
                }),
              ),
              const SizedBox(height: 10),
              if (widget.accounts.isEmpty)
                _SearchResultMessage(
                  icon: Icons.people_outline,
                  text: l.noFriends,
                )
              else ...[
                Text(
                  _query.trim().isEmpty ? l.suggestions : l.friends,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                if (results.isEmpty)
                  _SearchResultMessage(
                    icon: Icons.person_search_outlined,
                    text: l.accountNotFound,
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 260),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final account = results[index];
                        final member = _activeMembers
                            .where((item) => item.accountId == account.id)
                            .firstOrNull;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          selected: _selectedAccountId == account.id,
                          leading: const CircleAvatar(
                            child: Icon(Icons.person_outline),
                          ),
                          title: Text(account.accountName),
                          subtitle: member == null
                              ? null
                              : Text(member.status == 'pending'
                                  ? l.invitationPending
                                  : l.sharedWith),
                          trailing: member == null
                              ? const Icon(Icons.chevron_right)
                              : const Icon(Icons.check_circle_outline),
                          onTap: member == null
                              ? () => setState(
                                    () => _selectedAccountId = account.id,
                                  )
                              : null,
                        );
                      },
                    ),
                  ),
              ],
              if (selectedAccount != null && selectedMember == null) ...[
                const SizedBox(height: 14),
                _RecipientPreview(
                  account: selectedAccount,
                  label: l.accountFound,
                ),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'viewer',
                      label: Text(l.roleLabel('viewer')),
                      icon: const Icon(Icons.visibility_outlined),
                    ),
                    ButtonSegment(
                      value: 'editor',
                      label: Text(l.roleLabel('editor')),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                  selected: {_newPermission},
                  onSelectionChanged: _saving
                      ? null
                      : (selection) => setState(
                            () => _newPermission = selection.first,
                          ),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: _saving ? null : () => _invite(selectedAccount),
                  icon: const Icon(Icons.send_outlined),
                  label: Text(l.sendInvitation),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                l.sharedWith,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (_activeMembers.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(l.noSharedMembers),
                )
              else
                ..._activeMembers.map((member) => _MemberRow(
                      member: member,
                      account: _account(member.accountId),
                      saving: _saving,
                      onPermissionChanged: (permission) =>
                          _changePermission(member, permission),
                      onRemove: () => _remove(member),
                    )),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(l.close),
        ),
      ],
    );
  }
}

class _SearchResultMessage extends StatelessWidget {
  const _SearchResultMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      );
}

class _RecipientPreview extends StatelessWidget {
  const _RecipientPreview({required this.account, required this.label});

  final Account account;
  final String label;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text(account.accountName),
        subtitle: Text(label),
      );
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.account,
    required this.saving,
    required this.onPermissionChanged,
    required this.onRemove,
  });

  final SharedAccessMember member;
  final Account? account;
  final bool saving;
  final ValueChanged<String> onPermissionChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
      title: Text(account?.accountName ?? '#${member.accountId}'),
      subtitle: member.status == 'pending' ? Text(l.invitationPending) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: member.permission,
            items: ['viewer', 'editor']
                .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(l.roleLabel(role)),
                    ))
                .toList(),
            onChanged: saving
                ? null
                : (value) {
                    if (value != null) onPermissionChanged(value);
                  },
          ),
          IconButton(
            tooltip: l.removeAccess,
            onPressed: saving ? null : onRemove,
            icon: const Icon(Icons.person_remove_outlined),
          ),
        ],
      ),
    );
  }
}

class SharedInvitationsPanel extends StatelessWidget {
  const SharedInvitationsPanel({
    super.key,
    required this.invitations,
    required this.onAccept,
    required this.onDecline,
    this.title,
  });

  final List<SharedResourceInvitation> invitations;
  final ValueChanged<SharedResourceInvitation> onAccept;
  final ValueChanged<SharedResourceInvitation> onDecline;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (invitations.isEmpty) return const SizedBox.shrink();
    final l = Languages.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.mail_outline),
            const SizedBox(width: 8),
            Text(
              title ?? l.invitations,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...invitations.map(
          (invitation) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    invitation.resourceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l.invitedBy}: ${invitation.ownerAccountName} · '
                    '${l.roleLabel(invitation.permission)}',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => onDecline(invitation),
                        child: Text(l.declineInvitation),
                      ),
                      const SizedBox(width: 6),
                      FilledButton(
                        onPressed: () => onAccept(invitation),
                        child: Text(l.acceptInvitation),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
