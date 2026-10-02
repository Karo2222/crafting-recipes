import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/device_info.dart';
import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/key_value.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/realtime.dart';
import 'package:craftingrecipes/helpers/push_notifications.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:craftingrecipes/objects/scanner.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/account_view.dart';
import 'package:craftingrecipes/views/code_scanner.dart';
import 'package:craftingrecipes/views/chat_view.dart';
import 'package:craftingrecipes/views/recipe_view.dart';
import 'package:craftingrecipes/views/home_view.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:craftingrecipes/views/my_comments_view.dart';
import 'package:craftingrecipes/views/syncing_status.dart';
import 'package:craftingrecipes/views/shopping_lists_view.dart';
import 'package:craftingrecipes/views/meal_plan_view.dart';
import 'package:craftingrecipes/widgets/shared_access_dialog.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class SecondHomePage extends StatefulWidget {
  const SecondHomePage({super.key});

  @override
  State<SecondHomePage> createState() => _SecondHomePageState();
}

class _SecondHomePageState extends State<SecondHomePage>
    with SingleTickerProviderStateMixin {
  final MenuController _profileMenuController = MenuController();
  final GlobalKey<NavigatorPageState> _recipesNavigatorPageKey =
      GlobalKey<NavigatorPageState>();
  final GlobalKey<NavigatorPageState> _accountNavigatorPageKey =
      GlobalKey<NavigatorPageState>();
  final GlobalKey<NavigatorPageState> _shoppingNavigatorPageKey =
      GlobalKey<NavigatorPageState>();
  final GlobalKey<NavigatorPageState> _mealPlanNavigatorPageKey =
      GlobalKey<NavigatorPageState>();
  final GlobalKey<NavigatorPageState> _chatNavigatorPageKey =
      GlobalKey<NavigatorPageState>();
  final GlobalKey<ChatViewState> _chatViewKey = GlobalKey<ChatViewState>();
  final GlobalKey<ShoppingListsViewState> _shoppingListsViewKey =
      GlobalKey<ShoppingListsViewState>();
  Account? account;
  String? accountRoleName;
  bool isAdmin = false;
  List<Map<String, dynamic>> profiles = [];
  List<Role> roles = [];
  int _pageIndex = 0;
  int _lastBottomPageIndex = 0;
  StreamSubscription<dynamic>? _openRequestSubscription;
  BuildContext? _openedRecipeContext;
  StreamSubscription? profileSubscription;
  StreamSubscription? accountRoleSubscription;
  StreamSubscription<int>? unreadMessagesSubscription;
  StreamSubscription<List<SharedResourceInvitation>>?
      mealPlanInvitationSubscription;
  StreamSubscription<List<SharedResourceInvitation>>?
      shoppingListInvitationSubscription;
  int unreadMessageCount = 0;
  List<SharedResourceInvitation> mealPlanInvitations = const [];
  List<SharedResourceInvitation> shoppingListInvitations = const [];
  String? scannerResponse;
  bool scanning = false;
  late final ValueNotifier<SyncUploadIssue?> _syncUploadIssueNotifier;
  String? _lastShownSyncUploadIssue;
  bool _handlingPushNavigation = false;

  @override
  void initState() {
    super.initState();
    _syncUploadIssueNotifier = Singleton().getSyncUploadIssue();
    _syncUploadIssueNotifier.addListener(_showSyncUploadIssue);
    PushNotifications.navigationTarget.addListener(_onPushNavigationTarget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSyncUploadIssue());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _onPushNavigationTarget(),
    );
    getAccounts();
    getRoles();
    getProfiles();
    _watchCachedIdentity();
    _watchUnreadMessages();
    _watchSharedInvitations();
    _listenForOpenRequests();
    final accountId = currentAccount;
    if (accountId != null) {
      unawaited(
        DriftToSupabase.tryCleanupOrphanedImages(accountId: accountId),
      );
    }
  }

  void _showSyncUploadIssue() {
    final issue = _syncUploadIssueNotifier.value;
    if (!mounted ||
        issue == null ||
        issue.fingerprint == _lastShownSyncUploadIssue) {
      return;
    }
    _lastShownSyncUploadIssue = issue.fingerprint;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l = Languages.of(context)!;
      final change = l.syncMutationLabel(issue.mutationType);
      final snackForeground = Theme.of(context).colorScheme.onInverseSurface;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.cloud_off_outlined, color: snackForeground),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.syncUploadFailed(change),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      issue.reason,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onPushNavigationTarget() {
    unawaited(_handlePushNavigationTarget());
  }

  Future<void> _handlePushNavigationTarget() async {
    final target = PushNotifications.navigationTarget.value;
    if (!mounted ||
        currentAccount == null ||
        target == null ||
        _handlingPushNavigation) {
      return;
    }
    _handlingPushNavigation = true;
    try {
      switch (target.type) {
        case PushNavigationType.chat:
          final friendAccountId = target.actorAccountId;
          if (friendAccountId == null) break;
          if (_pageIndex != 3) {
            setState(() {
              _lastBottomPageIndex = 3;
              _pageIndex = 3;
            });
            await WidgetsBinding.instance.endOfFrame;
          }
          await _chatViewKey.currentState
              ?.openConversationWithAccount(friendAccountId);
        case PushNavigationType.friendRequests:
          await _openAccountSearch();
        case PushNavigationType.sharedInvitations:
          await _openInvitationInbox();
      }
      PushNotifications.consumeNavigationTarget(target);
    } finally {
      _handlingPushNavigation = false;
    }
  }

  Future getAccounts() async {
    if (currentAccount == null) return;
    var result =
        await Singleton().getDatabase().getAccountById(currentAccount!);
    var selectedAccount = result.firstOrNull;
    var role = selectedAccount != null
        ? await Singleton().getDatabase().getRoleById(selectedAccount.roleId)
        : <Role>[];
    String? refreshedAccountRoleName;
    try {
      refreshedAccountRoleName =
          await SupabaseToDrift.getAccountRoleName(currentAccount!);
    } catch (e) {
      logger.w("Could not refresh account role: $e");
    }
    if (!mounted) return;
    setState(() {
      account = selectedAccount;
      accountRoleName = refreshedAccountRoleName ?? role.firstOrNull?.name;
      isAdmin = accountRoleName == RecipePermissions.admin;
    });
  }

  bool get canCreateRecipe {
    return RecipePermissions.rolesCanCreateRecipe(
      accountRoleName: accountRoleName,
      profileRoleName: selectedProfile?[Const.roleName.key]?.toString(),
    );
  }

  Future<void> getProfiles() async {
    final accountId = await KeyValue.getCurrentAccount() ?? currentAccount;
    if (accountId == null) return;
    final result = await _loadProfilesForAccount(accountId);
    await _applyProfiles(result);
  }

  void _watchCachedIdentity() {
    final accountId = currentAccount;
    if (accountId == null) return;
    final database = Singleton().getDatabase();
    profileSubscription = database
        .watchProfilesForAccount(accountId)
        .listen(_applyProfiles, onError: (error, stackTrace) {
      logger.w('Could not watch cached profiles: $error');
    });
    accountRoleSubscription =
        database.watchAccountRoleName(accountId).listen((roleName) {
      if (!mounted) return;
      setState(() {
        accountRoleName = roleName ?? RecipePermissions.viewer;
        isAdmin = accountRoleName == RecipePermissions.admin;
      });
    }, onError: (error, stackTrace) {
      logger.w('Could not watch cached account role: $error');
    });
  }

  void _watchUnreadMessages() {
    final accountId = currentAccount;
    if (accountId == null) return;
    unreadMessagesSubscription = Singleton()
        .getDatabase()
        .watchUnreadChatMessageCount(accountId)
        .listen((count) {
      if (!mounted) return;
      setState(() => unreadMessageCount = count);
    });
  }

  void _watchSharedInvitations() {
    final accountId = currentAccount;
    if (accountId == null) return;
    final database = Singleton().getDatabase();
    mealPlanInvitationSubscription = database
        .watchPendingMealPlanInvitations(accountId)
        .listen((invitations) {
      if (!mounted) return;
      setState(() => mealPlanInvitations = invitations);
    });
    shoppingListInvitationSubscription = database
        .watchPendingShoppingListInvitations(accountId)
        .listen((invitations) {
      if (!mounted) return;
      setState(() => shoppingListInvitations = invitations);
    });
  }

  Future<void> _openInvitationInbox() async {
    final accountId = currentAccount;
    if (accountId == null) return;
    await showDialog<void>(
      context: context,
      builder: (context) => _SharedInvitationInbox(accountId: accountId),
    );
  }

  Future<void> _applyProfiles(List<Map<String, dynamic>> result) async {
    var nextProfileId = currentProfile;
    final currentStillExists = result.any(
      (profile) => profile[Const.id.key] == nextProfileId,
    );
    if (!currentStillExists) {
      final mainProfile = result.where(
        (profile) => profile[Const.name.key] == 'main',
      );
      nextProfileId = mainProfile.firstOrNull?[Const.id.key] ??
          result.firstOrNull?[Const.id.key];
      currentProfile = nextProfileId;
      if (nextProfileId == null) {
        await KeyValue.clearCurrentProfile();
      } else {
        await KeyValue.setCurrentProfile(nextProfileId);
      }
    }
    if (!mounted) return;
    setState(() {
      profiles = result;
    });
  }

  Future<List<Map<String, dynamic>>> _loadProfilesForAccount(
      int accountId) async {
    return SupabaseToDrift.getProfilesForAccount(accountId);
  }

  Future<void> getRoles() async {
    final result = await Singleton().getDatabase().allRoleEntries;
    if (!mounted) return;
    setState(() {
      roles = result;
    });
  }

  Future<void> changeProfile(int profileId) async {
    await KeyValue.setCurrentProfile(profileId);
    currentProfile = profileId;
    if (mounted) {
      setState(() {});
    }
  }

  Map<String, dynamic>? get selectedProfile {
    return profiles
        .where((profile) => profile[Const.id.key] == currentProfile)
        .firstOrNull;
  }

  bool get isReadOnlySession {
    if (!RecipePermissions.accountRoleCanModify(accountRoleName)) return true;
    final profile = selectedProfile;
    return !RecipePermissions.profileRoleCanModify(
      profile?[Const.roleName.key]?.toString(),
    );
  }

  Role? get viewerRole {
    return roles.where((role) => role.name == "viewer").firstOrNull;
  }

  Role? get editorRole {
    return roles.where((role) => role.name == "editor").firstOrNull;
  }

  Future<int?> _defaultProfileRoleId() async {
    final localRole = editorRole ?? viewerRole ?? roles.firstOrNull;
    if (localRole != null) return localRole.id;

    try {
      return await DriftToSupabase.getRoleIdByName("editor");
    } catch (_) {
      try {
        return await DriftToSupabase.getRoleIdByName("viewer");
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> _refreshProfiles() async {
    final accountId = await KeyValue.getCurrentAccount() ?? currentAccount;
    if (accountId == null) return;
    final result = await _loadProfilesForAccount(accountId);
    await _applyProfiles(result);
  }

  Future<void> _setProfileRole({
    required Map<String, dynamic> profile,
    required int roleId,
  }) async {
    final l = Languages.of(context)!;
    final accountId = await KeyValue.getCurrentAccount() ?? currentAccount;
    if (accountId == null) return;
    try {
      await DriftToSupabase.updateProfileRole(
        profileId: profile[Const.id.key],
        roleId: roleId,
        accountId: accountId,
      );
      await _refreshProfiles();
    } catch (error) {
      logger.e('Could not update profile permission: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotUpdateProfilePermission)),
      );
    }
  }

  Future<void> _confirmDeleteProfile(
    Map<String, dynamic> profile,
  ) async {
    final l = Languages.of(context)!;
    if (profiles.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.lastProfileCannotBeDeleted)),
      );
      return;
    }

    final profileId = profile[Const.id.key] as int;
    final profileName = profile[Const.name.key].toString();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteProfile),
        content: Text(l.confirmDeleteProfile(profileName)),
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

    final accountId = await KeyValue.getCurrentAccount() ?? currentAccount;
    if (accountId == null) return;
    final fallbackProfile = profiles.firstWhere(
      (candidate) => candidate[Const.id.key] != profileId,
    );

    try {
      await DriftToSupabase.deleteProfileForAccount(
        profileId: profileId,
        accountId: accountId,
      );
      if (currentProfile == profileId) {
        currentProfile = fallbackProfile[Const.id.key] as int;
        await KeyValue.setCurrentProfile(currentProfile!);
      }
      await _refreshProfiles();
    } catch (error) {
      logger.e('Could not delete profile: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotDeleteProfile)),
      );
    }
  }

  Widget _profileManagementControl() {
    final l = Languages.of(context)!;
    final theme = Theme.of(context);
    final profile = selectedProfile;
    final profileName = profile?[Const.name.key]?.toString() ?? l.profiles;
    final roleName = profile?[Const.roleName.key]?.toString();
    final roleLabel = roleName == null ? null : l.roleLabel(roleName);
    final initial = profileName.trim().isEmpty
        ? '?'
        : profileName.trim().characters.first.toUpperCase();
    return MenuAnchor(
      controller: _profileMenuController,
      alignmentOffset: const Offset(0, 8),
      style: MenuStyle(
        backgroundColor:
            WidgetStatePropertyAll(theme.colorScheme.surfaceContainer),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      menuChildren: [
        for (final profile in profiles)
          SizedBox(
            width: 328,
            child: Row(
              children: [
                SizedBox(
                  width: 146,
                  child: MenuItemButton(
                    leadingIcon: Icon(
                      profile[Const.id.key] == currentProfile
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 18,
                    ),
                    onPressed: () => changeProfile(profile[Const.id.key]),
                    child: Text(
                      profile[Const.name.key].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  width: 132,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: roles.any(
                        (role) => role.id == profile[Const.roleId.key],
                      )
                          ? profile[Const.roleId.key] as int
                          : null,
                      isExpanded: true,
                      icon: const Icon(Icons.expand_more, size: 18),
                      items: roles
                          .map(
                            (role) => DropdownMenuItem<int>(
                              value: role.id,
                              child: Text(
                                l.roleLabel(role.name),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (roleId) {
                        if (roleId == null ||
                            roleId == profile[Const.roleId.key]) {
                          return;
                        }
                        _profileMenuController.close();
                        _setProfileRole(profile: profile, roleId: roleId);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: IconButton(
                    tooltip: profiles.length <= 1
                        ? l.lastProfileCannotBeDeleted
                        : l.deleteProfile,
                    onPressed: profiles.length <= 1
                        ? null
                        : () {
                            _profileMenuController.close();
                            _confirmDeleteProfile(profile);
                          },
                    icon: const Icon(Icons.delete_outline, size: 20),
                  ),
                ),
              ],
            ),
          ),
        const Divider(height: 1),
        MenuItemButton(
          leadingIcon: const Icon(Icons.add),
          onPressed: () async {
            await _showCreateProfileDialog();
            await _refreshProfiles();
          },
          child: SizedBox(width: 278, child: Text(l.createProfile)),
        ),
      ],
      builder: (context, controller, child) {
        return Tooltip(
          message: l.profiles,
          child: Semantics(
            button: true,
            label: l.profiles,
            child: InkWell(
              onTap: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                      child: Text(
                        initial,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (roleLabel != null)
                            Text(
                              roleLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      controller.isOpen ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openAccountPage() {
    _accountNavigatorPageKey.currentState?.returnToRoot();
    if (_pageIndex != 4) {
      setState(() {
        _pageIndex = 4;
      });
    }
  }

  Future<void> _openAccountSearch() async {
    final accountId = currentAccount;
    if (accountId == null || !mounted) return;
    await Navigator.of(context).push(
      appPageRoute(
        builder: (_) => AccountSearchPage(currentAccountId: accountId),
        fullScreenSwipeBack: true,
      ),
    );
  }

  Widget _accountNavigationButton() {
    final l = Languages.of(context)!;
    final theme = Theme.of(context);
    final currentAccountData = account;
    final accountName = currentAccountData?.accountName ?? l.account;

    return Tooltip(
      message: l.account,
      child: Semantics(
        button: true,
        label: l.account,
        child: InkWell(
          onTap: _openAccountPage,
          borderRadius: BorderRadius.circular(6),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentAccountData != null)
                    AccountAvatar(account: currentAccountData, radius: 17)
                  else
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                      child: const Icon(Icons.person_outline, size: 19),
                    ),
                  const SizedBox(width: 9),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accountName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l.account,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateProfileDialog() async {
    final l = Languages.of(context)!;
    var profileName = "";
    var selectedRoleId =
        editorRole?.id ?? viewerRole?.id ?? roles.firstOrNull?.id;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l.createProfile),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    onChanged: (value) {
                      profileName = value;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l.profileName,
                    ),
                  ),
                  if (isAdmin && roles.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedRoleId,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l.profilePermission,
                      ),
                      items: roles
                          .map(
                            (role) => DropdownMenuItem<int>(
                              value: role.id,
                              child: Text(l.roleLabel(role.name)),
                            ),
                          )
                          .toList(),
                      onChanged: (roleId) {
                        setDialogState(() {
                          selectedRoleId = roleId;
                        });
                      },
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l.cancel),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(dialogContext);
                    final navigator = Navigator.of(dialogContext);
                    final accountId =
                        await KeyValue.getCurrentAccount() ?? currentAccount;
                    final trimmedProfileName = profileName.trim();
                    final roleId = isAdmin
                        ? selectedRoleId
                        : await _defaultProfileRoleId();

                    if (accountId == null ||
                        trimmedProfileName.isEmpty ||
                        roleId == null) {
                      if (!dialogContext.mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l.enterProfileName),
                        ),
                      );
                      return;
                    }

                    try {
                      final profileId =
                          await DriftToSupabase.createProfileForAccount(
                        accountId: accountId,
                        name: trimmedProfileName,
                        roleId: roleId,
                      );
                      await changeProfile(profileId);
                      await _refreshProfiles();
                      if (!dialogContext.mounted) return;
                      navigator.pop();
                    } catch (e) {
                      if (!dialogContext.mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l.couldNotCreateProfile),
                        ),
                      );
                      logger.e("Could not create profile: $e");
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l.create),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Another device can ask this one to open a recipe by marking a history
  /// entry as "open". The request arrives via realtime; the recipe is then
  /// shown full screen and replaces a recipe opened the same way before.
  void _listenForOpenRequests() {
    _openRequestSubscription = Realtime.getHistoryStream().listen(
      (_) => _openRequestedRecipe(),
      onError: (Object error) {
        final text = error.toString();
        if (text.isNotEmpty && text != '{}') {
          logger.w('History stream error: $text');
        }
      },
    );
  }

  Future<void> _openRequestedRecipe() async {
    await Realtime.sync();
    final accountId = currentAccount;
    if (accountId == null) return;

    final db = Singleton().getDatabase();
    final requested = await db.getRecipeToOpen(accountId);
    if (requested.isEmpty) return;
    final recipe = requested.first;
    final history = await db.getAccountHistory(accountId, recipe.id);

    final previous = _openedRecipeContext;
    if (previous != null && previous.mounted) Navigator.of(previous).pop();
    _openedRecipeContext = null;
    if (!mounted) return;

    await Navigator.of(context).push(
      appPageRoute<bool>(
        fullscreenDialog: true,
        builder: (routeContext) {
          _openedRecipeContext = routeContext;
          return RecipeView(
            recipe: recipe,
            open: true,
            additionalData:
                history.isEmpty ? null : history.first.additionalData,
          );
        },
      ),
    );
    _openedRecipeContext = null;
  }

  @override
  void dispose() {
    _syncUploadIssueNotifier.removeListener(_showSyncUploadIssue);
    PushNotifications.navigationTarget.removeListener(
      _onPushNavigationTarget,
    );
    _openRequestSubscription?.cancel();
    profileSubscription?.cancel();
    accountRoleSubscription?.cancel();
    unreadMessagesSubscription?.cancel();
    mealPlanInvitationSubscription?.cancel();
    shoppingListInvitationSubscription?.cancel();
    super.dispose();
  }

  void _onSyncButtonClick() async {
    final progressPage = Navigator.of(context).push(
      appPageRoute(
        builder: (context) => const SyncingStatus(),
        fullScreenSwipeBack: true,
      ),
    );
    unawaited(SupabaseToDrift.sync());
    await progressPage;
  }

  bool get _scannerAvailable =>
      kIsWeb || DeviceInfo.isDevice() || DeviceInfo.isMacOS();

  List<_HomeToolbarAction> get _availableToolbarActions => [
        if (_scannerAvailable) _HomeToolbarAction.scanner,
        _HomeToolbarAction.comments,
        if (isAdmin && !isReadOnlySession) _HomeToolbarAction.database,
      ];

  IconData _toolbarActionIcon(_HomeToolbarAction action) {
    return switch (action) {
      _HomeToolbarAction.scanner => Icons.qr_code_scanner,
      _HomeToolbarAction.comments => Icons.comment_outlined,
      _HomeToolbarAction.database => Icons.storage_outlined,
    };
  }

  String _toolbarActionLabel(_HomeToolbarAction action, Languages l) {
    return switch (action) {
      _HomeToolbarAction.scanner => l.scanner,
      _HomeToolbarAction.comments => l.myComments,
      _HomeToolbarAction.database => l.database,
    };
  }

  Future<void> _runToolbarAction(
    _HomeToolbarAction action,
    ScanModel scanModel,
    Languages l,
  ) async {
    switch (action) {
      case _HomeToolbarAction.scanner:
        await _openScanner(scanModel, l);
      case _HomeToolbarAction.comments:
        if (!mounted) return;
        await Navigator.of(context).push(
          appPageRoute(
            builder: (context) => const MyCommentsView(),
            fullScreenSwipeBack: true,
          ),
        );
      case _HomeToolbarAction.database:
        if (!mounted) return;
        final db = Singleton().getDatabase();
        await Navigator.of(context).push(
          appPageRoute(builder: (context) => DriftDbViewer(db)),
        );
    }
  }

  Future<void> _openScanner(ScanModel scanModel, Languages l) async {
    scannerResponse = await Navigator.of(context).push(
      appPageRoute(
        builder: (context) => CodeScanner(
          onDetect: (capture) {
            if (scanning) return;
            scanning = true;
            final List<Barcode> barcodes = capture.barcodes;
            final barcode = barcodes.firstOrNull;
            if (barcode == null) {
              logger.w('No barcodes found.');
              return;
            }

            debugPrint('Barcode found! ${barcode.rawValue}');
            try {
              final response = barcode.rawValue ?? "";
              if (mounted) {
                Navigator.pop(context, response);
              }
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.invalidScannedCode)),
              );
              Navigator.pop(context);
            }
          },
        ),
        fullScreenSwipeBack: true,
      ),
    );
    if (!mounted) return;
    if (scannerResponse != null) {
      scanModel.updateText(scannerResponse!);
    }
    setState(() {});
    Future.delayed(const Duration(seconds: 3), () {
      scanning = false;
    });
  }

  Widget _buildSyncAction(Languages l) {
    return ValueListenableBuilder(
      valueListenable: Singleton().getValueNotifierSyncStatus(),
      builder: (context, syncStatus, child) {
        if (syncStatus == SyncStatus.runningSync) {
          return IconButton(
            tooltip: l.syncProgress,
            onPressed: _onSyncButtonClick,
            icon: const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          );
        }

        final pending = syncStatus == SyncStatus.pendingSync;
        return IconButton(
          tooltip: pending ? l.pendingSync : l.sync,
          onPressed: _onSyncButtonClick,
          icon: Badge(
            isLabelVisible: pending,
            smallSize: 8,
            backgroundColor: Theme.of(context).colorScheme.error,
            child: const Icon(Icons.sync),
          ),
        );
      },
    );
  }

  List<Widget> _buildToolbarActions(
    Languages l,
    ScanModel scanModel,
    bool showAllActions,
  ) {
    final actions = _availableToolbarActions;
    final invitationCount =
        mealPlanInvitations.length + shoppingListInvitations.length;
    return [
      IconButton(
        tooltip: l.invitations,
        onPressed: _openInvitationInbox,
        icon: Badge(
          isLabelVisible: invitationCount > 0,
          label: Text(invitationCount > 99 ? '99+' : '$invitationCount'),
          child: const Icon(Icons.mail_outline),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.person_search_outlined),
        tooltip: l.findPeople,
        onPressed: _openAccountSearch,
      ),
      if (showAllActions)
        for (final action in actions)
          IconButton(
            icon: Icon(_toolbarActionIcon(action)),
            tooltip: _toolbarActionLabel(action, l),
            onPressed: () => _runToolbarAction(action, scanModel, l),
          )
      else
        MenuAnchor(
          alignmentOffset: const Offset(0, 8),
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surfaceContainer,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          menuChildren: actions
              .map(
                (action) => MenuItemButton(
                  leadingIcon: Icon(_toolbarActionIcon(action), size: 20),
                  onPressed: () => _runToolbarAction(action, scanModel, l),
                  child: Text(_toolbarActionLabel(action, l)),
                ),
              )
              .toList(),
          builder: (context, controller, child) {
            return IconButton(
              tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
              icon: const Icon(Icons.more_vert),
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            );
          },
        ),
      _buildSyncAction(l),
      const SizedBox(width: 6),
    ];
  }

  Widget _chatNavigationIcon({required bool active}) => Badge(
        isLabelVisible: unreadMessageCount > 0,
        label: Text(unreadMessageCount > 99 ? '99+' : '$unreadMessageCount'),
        child: Icon(
          active ? Icons.chat_bubble : Icons.chat_bubble_outline,
        ),
      );

  NavigatorPageState? get _activeNavigatorState => switch (_pageIndex) {
        0 => _recipesNavigatorPageKey.currentState,
        1 => _mealPlanNavigatorPageKey.currentState,
        2 => _shoppingNavigatorPageKey.currentState,
        3 => _chatNavigatorPageKey.currentState,
        4 => _accountNavigatorPageKey.currentState,
        _ => null,
      };

  void _nestedNavigationChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _openShoppingListFromChat(int shoppingListId) async {
    if (!mounted) return;
    setState(() {
      _lastBottomPageIndex = 2;
      _pageIndex = 2;
    });
    await WidgetsBinding.instance.endOfFrame;
    final opened = await _shoppingListsViewKey.currentState
            ?.openShoppingList(shoppingListId) ??
        false;
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Languages.of(context)!.shoppingListUnavailable),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final scanModel = Provider.of<ScanModel>(context, listen: false);
    final theme = Theme.of(context);
    final showAllToolbarActions = MediaQuery.sizeOf(context).width >= 720;
    return RootTabBackScope(
      isOnRootTab: _pageIndex == 0,
      currentTabCanPop: _activeNavigatorState?.canPop == true,
      onPopCurrentTab: () => _activeNavigatorState?.popCurrentRoute(),
      onReturnToRootTab: () {
        if (!mounted || _pageIndex == 0) return;
        setState(() {
          _lastBottomPageIndex = 0;
          _pageIndex = 0;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 64,
          backgroundColor: theme.scaffoldBackgroundColor,
          foregroundColor: theme.colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: _accountNavigationButton(),
          actions: _buildToolbarActions(
            l,
            scanModel,
            showAllToolbarActions,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant,
            ),
          ),
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _pageIndex,
            children: <Widget>[
              NavigatorPage(
                key: _recipesNavigatorPageKey,
                isActive: _pageIndex == 0,
                handlesSystemBack: false,
                onNavigationChanged: _nestedNavigationChanged,
                child: Home(
                  scanNotifier: scanModel,
                  canCreateRecipe: canCreateRecipe,
                ),
              ),
              NavigatorPage(
                key: _mealPlanNavigatorPageKey,
                isActive: _pageIndex == 1,
                handlesSystemBack: false,
                onNavigationChanged: _nestedNavigationChanged,
                child: const MealPlanView(),
              ),
              NavigatorPage(
                key: _shoppingNavigatorPageKey,
                isActive: _pageIndex == 2,
                handlesSystemBack: false,
                onNavigationChanged: _nestedNavigationChanged,
                child: ShoppingListsView(key: _shoppingListsViewKey),
              ),
              NavigatorPage(
                key: _chatNavigatorPageKey,
                isActive: _pageIndex == 3,
                handlesSystemBack: false,
                onNavigationChanged: _nestedNavigationChanged,
                child: ChatView(
                  key: _chatViewKey,
                  onOpenShoppingList: _openShoppingListFromChat,
                ),
              ),
              NavigatorPage(
                key: _accountNavigatorPageKey,
                isActive: _pageIndex == 4,
                handlesSystemBack: false,
                onNavigationChanged: _nestedNavigationChanged,
                child: AccountView(
                  accountId: currentAccount!,
                  profileManagement:
                      isAdmin ? _profileManagementControl() : null,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.folder),
              label: l.recipesTitle,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              activeIcon: const Icon(Icons.calendar_month),
              label: l.mealPlan,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              label: l.shoppingLists,
            ),
            BottomNavigationBarItem(
              icon: _chatNavigationIcon(active: false),
              activeIcon: _chatNavigationIcon(active: true),
              label: l.chat,
            ),
          ],
          currentIndex: _pageIndex <= 3 ? _pageIndex : _lastBottomPageIndex,
          onTap: (int index) {
            if (_pageIndex == index) {
              if (index == 0) {
                _recipesNavigatorPageKey.currentState?.returnToRoot();
              } else if (index == 1) {
                _mealPlanNavigatorPageKey.currentState?.returnToRoot();
              } else if (index == 2) {
                _shoppingNavigatorPageKey.currentState?.returnToRoot();
              } else if (index == 3) {
                _chatNavigatorPageKey.currentState?.returnToRoot();
              }
            }
            setState(
              () {
                _lastBottomPageIndex = index;
                _pageIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({
    super.key,
    required this.child,
    required this.isActive,
    this.handlesSystemBack = true,
    this.onNavigationChanged,
  });

  final Widget child;
  final bool isActive;
  final bool handlesSystemBack;
  final VoidCallback? onNavigationChanged;

  @override
  State<NavigatorPage> createState() => NavigatorPageState();
}

enum _HomeToolbarAction { scanner, comments, database }

class NavigatorPageState extends State<NavigatorPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final _NestedNavigatorObserver _navigatorObserver;
  bool _navigationNotificationScheduled = false;

  bool get canPop => _navigatorKey.currentState?.canPop() == true;

  @override
  void initState() {
    super.initState();
    _navigatorObserver = _NestedNavigatorObserver(
      onChanged: _scheduleNavigationNotification,
    );
  }

  void _scheduleNavigationNotification() {
    if (_navigationNotificationScheduled) return;
    _navigationNotificationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationNotificationScheduled = false;
      if (mounted) widget.onNavigationChanged?.call();
    });
  }

  bool popCurrentRoute() {
    final navigator = _navigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) return false;
    navigator.maybePop();
    return true;
  }

  void returnToRoot() {
    final navigator = _navigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) return;

    final topRoute = _navigatorObserver.topRoute;
    if (topRoute?.popDisposition == RoutePopDisposition.doNotPop) {
      navigator.maybePop();
      return;
    }
    navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator(
      key: _navigatorKey,
      observers: [_navigatorObserver],
      onGenerateRoute: (RouteSettings settings) {
        return appPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return widget.child;
            });
      },
    );
    if (!widget.handlesSystemBack) return navigator;
    return NavigatorPopHandler<Object?>(
      enabled: widget.isActive,
      onPopWithResult: (result) {
        if (!widget.isActive) return;
        final navigator = _navigatorKey.currentState;
        if (navigator?.canPop() == true) navigator!.pop(result);
      },
      child: navigator,
    );
  }
}

class _NestedNavigatorObserver extends NavigatorObserver {
  _NestedNavigatorObserver({required this.onChanged});

  final VoidCallback onChanged;
  Route<dynamic>? topRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    topRoute = route;
    onChanged();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    topRoute = previousRoute;
    onChanged();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (topRoute == route) {
      topRoute = previousRoute;
    }
    onChanged();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (topRoute == oldRoute) {
      topRoute = newRoute;
    }
    onChanged();
  }
}

class _SharedInvitationInbox extends StatefulWidget {
  const _SharedInvitationInbox({required this.accountId});

  final int accountId;

  @override
  State<_SharedInvitationInbox> createState() => _SharedInvitationInboxState();
}

class _SharedInvitationInboxState extends State<_SharedInvitationInbox> {
  late final Stream<List<SharedResourceInvitation>> _mealPlanInvitations;
  late final Stream<List<SharedResourceInvitation>> _shoppingListInvitations;
  final Set<String> _responding = {};

  @override
  void initState() {
    super.initState();
    final database = Singleton().getDatabase();
    _mealPlanInvitations =
        database.watchPendingMealPlanInvitations(widget.accountId);
    _shoppingListInvitations =
        database.watchPendingShoppingListInvitations(widget.accountId);
  }

  Future<void> _respond({
    required SharedResourceInvitation invitation,
    required bool mealPlan,
    required bool accept,
  }) async {
    final key = '${mealPlan ? 'meal' : 'shopping'}:${invitation.resourceId}';
    if (_responding.contains(key)) return;
    setState(() => _responding.add(key));
    try {
      if (mealPlan) {
        await DriftToSupabase.respondToMealPlanInvitation(
          accountId: widget.accountId,
          mealPlanId: invitation.resourceId,
          accept: accept,
        );
      } else {
        await DriftToSupabase.respondToShoppingListInvitation(
          accountId: widget.accountId,
          shoppingListId: invitation.resourceId,
          accept: accept,
        );
      }
    } catch (error, stackTrace) {
      logger.w(
        'Could not respond to shared-resource invitation',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Languages.of(context)!.somethingWentWrong)),
      );
    } finally {
      if (mounted) setState(() => _responding.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.mail_outline),
          const SizedBox(width: 10),
          Expanded(child: Text(l.invitations)),
        ],
      ),
      content: SizedBox(
        width: 560,
        child: StreamBuilder<List<SharedResourceInvitation>>(
          stream: _mealPlanInvitations,
          builder: (context, mealSnapshot) =>
              StreamBuilder<List<SharedResourceInvitation>>(
            stream: _shoppingListInvitations,
            builder: (context, shoppingSnapshot) {
              if ((!mealSnapshot.hasData || !shoppingSnapshot.hasData) &&
                  (mealSnapshot.connectionState == ConnectionState.waiting ||
                      shoppingSnapshot.connectionState ==
                          ConnectionState.waiting)) {
                return const Center(child: CircularProgressIndicator());
              }
              final mealInvitations = mealSnapshot.data ?? const [];
              final shoppingInvitations = shoppingSnapshot.data ?? const [];
              if (mealInvitations.isEmpty && shoppingInvitations.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l.noPendingInvitations,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * .65,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SharedInvitationsPanel(
                        title: l.mealPlan,
                        invitations: mealInvitations,
                        onAccept: (invitation) => unawaited(_respond(
                          invitation: invitation,
                          mealPlan: true,
                          accept: true,
                        )),
                        onDecline: (invitation) => unawaited(_respond(
                          invitation: invitation,
                          mealPlan: true,
                          accept: false,
                        )),
                      ),
                      if (mealInvitations.isNotEmpty &&
                          shoppingInvitations.isNotEmpty)
                        const SizedBox(height: 18),
                      SharedInvitationsPanel(
                        title: l.shoppingLists,
                        invitations: shoppingInvitations,
                        onAccept: (invitation) => unawaited(_respond(
                          invitation: invitation,
                          mealPlan: false,
                          accept: true,
                        )),
                        onDecline: (invitation) => unawaited(_respond(
                          invitation: invitation,
                          mealPlan: false,
                          accept: false,
                        )),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.close),
        ),
      ],
    );
  }
}
