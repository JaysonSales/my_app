import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/public/auth/sign_in/sign_in_page.dart';
import 'package:my_app/src/pages/public/auth/sign_up/sign_up_page.dart';
import 'package:my_app/src/pages/public/error/index.dart';


final publicRoutes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const SignInPage();
    },
  ),
  GoRoute(
    path: '/signin',
    builder: (BuildContext context, GoRouterState state) {
      return const SignInPage();
    },
  ),
  GoRoute(
    path: '/signup',
    builder: (BuildContext context, GoRouterState state) {
      return const SignUpPage();
    },
  ),
  ...errorRoutes,
];
