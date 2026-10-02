import 'dart:typed_data';

import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/recipe_view.dart';
import 'package:craftingrecipes/views/settings_view.dart';
import 'package:craftingrecipes/widgets/listitem.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.accountId});

  final int accountId;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.account)),
      body: AccountView(accountId: accountId),
    );
  }
}

class AccountView extends StatefulWidget {
  const AccountView({
    super.key,
    required this.accountId,
    this.profileManagement,
  });

  final int accountId;
  final Widget? profileManagement;

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  bool _changingFollow = false;

  bool get _isOwnAccount => widget.accountId == currentAccount;

  Future<void> _openRecipe(Recipe recipe) async {
    await Navigator.of(context).push(
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

  Future<void> _openSettings() async {
    final l = Languages.of(context)!;
    await Navigator.of(context, rootNavigator: true).push(
      appPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(l.settingsTitle)),
          body: const SettingsView(),
        ),
        fullScreenSwipeBack: true,
      ),
    );
  }

  Future<void> _editAccount(Account account) async {
    if (!await RecipePermissions.canModifyContent()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Languages.of(context)!.viewerCannotEdit)),
      );
      return;
    }
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _EditAccountSheet(account: account),
    );
  }

  Future<void> _setFollowing(bool currentlyFollowing) async {
    final accountId = currentAccount;
    if (accountId == null || _changingFollow) return;
    setState(() => _changingFollow = true);
    try {
      if (currentlyFollowing) {
        await DriftToSupabase.unfollowAccount(
          followerAccountId: accountId,
          followedAccountId: widget.accountId,
        );
      } else {
        await DriftToSupabase.followAccount(
          followerAccountId: accountId,
          followedAccountId: widget.accountId,
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _changingFollow = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return StreamBuilder<List<Account>>(
      stream: Singleton().getDatabase().watchAccountById(widget.accountId),
      builder: (context, snapshot) {
        final account = snapshot.data?.firstOrNull;
        if (account == null) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(child: Text(l.accountNotAvailable));
        }

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  FutureBuilder<bool>(
                    future: RecipePermissions.canModifyContent(),
                    builder: (context, permissionSnapshot) => _AccountHeader(
                      account: account,
                      isOwnAccount: _isOwnAccount,
                      canModify: permissionSnapshot.data == true,
                      changingFollow: _changingFollow,
                      onEdit: () => _editAccount(account),
                      onSettings: _openSettings,
                      onFollowChanged: _setFollowing,
                    ),
                  ),
                  if (_isOwnAccount && widget.profileManagement != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.switch_account_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l.profiles,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          widget.profileManagement!,
                        ],
                      ),
                    ),
                  if (_isOwnAccount)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: _FriendsSection(accountId: widget.accountId),
                    ),
                  if (_isOwnAccount)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.historyTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          body: _isOwnAccount
              ? _HistoryList(
                  accountId: widget.accountId,
                  onRecipeSelected: _openRecipe,
                )
              : _CreatedRecipeList(
                  accountId: widget.accountId,
                  onRecipeSelected: _openRecipe,
                ),
        );
      },
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    required this.account,
    required this.isOwnAccount,
    required this.canModify,
    required this.changingFollow,
    required this.onEdit,
    required this.onSettings,
    required this.onFollowChanged,
  });

  final Account account;
  final bool isOwnAccount;
  final bool canModify;
  final bool changingFollow;
  final VoidCallback onEdit;
  final VoidCallback onSettings;
  final ValueChanged<bool> onFollowChanged;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final formatter = DateFormat.yMMMMd(l.languageCode);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountAvatar(account: account, radius: 42),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.accountName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${l.memberSince} ${formatter.format(account.createdAt.toLocal())}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    _FollowCounts(accountId: account.id),
                  ],
                ),
              ),
              if (isOwnAccount)
                IconButton(
                  onPressed: onSettings,
                  tooltip: l.settingsTitle,
                  icon: const Icon(Icons.settings_outlined),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            account.bio?.trim().isNotEmpty == true
                ? account.bio!.trim()
                : l.noBioYet,
            style: account.bio?.trim().isNotEmpty == true
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
          ),
          const SizedBox(height: 14),
          if (isOwnAccount)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (canModify)
                  OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l.editAccount),
                  ),
              ],
            )
          else if (canModify)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FollowButton(
                  accountId: account.id,
                  changingFollow: changingFollow,
                  onFollowChanged: onFollowChanged,
                ),
                _FriendButton(accountId: account.id),
              ],
            ),
        ],
      ),
    );
  }
}

