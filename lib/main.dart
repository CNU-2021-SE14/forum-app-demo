import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/board_screen.dart';
import './providers/posts.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/main_screen.dart';

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
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'ForumDemo',
          theme: ThemeData(
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
            // PostsDetailScreen.routeName: (ctx) => PostsDetailScreen()
          },
        ),
      ),
    );
  }
}
