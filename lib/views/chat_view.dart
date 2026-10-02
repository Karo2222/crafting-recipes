import 'dart:async';

import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/helpers/push_notifications.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/account_view.dart';
import 'package:craftingrecipes/views/recipe_view.dart';
import 'package:craftingrecipes/widgets/recipe_picker_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.onOpenShoppingList,
  });

  final Future<void> Function(int shoppingListId) onOpenShoppingList;

  @override
  State<ChatView> createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> {
  int? _accountId;
  Stream<List<ChatConversationWithAccount>>? _conversationsStream;
  Object? _lastConversationStreamError;

  @override
  void initState() {
    super.initState();
    _accountId = currentAccount;
    _createConversationsStream();
    unawaited(_refreshRemoteChats());
  }

  Future<void> _refreshRemoteChats() async {
    try {
      await SupabaseToDrift.refreshChatData(resetCursor: kIsWeb);
    } catch (error, stackTrace) {
      logger.w(
        'Could not refresh chats; cached messages remain available',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _createConversationsStream() {
    final accountId = _accountId;
    if (accountId == null) return;
    _conversationsStream =
        Singleton().getDatabase().watchChatConversations(accountId);
  }

  void _retryLoadingConversations() {
    setState(() {
      _lastConversationStreamError = null;
      _createConversationsStream();
    });
  }

  Future<void> openConversationWithAccount(int friendAccountId) async {
    if (friendAccountId == currentAccount ||
        PushNotifications.activeChatAccountId == friendAccountId) {
      return;
    }
    var friend =
        (await Singleton().getDatabase().getAccountById(friendAccountId))
            .firstOrNull;
    if (friend == null) {
      try {
        await SupabaseToDrift.refreshCurrentAccountRealtimeData();
        friend =
            (await Singleton().getDatabase().getAccountById(friendAccountId))
                .firstOrNull;
      } catch (error, stackTrace) {
        logger.w(
          'Could not refresh the notification chat account',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    final availableFriend = friend;
    if (!mounted || availableFriend == null) return;
    await Navigator.of(context).push(
      appPageRoute(
        builder: (_) => ChatConversationPage(
          friend: availableFriend,
          onOpenShoppingList: widget.onOpenShoppingList,
        ),
        fullScreenSwipeBack: true,
      ),
    );
  }

  Future<void> _startConversation(BuildContext context, int accountId) async {
    await SupabaseToDrift.waitForActiveSync();
    final database = Singleton().getDatabase();
    final friends = await database.getAcceptedFriendAccounts(accountId);
    if (!context.mounted) return;
    final friend = await showModalBottomSheet<Account>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _FriendChatPicker(friends: friends),
    );
    if (friend == null || !context.mounted) return;
    await Navigator.of(context).push(
      appPageRoute(
        builder: (_) => ChatConversationPage(
          friend: friend,
          onOpenShoppingList: widget.onOpenShoppingList,
        ),
        fullScreenSwipeBack: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final accountId = _accountId;
    final conversationsStream = _conversationsStream;
    if (accountId == null || conversationsStream == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l.conversations,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: l.newConversation,
                onPressed: () => _startConversation(context, accountId),
                icon: const Icon(Icons.edit_square),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ChatConversationWithAccount>>(
            stream: conversationsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                if (_lastConversationStreamError != snapshot.error) {
                  _lastConversationStreamError = snapshot.error;
                  logger.w(
                    'Could not load chat conversations',
                    error: snapshot.error,
                    stackTrace: snapshot.stackTrace,
                  );
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.couldNotLoadMessages,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _retryLoadingConversations,
                          icon: const Icon(Icons.refresh),
                          label: Text(l.tryAgain),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final conversations = snapshot.data!;
              if (conversations.isEmpty) {
                return _EmptyChats(
                  onStart: () => _startConversation(context, accountId),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: conversations.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = conversations[index];
                  return _ConversationTile(
                    key: ValueKey(
                      '${item.conversation.firstAccountId}:'
                      '${item.conversation.secondAccountId}',
                    ),
                    accountId: accountId,
                    item: item,
                    onOpenShoppingList: widget.onOpenShoppingList,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ConversationTile extends StatefulWidget {
  const _ConversationTile({
    super.key,
    required this.accountId,
    required this.item,
    required this.onOpenShoppingList,
  });

  final int accountId;
  final ChatConversationWithAccount item;
  final Future<void> Function(int shoppingListId) onOpenShoppingList;

  @override
  State<_ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<_ConversationTile> {
  late Stream<List<ChatMessage>> _latestMessageStream;
  late Stream<int> _unreadStream;

  @override
  void initState() {
    super.initState();
    _createStreams();
  }

  void _createStreams() {
    final database = Singleton().getDatabase();
    final conversation = widget.item.conversation;
    _latestMessageStream = database.watchLatestChatMessage(
      conversation.firstAccountId,
      conversation.secondAccountId,
    );
    _unreadStream = database.watchUnreadChatMessageCountForConversation(
      widget.accountId,
      conversation.firstAccountId,
      conversation.secondAccountId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return StreamBuilder<List<ChatMessage>>(
      stream: _latestMessageStream,
      builder: (context, messageSnapshot) {
        final latest = messageSnapshot.data?.firstOrNull;
        final preview = latest?.message?.trim();
        final hasShoppingList = latest?.shoppingListId != null ||
            latest?.shoppingListNameSnapshot?.trim().isNotEmpty == true;
        return StreamBuilder<int>(
          stream: _unreadStream,
          builder: (context, unreadSnapshot) {
            final unreadCount = unreadSnapshot.data ?? 0;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(_badgeCount(unreadCount)),
                child: AccountAvatar(account: widget.item.account),
              ),
              title: Text(
                widget.item.account.accountName,
                style: unreadCount > 0
                    ? const TextStyle(fontWeight: FontWeight.w700)
                    : null,
              ),
              subtitle: Text(
                preview?.isNotEmpty == true
                    ? preview!
                    : latest?.recipeId != null ||
                            latest?.recipeTitleSnapshot?.trim().isNotEmpty ==
                                true
                        ? l.sharedRecipe
                        : hasShoppingList
                            ? l.sharedShoppingList
                            : l.startChat,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: unreadCount > 0
                    ? const TextStyle(fontWeight: FontWeight.w600)
                    : null,
              ),
              trailing: latest == null
                  ? const Icon(Icons.chevron_right)
                  : Text(
                      DateFormat.Hm(l.languageCode)
                          .format(latest.createdAt.toLocal()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
              onTap: () => Navigator.of(context).push(
                appPageRoute(
                  builder: (_) => ChatConversationPage(
                    friend: widget.item.account,
                    onOpenShoppingList: widget.onOpenShoppingList,
                  ),
                  fullScreenSwipeBack: true,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyChats extends StatelessWidget {
  const _EmptyChats({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 52,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(l.noConversations),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.add_comment_outlined),
              label: Text(l.newConversation),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendChatPicker extends StatefulWidget {
  const _FriendChatPicker({required this.friends});

  final List<Account> friends;

  @override
  State<_FriendChatPicker> createState() => _FriendChatPickerState();
}

class _FriendChatPickerState extends State<_FriendChatPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final normalized = _query.trim().toLowerCase();
    final friends = widget.friends
        .where((friend) =>
            normalized.isEmpty ||
            friend.accountName.trim().toLowerCase().contains(normalized))
        .toList();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .62,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 8, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.newConversation,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: l.close,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (widget.friends.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l.searchFriends,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
          Expanded(
            child: widget.friends.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l.noFriendsToChat,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : friends.isEmpty
                    ? Center(child: Text(l.accountNotFound))
                    : ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return ListTile(
                            leading: AccountAvatar(account: friend),
                            title: Text(friend.accountName),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).pop(friend),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class ChatConversationPage extends StatefulWidget {
  const ChatConversationPage({
    super.key,
    required this.friend,
    required this.onOpenShoppingList,
  });

  final Account friend;
  final Future<void> Function(int shoppingListId) onOpenShoppingList;

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _messageKeys = {};
  int? _accountId;
  Stream<List<ChatMessage>>? _messagesStream;
  Object? _lastMessageStreamError;
  int? _recipeId;
  int? _shoppingListId;
  ChatMessage? _replyToMessage;
  bool _sending = false;
  bool _markingRead = false;
  bool _showJumpToLatest = false;
  int? _highlightedMessageId;
  Timer? _messageHighlightTimer;
  List<ChatMessage> _visibleMessages = const [];

  @override
  void initState() {
    super.initState();
    _accountId = currentAccount;
    PushNotifications.activeChatAccountId = widget.friend.id;
    unawaited(
      PushNotifications.clearChatNotificationsForAccount(widget.friend.id),
    );
    _createMessageStream();
    _scrollController.addListener(_handleScroll);
  }

  void _createMessageStream() {
    final accountId = _accountId;
    if (accountId == null) return;
    final firstId = accountId < widget.friend.id ? accountId : widget.friend.id;
    final secondId =
        accountId < widget.friend.id ? widget.friend.id : accountId;
    _messagesStream = Singleton().getDatabase().watchChatMessages(
          firstId,
          secondId,
        );
  }

  void _retryLoadingMessages() {
    setState(() {
      _lastMessageStreamError = null;
      _createMessageStream();
    });
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final show = _scrollController.offset > 160;
    if (show != _showJumpToLatest && mounted) {
      setState(() => _showJumpToLatest = show);
    }
  }

  Future<void> _jumpToLatest() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  GlobalKey _messageKey(int messageId) =>
      _messageKeys.putIfAbsent(messageId, GlobalKey.new);

  Future<bool> _revealMessage(int messageId) async {
    final messageContext = _messageKeys[messageId]?.currentContext;
    if (messageContext == null) return false;
    await Scrollable.ensureVisible(
      messageContext,
      alignment: .35,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
    if (!mounted) return true;
    _messageHighlightTimer?.cancel();
    setState(() => _highlightedMessageId = messageId);
    _messageHighlightTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted && _highlightedMessageId == messageId) {
        setState(() => _highlightedMessageId = null);
      }
    });
    return true;
  }

  Future<void> _jumpToMessage(int messageId) async {
    final targetIndex =
        _visibleMessages.indexWhere((message) => message.id == messageId);
    if (targetIndex < 0 || !_scrollController.hasClients) return;
    if (await _revealMessage(messageId)) return;

    final position = _scrollController.position;
    final fraction = _visibleMessages.length <= 1
        ? 0.0
        : targetIndex / (_visibleMessages.length - 1);
    await _scrollController.animateTo(
      position.maxScrollExtent * fraction,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );

    for (var attempt = 0; attempt < 5 && mounted; attempt++) {
      await WidgetsBinding.instance.endOfFrame;
      if (await _revealMessage(messageId)) return;
      if (!_scrollController.hasClients) return;

      final builtIndexes = _visibleMessages
          .asMap()
          .entries
          .where(
            (entry) => _messageKeys[entry.value.id]?.currentContext != null,
          )
          .map((entry) => entry.key)
          .toList();
      if (builtIndexes.isEmpty) return;
      final minimumBuilt = builtIndexes.reduce((a, b) => a < b ? a : b);
      final maximumBuilt = builtIndexes.reduce((a, b) => a > b ? a : b);
      final direction = targetIndex > maximumBuilt
          ? 1
          : targetIndex < minimumBuilt
              ? -1
              : 0;
      if (direction == 0) return;
      final currentPosition = _scrollController.position;
      final nextOffset = (currentPosition.pixels +
              direction * currentPosition.viewportDimension * .8)
          .clamp(0.0, currentPosition.maxScrollExtent)
          .toDouble();
      await _scrollController.animateTo(
        nextOffset,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  void _startReply(ChatMessage message) {
    setState(() => _replyToMessage = message);
    _messageFocusNode.requestFocus();
  }

  @override
  void dispose() {
    if (PushNotifications.activeChatAccountId == widget.friend.id) {
      PushNotifications.activeChatAccountId = null;
    }
    _messageController.dispose();
    _messageFocusNode.dispose();
    _messageHighlightTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final accountId = currentAccount;
    if (accountId == null || _sending) return;
    final text = _messageController.text.trim();
    final recipeId = _recipeId;
    final shoppingListId = _shoppingListId;
    final replyToMessage = _replyToMessage;
    if (text.isEmpty && recipeId == null && shoppingListId == null) return;
    final keepComposerFocused = _messageFocusNode.hasFocus;
    _messageController.clear();
    setState(() {
      _sending = true;
      _recipeId = null;
      _shoppingListId = null;
      _replyToMessage = null;
    });
    try {
      await DriftToSupabase.sendChatMessage(
        accountId: accountId,
        friendAccountId: widget.friend.id,
        message: text,
        recipeId: recipeId,
        shoppingListId: shoppingListId,
        replyToMessageId: replyToMessage?.id,
      );
    } catch (error) {
      if (!mounted) return;
      if (_messageController.text.isEmpty) {
        _messageController.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
      if (_recipeId == null && recipeId != null) {
        setState(() => _recipeId = recipeId);
      }
      if (_shoppingListId == null && shoppingListId != null) {
        setState(() => _shoppingListId = shoppingListId);
      }
      if (_replyToMessage == null && replyToMessage != null) {
        setState(() => _replyToMessage = replyToMessage);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        if (keepComposerFocused) _messageFocusNode.requestFocus();
      }
    }
  }

  Future<void> _markIncomingMessagesRead() async {
    final accountId = currentAccount;
    if (accountId == null || _markingRead) return;
    _markingRead = true;
    try {
      await DriftToSupabase.markChatMessagesRead(
        accountId: accountId,
        friendAccountId: widget.friend.id,
      );
      await PushNotifications.clearChatNotificationsForAccount(
        widget.friend.id,
      );
    } finally {
      _markingRead = false;
    }
  }

  Future<void> _pickRecipe() async {
    final selected = await showRecipePickerSheet(
      context: context,
      selectedRecipeId: _recipeId,
      title: Languages.of(context)!.shareRecipe,
    );
    if (selected != null && mounted) {
      setState(() {
        _recipeId = selected;
        _shoppingListId = null;
      });
    }
  }

  Future<void> _pickShoppingList() async {
    final accountId = currentAccount;
    if (accountId == null) return;
    await SupabaseToDrift.waitForActiveSync();
    final lists = await Singleton()
        .getDatabase()
        .getShoppingListsShareableWithAccount(accountId, widget.friend.id);
    if (!mounted) return;
    final selected = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) => _ShoppingListChatPicker(lists: lists),
    );
    if (selected != null && mounted) {
      setState(() {
        _shoppingListId = selected;
        _recipeId = null;
      });
    }
  }

  Future<void> _showAttachmentPicker() async {
    final selection = await showModalBottomSheet<_ChatAttachmentType>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final l = Languages.of(sheetContext)!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(l.shareRecipe),
                onTap: () =>
                    Navigator.of(sheetContext).pop(_ChatAttachmentType.recipe),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: Text(l.shareShoppingList),
                onTap: () => Navigator.of(sheetContext)
                    .pop(_ChatAttachmentType.shoppingList),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted) return;
    switch (selection) {
      case _ChatAttachmentType.recipe:
        await _pickRecipe();
        return;
      case _ChatAttachmentType.shoppingList:
        await _pickShoppingList();
        return;
      case null:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountId = _accountId;
    final messagesStream = _messagesStream;
    if (accountId == null || messagesStream == null) {
      return const SizedBox.shrink();
    }
    final l = Languages.of(context)!;
    return StreamBuilder<bool>(
      stream: RecipePermissions.watchCanModifyContent(),
      builder: (context, permissionSnapshot) {
        final canModify = permissionSnapshot.data == true;
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: [
                AccountAvatar(account: widget.friend, radius: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(widget.friend.accountName)),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<ChatMessage>>(
                  stream: messagesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      if (_lastMessageStreamError != snapshot.error) {
                        _lastMessageStreamError = snapshot.error;
                        logger.w(
                          'Could not load chat messages',
                          error: snapshot.error,
                          stackTrace: snapshot.stackTrace,
                        );
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l.couldNotLoadMessages,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: _retryLoadingMessages,
                                icon: const Icon(Icons.refresh),
                                label: Text(l.tryAgain),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final allMessages = snapshot.data!;
                    final messages = allMessages.reversed.toList();
                    _visibleMessages = messages;
                    final visibleMessageIds =
                        messages.map((message) => message.id).toSet();
                    _messageKeys.removeWhere(
                      (messageId, _) => !visibleMessageIds.contains(messageId),
                    );
                    final messagesById = {
                      for (final message in allMessages) message.id: message,
                    };
                    if (messages.any((message) =>
                        message.senderAccountId != accountId &&
                        message.readAt == null)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _markIncomingMessagesRead();
                      });
                    }
                    if (messages.isEmpty) {
                      return Center(child: Text(l.startChat));
                    }
                    return Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final repliedToMessage =
                                messagesById[message.replyToMessageId];
                            return KeyedSubtree(
                              key: _messageKey(message.id),
                              child: _MessageBubble(
                                message: message,
                                repliedToMessage: repliedToMessage,
                                own: message.senderAccountId == accountId,
                                canReact: canModify,
                                highlighted:
                                    _highlightedMessageId == message.id,
                                onReply: () => _startReply(message),
                                onOpenRepliedMessage: repliedToMessage == null
                                    ? null
                                    : () => _jumpToMessage(
                                          repliedToMessage.id,
                                        ),
                                onOpenShoppingList: widget.onOpenShoppingList,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          right: 16,
                          bottom: 14,
                          child: AnimatedScale(
                            scale: _showJumpToLatest ? 1 : 0,
                            duration: const Duration(milliseconds: 160),
                            child: IgnorePointer(
                              ignoring: !_showJumpToLatest,
                              child: FloatingActionButton.small(
                                heroTag: null,
                                tooltip: l.jumpToLatest,
                                onPressed: _jumpToLatest,
                                child: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              _MessageComposer(
                controller: _messageController,
                focusNode: _messageFocusNode,
                enabled: canModify,
                sending: _sending,
                recipeId: _recipeId,
                shoppingListId: _shoppingListId,
                replyToMessage: _replyToMessage,
                onRemoveRecipe: () => setState(() => _recipeId = null),
                onRemoveShoppingList: () =>
                    setState(() => _shoppingListId = null),
                onRemoveReply: () => setState(() => _replyToMessage = null),
                onPickAttachment: _showAttachmentPicker,
                onSend: _send,
              ),
            ],
          ),
        );
      },
    );
  }
}

String _badgeCount(int count) => count > 99 ? '99+' : '$count';

enum _ChatAttachmentType { recipe, shoppingList }

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.sending,
    required this.recipeId,
    required this.shoppingListId,
    required this.replyToMessage,
    required this.onRemoveRecipe,
    required this.onRemoveShoppingList,
    required this.onRemoveReply,
    required this.onPickAttachment,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool sending;
  final int? recipeId;
  final int? shoppingListId;
  final ChatMessage? replyToMessage;
  final VoidCallback onRemoveRecipe;
  final VoidCallback onRemoveShoppingList;
  final VoidCallback onRemoveReply;
  final VoidCallback onPickAttachment;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            children: [
              if (recipeId != null)
                _SelectedRecipe(
                  recipeId: recipeId!,
                  onRemove: onRemoveRecipe,
                ),
              if (shoppingListId != null)
                _SelectedShoppingList(
                  shoppingListId: shoppingListId!,
                  onRemove: onRemoveShoppingList,
                ),
              if (replyToMessage != null)
                _ReplyComposerPreview(
                  message: replyToMessage!,
                  onRemove: onRemoveReply,
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: l.addAttachment,
                    onPressed: enabled && !sending ? onPickAttachment : null,
                    icon: const Icon(Icons.attach_file),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final messageField = TextField(
                          controller: controller,
                          focusNode: focusNode,
                          enabled: enabled,
                          minLines: 1,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: l.messageHint,
                            filled: true,
                            fillColor: colors.surfaceContainerHighest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        );
                        if (!kIsWeb) return messageField;
                        return CallbackShortcuts(
                          bindings: {
                            const SingleActivator(LogicalKeyboardKey.enter):
                                () {
                              if (enabled && !sending) onSend();
                            },
                          },
                          child: messageField,
                        );
                      },
                    ),
                  ),
                  IconButton.filled(
                    tooltip: l.sendMessage,
                    onPressed: enabled && !sending ? onSend : null,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedRecipe extends StatelessWidget {
  const _SelectedRecipe({required this.recipeId, required this.onRemove});

  final int recipeId;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Recipe>>(
        stream: Singleton().getDatabase().getRecipeById(recipeId),
        builder: (context, snapshot) {
          final recipe = snapshot.data?.firstOrNull;
          return ListTile(
            dense: true,
            leading: const Icon(Icons.menu_book_outlined),
            title:
                Text(recipe?.title ?? Languages.of(context)!.recipeUnavailable),
            trailing: IconButton(
              tooltip: Languages.of(context)!.removeAttachment,
              onPressed: onRemove,
              icon: const Icon(Icons.close),
            ),
          );
        },
      );
}

class _SelectedShoppingList extends StatelessWidget {
  const _SelectedShoppingList({
    required this.shoppingListId,
    required this.onRemove,
  });

  final int shoppingListId;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<ShoppingList>>(
        stream: currentAccount == null
            ? Stream.value(const <ShoppingList>[])
            : Singleton().getDatabase().watchAccessibleShoppingListById(
                  currentAccount!,
                  shoppingListId,
                ),
        builder: (context, snapshot) {
          final list = snapshot.data?.firstOrNull;
          return ListTile(
            dense: true,
            leading: const Icon(Icons.shopping_cart_outlined),
            title: Text(
              list?.name ?? Languages.of(context)!.shoppingListUnavailable,
            ),
            trailing: IconButton(
              tooltip: Languages.of(context)!.removeAttachment,
              onPressed: onRemove,
              icon: const Icon(Icons.close),
            ),
          );
        },
      );
}

class _ReplyComposerPreview extends StatelessWidget {
  const _ReplyComposerPreview({
    required this.message,
    required this.onRemove,
  });

  final ChatMessage message;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(10, 6, 2, 6),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: colors.primary, width: 3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.replyingTo,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  _messagePreview(message, l),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l.removeReply,
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 19),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.repliedToMessage,
    required this.own,
    required this.canReact,
    required this.highlighted,
    required this.onReply,
    required this.onOpenRepliedMessage,
    required this.onOpenShoppingList,
  });

  final ChatMessage message;
  final ChatMessage? repliedToMessage;
  final bool own;
  final bool canReact;
  final bool highlighted;
  final VoidCallback onReply;
  final VoidCallback? onOpenRepliedMessage;
  final Future<void> Function(int shoppingListId) onOpenShoppingList;

  Future<void> _showReactions(BuildContext context) async {
    if (!canReact) return;
    const reactions = ['👍', '❤️', '😂', '😮', '😢', '🎉'];
    final selected = await showModalBottomSheet<String?>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            ...reactions.map((reaction) => IconButton.filledTonal(
                  onPressed: () => Navigator.of(context).pop(reaction),
                  icon: Text(reaction, style: const TextStyle(fontSize: 22)),
                )),
            IconButton(
              tooltip: Languages.of(context)!.delete,
              onPressed: () => Navigator.of(context).pop(''),
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      ),
    );
    if (selected == null || !context.mounted || currentAccount == null) return;
    await DriftToSupabase.setChatMessageReaction(
      accountId: currentAccount!,
      messageId: message.id,
      reaction: selected.isEmpty ? null : selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasRecipeReference = message.recipeId != null ||
        message.recipeTitleSnapshot?.trim().isNotEmpty == true;
    final hasShoppingListReference = message.shoppingListId != null ||
        message.shoppingListNameSnapshot?.trim().isNotEmpty == true;
    return Dismissible(
      key: ValueKey('chat-reply-${message.id}'),
      direction: canReact ? DismissDirection.startToEnd : DismissDirection.none,
      dismissThresholds: const {DismissDirection.startToEnd: .24},
      confirmDismiss: (_) async {
        HapticFeedback.selectionClick();
        onReply();
        return false;
      },
      background: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 18),
          child: Icon(Icons.reply, color: colors.primary),
        ),
      ),
      child: Align(
        alignment: own ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment:
                  own ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: canReact ? () => _showReactions(context) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    decoration: BoxDecoration(
                      color: own
                          ? colors.primaryContainer
                          : colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: highlighted
                          ? Border.all(color: colors.primary, width: 2)
                          : null,
                      boxShadow: highlighted
                          ? [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: .18),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 9, 8, 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.replyToMessageId != null ||
                              message.replyMessageSnapshot?.trim().isNotEmpty ==
                                  true)
                            _ReplyMessagePreview(
                              message: repliedToMessage,
                              snapshot: message.replyMessageSnapshot,
                              onTap: onOpenRepliedMessage,
                            ),
                          if (hasRecipeReference)
                            _SharedRecipeCard(
                              recipeId: message.recipeId,
                              titleSnapshot: message.recipeTitleSnapshot,
                            ),
                          if (hasShoppingListReference)
                            _SharedShoppingListCard(
                              shoppingListId: message.shoppingListId,
                              nameSnapshot: message.shoppingListNameSnapshot,
                              onOpen: onOpenShoppingList,
                            ),
                          if (message.message?.trim().isNotEmpty == true) ...[
                            if (hasRecipeReference ||
                                hasShoppingListReference ||
                                message.replyToMessageId != null ||
                                message.replyMessageSnapshot
                                        ?.trim()
                                        .isNotEmpty ==
                                    true)
                              const SizedBox(height: 7),
                            Text(message.message!.trim()),
                          ],
                          const SizedBox(height: 3),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat.Hm()
                                    .format(message.createdAt.toLocal()),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(width: 4),
                              if (canReact)
                                InkWell(
                                  onTap: () => _showReactions(context),
                                  borderRadius: BorderRadius.circular(16),
                                  child: const Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.add_reaction_outlined,
                                      size: 17,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _ReactionSummary(messageId: message.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReplyMessagePreview extends StatelessWidget {
  const _ReplyMessagePreview({
    required this.message,
    required this.snapshot,
    required this.onTap,
  });

  final ChatMessage? message;
  final String? snapshot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final text = message == null
        ? (snapshot?.trim().isNotEmpty == true
            ? snapshot!.trim()
            : l.originalMessageUnavailable)
        : _messagePreview(message!, l);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(5),
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
          ),
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}

class _ReactionSummary extends StatelessWidget {
  const _ReactionSummary({required this.messageId});

  final int messageId;

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<List<ChatMessageReaction>>(
        stream: Singleton().getDatabase().watchChatMessageReactions(messageId),
        builder: (context, snapshot) {
          final reactions = snapshot.data ?? const <ChatMessageReaction>[];
          if (reactions.isEmpty) return const SizedBox.shrink();
          final counts = <String, int>{};
          for (final reaction in reactions) {
            counts.update(reaction.reaction, (value) => value + 1,
                ifAbsent: () => 1);
          }
          return Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Wrap(
              spacing: 4,
              children: counts.entries
                  .map((entry) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${entry.key} ${entry.value}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      );
}

class _SharedRecipeCard extends StatelessWidget {
  const _SharedRecipeCard({
    required this.recipeId,
    required this.titleSnapshot,
  });

  final int? recipeId;
  final String? titleSnapshot;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Recipe>>(
        stream: recipeId == null
            ? Stream.value(const <Recipe>[])
            : Singleton().getDatabase().getRecipeById(recipeId!),
        builder: (context, snapshot) {
          final recipe = snapshot.data
              ?.where((candidate) => candidate.deletedAt == null)
              .firstOrNull;
          final unavailable = recipe == null;
          final savedTitle = titleSnapshot?.trim();
          final title = recipe?.title ??
              (savedTitle?.isNotEmpty == true
                  ? savedTitle!
                  : Languages.of(context)!.recipeUnavailable);
          return InkWell(
            onTap: unavailable
                ? null
                : () => Navigator.of(context).push(
                      appPageRoute(
                        builder: (_) => RecipeView(
                          recipe: recipe,
                          open: false,
                          additionalData: null,
                        ),
                        fullScreenSwipeBack: true,
                      ),
                    ),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_outlined, size: 22),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (unavailable && savedTitle?.isNotEmpty == true)
                          Text(
                            Languages.of(context)!.recipeUnavailable,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                      ],
                    ),
                  ),
                  if (!unavailable) const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          );
        },
      );
}

class _SharedShoppingListCard extends StatelessWidget {
  const _SharedShoppingListCard({
    required this.shoppingListId,
    required this.nameSnapshot,
    required this.onOpen,
  });

  final int? shoppingListId;
  final String? nameSnapshot;
  final Future<void> Function(int shoppingListId) onOpen;

  @override
  Widget build(BuildContext context) {
    final accountId = currentAccount;
    return StreamBuilder<List<ShoppingList>>(
      stream: accountId == null || shoppingListId == null
          ? Stream.value(const <ShoppingList>[])
          : Singleton().getDatabase().watchAccessibleShoppingListById(
                accountId,
                shoppingListId!,
              ),
      builder: (context, snapshot) {
        final list = snapshot.data?.firstOrNull;
        final unavailable = list == null;
        final savedName = nameSnapshot?.trim();
        final title = list?.name ??
            (savedName?.isNotEmpty == true
                ? savedName!
                : Languages.of(context)!.shoppingListUnavailable);
        return InkWell(
          onTap: unavailable || shoppingListId == null
              ? null
              : () => onOpen(shoppingListId!),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (unavailable)
                        Text(
                          Languages.of(context)!.shoppingListUnavailable,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
                if (!unavailable) const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShoppingListChatPicker extends StatelessWidget {
  const _ShoppingListChatPicker({required this.lists});

  final List<ShoppingList> lists;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .62,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.shareShoppingList,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: l.close,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (lists.isEmpty)
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l.noShoppingListsAvailableToShare,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: lists.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final list = lists[index];
                  return ListTile(
                    leading: const Icon(Icons.shopping_cart_outlined),
                    title: Text(list.name),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).pop(list.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

String _messagePreview(ChatMessage message, Languages l) {
  final text = message.message?.trim();
  if (text?.isNotEmpty == true) return text!;
  final recipeTitle = message.recipeTitleSnapshot?.trim();
  if (recipeTitle?.isNotEmpty == true) return recipeTitle!;
  if (message.recipeId != null) return l.sharedRecipe;
  final shoppingListName = message.shoppingListNameSnapshot?.trim();
  if (shoppingListName?.isNotEmpty == true) return shoppingListName!;
  if (message.shoppingListId != null) return l.sharedShoppingList;
  return l.originalMessageUnavailable;
}