class AccountAvatar extends StatelessWidget {
  const AccountAvatar({super.key, required this.account, this.radius = 24});

  final Account account;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final image = account.profileImage?.trim();
    final initial = account.accountName.trim().isEmpty
        ? '?'
        : account.accountName.trim().characters.first.toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundImage: image?.isNotEmpty == true ? NetworkImage(image!) : null,
      child: Text(
        initial,
        style: TextStyle(fontSize: radius * .72, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class AccountSearchPage extends StatefulWidget {
  const AccountSearchPage({super.key, required this.currentAccountId});

  final int currentAccountId;

  @override
  State<AccountSearchPage> createState() => _AccountSearchPageState();
}

class _AccountSearchPageState extends State<AccountSearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final normalized = _query.trim().toLowerCase();
    return Scaffold(
      appBar: AppBar(title: Text(l.findPeople)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l.searchAccounts,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.search,
                    autocorrect: false,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Text(
                    normalized.isEmpty ? l.suggestions : l.accounts,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Account>>(
                    stream: Singleton().getDatabase().allAccountEntriesAsStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final accounts = snapshot.data!
                          .where((account) =>
                              account.id != widget.currentAccountId &&
                              (normalized.isEmpty ||
                                  account.accountName
                                      .trim()
                                      .toLowerCase()
                                      .contains(normalized)))
                          .toList()
                        ..sort((a, b) {
                          final aName = a.accountName.trim().toLowerCase();
                          final bName = b.accountName.trim().toLowerCase();
                          final prefixComparison =
                              (bName.startsWith(normalized) ? 1 : 0).compareTo(
                            aName.startsWith(normalized) ? 1 : 0,
                          );
                          return prefixComparison != 0
                              ? prefixComparison
                              : aName.compareTo(bName);
                        });
                      if (accounts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              normalized.isEmpty
                                  ? l.emptyData
                                  : l.accountNotFound,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      final visibleAccounts = normalized.isEmpty
                          ? accounts.take(12).toList()
                          : accounts;
                      return ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: visibleAccounts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final account = visibleAccounts[index];
                          final bio = account.bio?.trim();
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            leading: AccountAvatar(account: account),
                            title: Text(account.accountName),
                            subtitle: bio?.isNotEmpty == true
                                ? Text(
                                    bio!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              appPageRoute(
                                builder: (_) =>
                                    AccountPage(accountId: account.id),
                                fullScreenSwipeBack: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FollowCounts extends StatelessWidget {
  const _FollowCounts({required this.accountId});

  final int accountId;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final database = Singleton().getDatabase();
    return StreamBuilder<List<AccountFollow>>(
      stream: database.watchFollowers(accountId),
      builder: (context, followersSnapshot) {
        return StreamBuilder<List<AccountFollow>>(
          stream: database.watchFollowing(accountId),
          builder: (context, followingSnapshot) {
            return Wrap(
              spacing: 16,
              children: [
                InkWell(
                  onTap: () => _showAccountList(
                    context,
                    title: l.followers,
                    stream: database.watchFollowerAccounts(accountId),
                  ),
                  child: Text(
                      '${followersSnapshot.data?.length ?? 0} ${l.followers}'),
                ),
                InkWell(
                  onTap: () => _showAccountList(
                    context,
                    title: l.following,
                    stream: database.watchFollowingAccounts(accountId),
                  ),
                  child: Text(
                      '${followingSnapshot.data?.length ?? 0} ${l.following}'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAccountList(
    BuildContext context, {
    required String title,
    required Stream<List<Account>> stream,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        showDragHandle: true,
        builder: (sheetContext) => StreamBuilder<List<Account>>(
          stream: stream,
          builder: (context, snapshot) {
            final accounts = snapshot.data ?? const <Account>[];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 12, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: accounts.isEmpty
                      ? const Center(child: Text('—'))
                      : ListView.builder(
                          itemCount: accounts.length,
                          itemBuilder: (context, index) {
                            final account = accounts[index];
                            return ListTile(
                              leading: AccountAvatar(account: account),
                              title: Text(account.accountName),
                              onTap: () {
                                Navigator.of(sheetContext).pop();
                                Navigator.of(context).push(
                                  appPageRoute(
                                    builder: (_) =>
                                        AccountPage(accountId: account.id),
                                    fullScreenSwipeBack: true,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      );
}

Future<bool> _confirmFriendRemoval(
  BuildContext context,
  String accountName,
) async {
  final l = Languages.of(context)!;
  return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l.removeFriend),
          content: Text(l.confirmRemoveFriend(accountName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l.removeFriend),
            ),
          ],
        ),
      ) ??
      false;
}

class _FriendButton extends StatefulWidget {
  const _FriendButton({required this.accountId});

  final int accountId;

  @override
  State<_FriendButton> createState() => _FriendButtonState();
}

class _FriendButtonState extends State<_FriendButton> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountId = currentAccount;
    if (accountId == null) return const SizedBox.shrink();
    final l = Languages.of(context)!;
    return StreamBuilder<List<FriendConnection>>(
      stream: Singleton().getDatabase().watchFriendConnections(accountId),
      builder: (context, snapshot) {
        final connection = snapshot.data
            ?.where((item) => item.account.id == widget.accountId)
            .firstOrNull;
        final friendship = connection?.friendship;
        if (friendship?.status == 'accepted') {
          return OutlinedButton.icon(
            onPressed: _busy
                ? null
                : () async {
                    final accountName = connection?.account.accountName ?? '';
                    if (!await _confirmFriendRemoval(context, accountName) ||
                        !mounted) {
                      return;
                    }
                    await _run(() => DriftToSupabase.removeFriend(
                          accountId: accountId,
                          friendAccountId: widget.accountId,
                        ));
                  },
            icon: const Icon(Icons.people_outline),
            label: Text(l.friends),
          );
        }
        if (friendship?.status == 'pending' &&
            friendship?.requestedBy == widget.accountId) {
          return FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: _busy
                ? null
                : () => _run(() => DriftToSupabase.respondToFriendRequest(
                      accountId: accountId,
                      requesterAccountId: widget.accountId,
                      accept: true,
                    )),
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(l.acceptInvitation),
          );
        }
        if (friendship?.status == 'pending') {
          return OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.schedule_outlined),
            label: Text(l.friendRequestSent),
          );
        }
        return OutlinedButton.icon(
          onPressed: _busy
              ? null
              : () => _run(() => DriftToSupabase.sendFriendRequest(
                    accountId: accountId,
                    friendAccountId: widget.accountId,
                  )),
          icon: const Icon(Icons.person_add_alt_1),
          label: Text(l.addFriend),
        );
      },
    );
  }
}

class _FriendsSection extends StatefulWidget {
  const _FriendsSection({required this.accountId});

  final int accountId;

  @override
  State<_FriendsSection> createState() => _FriendsSectionState();
}

class _FriendsSectionState extends State<_FriendsSection> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      leading: const Icon(Icons.people_outline),
      title: Text(l.friends),
      children: [
        StreamBuilder<List<FriendConnection>>(
          stream: Singleton()
              .getDatabase()
              .watchFriendConnections(widget.accountId),
          builder: (context, snapshot) {
            final connections = snapshot.data ?? const <FriendConnection>[];
            final incoming = connections
                .where((item) =>
                    item.friendship.status == 'pending' &&
                    item.friendship.requestedBy != widget.accountId)
                .toList();
            final friends = connections
                .where((item) => item.friendship.status == 'accepted')
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (incoming.isNotEmpty) ...[
                  Text(l.friendRequests,
                      style: Theme.of(context).textTheme.titleSmall),
                  ...incoming.map((connection) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: AccountAvatar(account: connection.account),
                        title: Text(connection.account.accountName),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              tooltip: l.declineInvitation,
                              onPressed: _busy
                                  ? null
                                  : () => _run(() =>
                                      DriftToSupabase.respondToFriendRequest(
                                        accountId: widget.accountId,
                                        requesterAccountId:
                                            connection.account.id,
                                        accept: false,
                                      )),
                              icon: const Icon(Icons.close),
                            ),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              tooltip: l.acceptInvitation,
                              onPressed: _busy
                                  ? null
                                  : () => _run(() =>
                                      DriftToSupabase.respondToFriendRequest(
                                        accountId: widget.accountId,
                                        requesterAccountId:
                                            connection.account.id,
                                        accept: true,
                                      )),
                              icon: const Icon(Icons.check),
                            ),
                          ],
                        ),
                      )),
                ],
                if (friends.isEmpty && incoming.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l.noFriends),
                  )
                else
                  ...friends.map((connection) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: AccountAvatar(account: connection.account),
                        title: Text(connection.account.accountName),
                        onTap: () => Navigator.of(context).push(
                          appPageRoute(
                            builder: (_) =>
                                AccountPage(accountId: connection.account.id),
                            fullScreenSwipeBack: true,
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: l.removeFriend,
                          onPressed: _busy
                              ? null
                              : () async {
                                  if (!await _confirmFriendRemoval(
                                        context,
                                        connection.account.accountName,
                                      ) ||
                                      !mounted) {
                                    return;
                                  }
                                  await _run(
                                    () => DriftToSupabase.removeFriend(
                                      accountId: widget.accountId,
                                      friendAccountId: connection.account.id,
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.person_remove_outlined),
                        ),
                      )),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.accountId,
    required this.changingFollow,
    required this.onFollowChanged,
  });

  final int accountId;
  final bool changingFollow;
  final ValueChanged<bool> onFollowChanged;

  @override
  Widget build(BuildContext context) {
    final currentAccountId = currentAccount;
    if (currentAccountId == null) return const SizedBox.shrink();
    final l = Languages.of(context)!;
    return StreamBuilder<List<AccountFollow>>(
      stream: Singleton().getDatabase().watchFollow(
            followerAccountId: currentAccountId,
            followedAccountId: accountId,
          ),
      builder: (context, followSnapshot) {
        final isFollowing = followSnapshot.data?.isNotEmpty == true;
        return FutureBuilder<bool>(
          future: RecipePermissions.canModifyContent(),
          builder: (context, permissionSnapshot) {
            return FilledButton.icon(
              onPressed: permissionSnapshot.data == true && !changingFollow
                  ? () => onFollowChanged(isFollowing)
                  : null,
              icon: changingFollow
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(isFollowing ? Icons.person_remove : Icons.person_add),
              label: Text(isFollowing ? l.following : l.follow),
            );
          },
        );
      },
    );
  }
}

class _CreatedRecipeList extends StatelessWidget {
  const _CreatedRecipeList({
    required this.accountId,
    required this.onRecipeSelected,
  });

  final int accountId;
  final ValueChanged<Recipe> onRecipeSelected;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return StreamBuilder<List<Recipe>>(
      stream: Singleton().getDatabase().watchRecipesByCreator(accountId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final recipes = snapshot.data!;
        if (recipes.isEmpty) return Center(child: Text(l.noRecipesYet));
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: recipes.length,
          itemBuilder: (context, index) => ListItem(
            key: ValueKey('account-recipe-${recipes[index].id}'),
            recipe: recipes[index],
            itemSelectedCallback: onRecipeSelected,
          ),
        );
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.accountId,
    required this.onRecipeSelected,
  });

  final int accountId;
  final ValueChanged<Recipe> onRecipeSelected;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return StreamBuilder<List<RecipeWithCount>>(
      stream: Singleton().getDatabase().getAccountHistoryAsRecipes(accountId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final recipes = snapshot.data!;
        if (recipes.isEmpty) {
          return Center(child: Text(l.noHistoryAvailable));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: recipes.length,
          itemBuilder: (context, index) => ListItem(
            key: ValueKey('account-history-${recipes[index].recipe.id}'),
            recipe: recipes[index].recipe,
            itemSelectedCallback: onRecipeSelected,
          ),
        );
      },
    );
  }
}

class _EditAccountSheet extends StatefulWidget {
  const _EditAccountSheet({required this.account});

  final Account account;

  @override
  State<_EditAccountSheet> createState() => _EditAccountSheetState();
}

class _EditAccountSheetState extends State<_EditAccountSheet> {
  late final TextEditingController _bioController;
  Uint8List? _imageBytes;
  String? _imageName;
  bool _removeImage = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.account.bio ?? '');
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1600,
    );
    if (image == null || !mounted) return;
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
      _imageName = image.name;
      _removeImage = false;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final l = Languages.of(context)!;
    setState(() => _saving = true);
    String? uploadedImageUrl;
    var profileSaved = false;
    try {
      String? imageUrl = _removeImage ? null : widget.account.profileImage;
      if (_imageBytes != null && _imageName != null) {
        imageUrl = await DriftToSupabase.uploadAccountImage(
          accountId: widget.account.id,
          bytes: _imageBytes!,
          fileName: _imageName!,
        );
        uploadedImageUrl = imageUrl;
      }
      await DriftToSupabase.updateAccountProfile(
        accountId: widget.account.id,
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        profileImage: imageUrl,
      );
      profileSaved = true;
      if (widget.account.profileImage != imageUrl) {
        await DriftToSupabase.tryDeleteUnreferencedAccountImage(
          widget.account.profileImage,
        );
      }
      await DriftToSupabase.tryCleanupOrphanedImages(
        accountId: widget.account.id,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!profileSaved && uploadedImageUrl != null) {
        await DriftToSupabase.tryDeleteUnreferencedAccountImage(
          uploadedImageUrl,
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.couldNotUpdateAccount}: $error')),
      );
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final existingImage = widget.account.profileImage?.trim();
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.editAccount,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l.close,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 52,
                foregroundImage: _imageBytes != null
                    ? MemoryImage(_imageBytes!)
                    : (!_removeImage && existingImage?.isNotEmpty == true
                        ? NetworkImage(existingImage!)
                        : null) as ImageProvider<Object>?,
                child: Text(
                  widget.account.accountName.characters.first.toUpperCase(),
                  style: const TextStyle(fontSize: 34),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _saving ? null : _pickImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l.chooseAccountImage),
                ),
                if (_imageBytes != null ||
                    (!_removeImage && existingImage?.isNotEmpty == true))
                  IconButton(
                    onPressed: _saving
                        ? null
                        : () => setState(() {
                              _imageBytes = null;
                              _imageName = null;
                              _removeImage = true;
                            }),
                    tooltip: l.removeImage,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: widget.account.accountName,
              enabled: false,
              decoration: InputDecoration(
                labelText: l.accountName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _bioController,
              maxLength: 240,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: l.bio,
                hintText: l.bioHint,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(l.saveChanges),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
