import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/notifications.dart';
import '../widgets/notification_item.dart';

class NotiCenterScreen extends StatelessWidget {
  static const routeName = './notiCenter';
  const NotiCenterScreen({Key? key}) : super(key: key);

  Future<void> _refresh(BuildContext context, String? userId) async {
    await Provider.of<Notifications>(context, listen: false)
        .fetchAndSetNotifications(userId!);
  }

  @override
  Widget build(BuildContext context) {
    final auth_userId = Provider.of<Auth>(context, listen: false).userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('알림 센터'),
      ),
      body: FutureBuilder(
        future: _refresh(context, auth_userId!),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refresh(context, auth_userId),
                child: Consumer<Notifications>(
                  builder: (ctx, notificationsData, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: notificationsData.items.length > 0
                        ? ListView.builder(
                            itemCount: notificationsData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                NotificationItem(notificationsData.items[i]),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: 48,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'No Notifications',
                                  textScaleFactor: 1.5,
                                ),
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
