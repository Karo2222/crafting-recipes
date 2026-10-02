import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum CommentAction { edit, delete }

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.data,
    this.onEdit,
    this.onDelete,
  });

  final CommentWithAccount data;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final comment = data.comment;
    final formatter = DateFormat.yMMMd().add_Hm();
    final hasActions = onEdit != null || onDelete != null;
    final l = Languages.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.accountName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (hasActions)
                  PopupMenuButton<CommentAction>(
                    tooltip: l.commentActions,
                    onSelected: (action) {
                      switch (action) {
                        case CommentAction.edit:
                          onEdit?.call();
                          break;
                        case CommentAction.delete:
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                          value: CommentAction.edit,
                          child: ListTile(
                            leading: const Icon(Icons.edit_outlined),
                            title: Text(l.editComment),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: CommentAction.delete,
                          child: ListTile(
                            leading: const Icon(Icons.delete_outline),
                            title: Text(l.delete),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.message),
            const SizedBox(height: 10),
            Text(
              formatter.format(comment.createdAt.toLocal()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
