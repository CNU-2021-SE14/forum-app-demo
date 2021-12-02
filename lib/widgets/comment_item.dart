import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/comments.dart';
import '../providers/auth.dart';

class CommentItem extends StatelessWidget {
  final String? id;
  CommentItem(
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<Comments>(context, listen: false).items;
    final auth_uid = Provider.of<Auth>(context, listen: false).userId;
    final comment = comments.firstWhere((comment) => comment.id == id);
    int timediff = DateTime.now().day - comment.datetime!.day;

    String dt = '';
    if (timediff >= 1) {
      dt = timediff.toString() + "일 전";
    } else {
      dt = DateFormat("hh:mm").format(comment.datetime!);
    }

    return (comment.userId != null)
        ? Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Color(0xffE6E6E6),
                    child: Icon(
                      Icons.comment,
                      color: Color(0xffCCCCCC),
                    ),
                  ),
                ),
                title: Text(
                  comment.userId!.substring(0, 5) + '****   ' + '-   ' + dt,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(comment.contents!),
                trailing: comment.userId == auth_uid
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () async {
                          await Provider.of<Comments>(context, listen: false)
                              .deleteComment(id!);
                        },
                      )
                    : null,
              ),
              Divider(
                thickness: 1,
              ),
            ],
          )
        : SizedBox(
            height: 0,
          );
  }
}
