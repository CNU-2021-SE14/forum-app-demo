import 'dart:js';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/edit_post_screen.dart';
import '../providers/auth.dart';
import '../providers/post.dart';
import '../providers/posts.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = './postDetail';

  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Future<void> _refreshPosts(BuildContext context, String boardId) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(boardId);
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    final id = ModalRoute.of(context)!.settings.arguments as String;
    final post =
        Provider.of<Posts>(context).items.firstWhere((post) => post.id == id);
    final authUserId =
        Provider.of<Auth>(context, listen: false).userId as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // 글쓴이가 자기 자신이면 수정, 삭제 버튼 활성
        actions: authUserId == id
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(EditPostScreen.routeName,
                        arguments: {'postId': id, 'boardId': post.boardId});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await Provider.of<Posts>(context, listen: false)
                          .deletePost(id);
                      Navigator.of(context).pop();
                    } catch (error) {
                      scaffold.showSnackBar(SnackBar(
                        content: Text(
                          "삭제하지 못했습니다.",
                          textAlign: TextAlign.center,
                        ),
                      ));
                    }
                  },
                ),
              ]
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshPosts(context, post.boardId!),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              // 아이콘, 익명, datetime
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Color(0xffE6E6E6),
                    child: Icon(
                      Icons.person,
                      color: Color(0xffCCCCCC),
                    ),
                  ),
                ),
                title: Text('익명'),
                subtitle: Text(
                    DateFormat('yy/MM/dd - HH:mm:ss').format(post.datetime)),
              ),
              // 제목
              Text(
                post.title!,
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.2,
              ),
              // 내용
              Text(post.contents!, softWrap: true),
              // TODO: 아래에 댓글 표시
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: 댓글 작성 logic
        },
        label: const Text('댓글 작성'),
        icon: const Icon(Icons.comment),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
