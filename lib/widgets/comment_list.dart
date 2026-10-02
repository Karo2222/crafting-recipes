import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/comment_dialog.dart';
import 'package:craftingrecipes/widgets/comment_card.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    super.key,
    required this.comments,
    this.shrinkWrap = false,
  });

  final Stream<List<CommentWithAccount>> comments;
  final bool shrinkWrap;

  Future<void> _confirmDelete(
    BuildContext context,
    Comment comment,
  ) async {
    final l = Languages.of(context)!;
    final excerpt = comment.message.length > 60
        ? '${comment.message.substring(0, 60)}...'
        : comment.message;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l.deleteComment}?'),
        content: Text('${l.confirmCommentDelete}\n\n“$excerpt”'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true || currentAccount == null) return;
    if (!await RecipePermissions.canModifyContent()) return;
    await Singleton().getDatabase().updateComment(
          CommentsCompanion(
            id: drift.Value(comment.id),
            updatedAt: drift.Value(DateTime.now().toUtc()),
            updatedBy: drift.Value(currentAccount!),
            deletedAt: drift.Value(DateTime.now().toUtc()),
            deletedBy: drift.Value(currentAccount!),
          ),
        );
    await SupabaseToDrift.sync();
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return FutureBuilder<bool>(
      future: RecipePermissions.canModifyContent(),
      builder: (context, permissionSnapshot) {
        final canModify = permissionSnapshot.data == true;
        return StreamBuilder<List<CommentWithAccount>>(
          stream: comments,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${l.somethingWentWrong} ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final entries = snapshot.data!;
            if (entries.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(l.noComments),
              );
            }

            return ListView.builder(
              key: const Key('listview_comments'),
              shrinkWrap: shrinkWrap,
              physics: shrinkWrap
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final data = entries[index];
                final isOwnComment = data.comment.accountId == currentAccount;
                return CommentCard(
                  data: data,
                  onEdit: canModify && isOwnComment
                      ? () => showDialog(
                            context: context,
                            builder: (context) => CommentDialog(
                              recipeId: data.comment.recipeId,
                              comment: data.comment,
                            ),
                          )
                      : null,
                  onDelete: canModify && isOwnComment
                      ? () => _confirmDelete(context, data.comment)
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }
}
