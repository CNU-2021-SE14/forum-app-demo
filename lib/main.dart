import 'package:first_app/screens/serach_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/board_screen.dart';
import './screens/auth_screen.dart';
import './screens/main_screen.dart';
import './screens/notification_center_screen.dart';
import './screens/post_detail_screen.dart';
import './screens/edit_post_screen.dart';
import './providers/posts.dart';
import 'providers/comments.dart';
import './providers/auth.dart';
import './providers/boards.dart';
import './providers/notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Posts>(
          create: (_) => Posts('', '', []),
          update: (ctx, auth, previousPosts) => Posts(
            auth.token,
            auth.userId,
            previousPosts == null ? [] : previousPosts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Board_List>(
          create: (_) => Board_List('', []),
          update: (ctx, auth, previousBoards) => Board_List(
            auth.token,
            previousBoards == null ? [] : previousBoards.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Comments>(
          create: (_) => Comments('', '', []),
          update: (ctx, auth, previousComments) => Comments(
            auth.token,
            auth.userId,
            previousComments == null ? [] : previousComments.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Notifications>(
          create: (_) => Notifications('', '', []),
          update: (ctx, auth, previousNotifications) => Notifications(
            auth.token,
            auth.userId,
            previousNotifications == null ? [] : previousNotifications.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'ForumDemo',
          theme: ThemeData(
            primaryColor: Colors.purple,
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            BoardScreen.routeName: (ctx) => BoardScreen(),
            PostDetailScreen.routeName: (ctx) => PostDetailScreen(),
            EditPostScreen.routeName: (ctx) => EditPostScreen(),
            NotiCenterScreen.routeName: (ctx) => NotiCenterScreen(),
            SearchScreen.routeName:(ctx)=>SearchScreen(),
          },
        ),
      ),
    );
  }
}
