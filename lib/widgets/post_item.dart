import 'package:flutter/material.dart';
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
      ),
      subtitle: Text(
        post.contents!,
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
