import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/Board.dart';
import 'package:first_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/providers/boards.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('MainScreen'),
            automaticallyImplyLeading: false,
          ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('logout'),
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
