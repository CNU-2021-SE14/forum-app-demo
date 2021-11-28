import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/post_detail_screen.dart';
import '../providers/post.dart';
import '../providers/auth.dart';

class PostItem extends StatelessWidget {
  final String? id;
  final String? title;
  final String? contents;
  final DateTime? datetime;
  final String? boardId;
  final String? userId;

  PostItem(this.id, this.title, this.contents, this.datetime, this.boardId,
      this.userId);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        contents!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(PostDetailScreen.routeName, arguments: id);
      },
    );
  }
}
