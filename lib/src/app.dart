import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/private/index.dart';
import 'package:my_app/src/pages/public/error/index.dart';
import 'package:my_app/src/pages/public/error/not_found_page.dart';
import 'package:my_app/src/pages/public/index.dart';
import 'package:my_app/src/service/core/auth_service.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: <RouteBase>[...publicRoutes, ...privateRoutes, ...errorRoutes],
      redirect: (context, state) {
        final auth = context.read<AuthService>();
        final location = state.uri.toString();

        final loggingIn = location == '/signin' || location == '/signup';

        if (!auth.isLoggedIn && location == '/home') {
          return '/403';
        }

        if (auth.isLoggedIn && loggingIn) {
          return '/home';
        }
        return null;
      },
      errorBuilder: (context, state) => const NotFoundPage(),
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: "My App",
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
