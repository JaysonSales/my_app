import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/public/auth/sign_in/sign_in.dart';
import 'package:my_app/src/pages/public/auth/sign_up/sign_up.dart';
import 'package:my_app/src/pages/public/error/index.dart';

final publicRoutes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const SigninPage();
    },
  ),
  GoRoute(
    path: '/signin',
    builder: (BuildContext context, GoRouterState state) {
      return const SigninPage();
    },
  ),
  GoRoute(
    path: '/signup',
    builder: (BuildContext context, GoRouterState state) {
      return const SignupPage();
    },
  ),
  ...errorRoutes,
];
