import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../screens/notification_center_screen.dart';
import '../providers/auth.dart';
import '../providers/notifications.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void didChangeDependencies() async {
    final userId = Provider.of<Auth>(context).userId;
    await Provider.of<Notifications>(context).fetchAndSetNotifications(userId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<Auth>(context, listen: false).email;
    var hasNotification = Provider.of<Notifications>(context).items.isNotEmpty;

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          userEmail != null
              ? Card(
                  child: ListTile(
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
                    title: Text(userEmail),
                  ),
                )
              : Container(),
          ListTile(
            leading: hasNotification
                ? Badge(
                    child: Icon(Icons.notifications_none),
                  )
                : Icon(Icons.notifications_none),
            title: Text('알림 센터'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(NotiCenterScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('로그아웃'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
