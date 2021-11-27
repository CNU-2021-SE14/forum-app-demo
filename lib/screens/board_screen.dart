import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/posts.dart';
import '../providers/post.dart';
import './main_screen.dart';

class BoardScreen extends StatelessWidget {
  static const routeName = './board';
  const BoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BoardScreenArguments;
    final boardId = args.boardId;
    final boardName = args.boardName;

    final loadedPosts = Provider.of<Posts>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('$boardName'),
      ),
      // body:
    );
  }
}
