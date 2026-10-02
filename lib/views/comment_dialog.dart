import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  const CommentDialog({
    super.key,
    required this.recipeId,
    this.comment,
  });

  final int recipeId;
  final Comment? comment;

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _saving = false;

  bool get _isEditing => widget.comment != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.comment?.message ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || currentAccount == null) return;

    setState(() => _saving = true);
    final l = Languages.of(context)!;

    try {
      if (!await RecipePermissions.canModifyContent()) {
        throw Exception(l.viewerCannotEdit);
      }
      final message = _controller.text.trim();
      if (_isEditing) {
        await Singleton().getDatabase().updateComment(
              CommentsCompanion(
                id: drift.Value(widget.comment!.id),
                message: drift.Value(message),
                updatedAt: drift.Value(DateTime.now().toUtc()),
                updatedBy: drift.Value(currentAccount!),
              ),
            );
        await SupabaseToDrift.sync();
      } else {
        await DriftToSupabase.createComment(
          recipeId: widget.recipeId,
          accountId: currentAccount!,
          message: message,
        );
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.commentSaved)));
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.somethingWentWrong)),
      );
      logger.e('Could not save comment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return AlertDialog(
      title: Text(_isEditing ? l.editComment : l.addComment),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 7,
          maxLength: 2000,
          decoration: InputDecoration(
            hintText: l.commentContent,
            border: const OutlineInputBorder(),
          ),
          validator: (value) =>
              value == null || value.trim().isEmpty ? l.pleaseEnterValue : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(l.save),
        ),
      ],
    );
  }
}
