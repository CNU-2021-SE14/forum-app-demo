import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/post_detail_screen.dart';
import '../providers/posts.dart';
import '../providers/auth.dart';

class PostItem extends StatelessWidget {
  final String? id;
  PostItem(
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<Posts>(context, listen: false).items;
    final postIndex = posts.indexWhere((post) => post.id == id);
    final post = posts[postIndex];

    return ListTile(
      title: Text(
        post.title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        post.contents!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: (post.datetime!.difference(DateTime.now()).inDays > 1)
          ? Text(DateFormat('MM/dd').format(post.datetime))
          : Text(DateFormat('HH:mm').format(post.datetime)),
      onTap: () {
        Navigator.of(context)
            .pushNamed(PostDetailScreen.routeName, arguments: id);
      },
    );
  }
}
