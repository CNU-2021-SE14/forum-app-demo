import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/posts.dart';
import '../screens/edit_post_screen.dart';
import '../widgets/post_item.dart';
import './main_screen.dart';

class BoardScreen extends StatelessWidget {
  static const routeName = './board';
  const BoardScreen({Key? key}) : super(key: key);

  Future<void> _refreshPosts(BuildContext context, String boardId) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(boardId);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BoardScreenArguments;
    final boardId = args.boardId;
    final boardName = args.boardName;

    return Scaffold(
      appBar: AppBar(
        title: Text('$boardName'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditPostScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshPosts(context, boardId),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshPosts(context, boardId),
                    child: Consumer<Posts>(
                      builder: (ctx, postsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: postsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              PostItem(
                                postsData.items[i].id,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
