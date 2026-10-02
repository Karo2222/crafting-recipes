import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/widgets/comment_list.dart';
import 'package:flutter/material.dart';

class MyCommentsView extends StatelessWidget {
  const MyCommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final accountId = currentAccount;

    return Scaffold(
      appBar: AppBar(title: Text(l.myComments)),
      body: accountId == null
          ? Center(child: Text(l.somethingWentWrong))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: CommentList(
                comments: Singleton()
                    .getDatabase()
                    .watchCommentsForAccount(accountId),
              ),
            ),
    );
  }
}
