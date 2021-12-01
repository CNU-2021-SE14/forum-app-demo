import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/edit_post_screen.dart';
import '../providers/auth.dart';
import '../providers/post.dart';
import '../providers/posts.dart';

class PostDetailScreen extends StatelessWidget {
  static const routeName = './postDetail';

  const PostDetailScreen({Key? key}) : super(key: key);

  Future<void> _refreshPosts(BuildContext context, String boardId) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(boardId);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final post = Provider.of<Posts>(context, listen: false)
        .items
        .firstWhere((post) => post.id == id);
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
        actions: authUserId == post.userId
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
                      Navigator.pop(context);
                    } catch (error) {
                      Scaffold.of(context).showSnackBar(SnackBar(
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
      body: Stack(children: [
        RefreshIndicator(
          onRefresh: () => _refreshPosts(context, post.boardId!),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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
                Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(
                    post.title!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 1.4,
                    textAlign: TextAlign.start,
                  ),
                ),
                // 내용
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(post.contents!),
                ),
                // TODO: 아래에 댓글 표시
              ],
            ),
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        hintText: "댓글을 입력하세요.",
                        hintStyle: new TextStyle(color: Colors.black26),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            // TODO: 댓글 등록 구현
                          },
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ]),
    );
  }
}
