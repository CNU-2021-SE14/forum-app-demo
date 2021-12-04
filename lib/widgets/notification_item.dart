import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/post_detail_screen.dart';
import '../providers/posts.dart';
import '../providers/notifications.dart';
import '../providers/comments.dart';
import '../providers/auth.dart';
import '../models/notification.dart' as noti;

class NotificationItem extends StatelessWidget {
  final noti.Notification notification;
  NotificationItem(
    this.notification,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xffE6E6E6),
          child: Icon(
            Icons.mode_comment_outlined,
            color: Color(0xffCCCCCC),
          ),
        ),
        title: Text(
          notification.title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            notification.contents!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          (DateTime.now().day - notification.datetime!.day >= 1)
              ? Text(
                  DateFormat('MM/dd').format(notification.datetime),
                  style: TextStyle(color: Colors.black26),
                )
              : Text(
                  DateFormat('HH:mm').format(notification.datetime),
                  style: TextStyle(color: Colors.black26),
                ),
        ]),
        trailing: IconButton(
          onPressed: () async {
            await Provider.of<Notifications>(context, listen: false)
                .deleteNotification(notification.id!);
          },
          icon: Icon(Icons.close),
        ),
        onTap: () async {
          await Provider.of<Comments>(context, listen: false)
              .fetchAndSetComments(notification.postId!);
          Navigator.of(context).pushNamed(PostDetailScreen.routeName,
              arguments: notification.postId);
        },
      ),
    );
  }
}
