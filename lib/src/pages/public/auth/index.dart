import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/public/auth/layout.dart';
import 'package:my_app/src/pages/public/auth/sign_in/sign_in_page.dart';
import 'package:my_app/src/pages/public/auth/sign_up/sign_up_page.dart';

final authRoutes = <RouteBase>[
  GoRoute(
    path: '/signin',
    builder: (BuildContext context, GoRouterState state) {
      return PublicLayout(title: 'Sign In', child: SignInPage());
    },
  ),
  GoRoute(
    path: '/signup',
    builder: (BuildContext context, GoRouterState state) {
      return PublicLayout(
        title: 'Sign Up',
        hasLeading: true,
        child: SignUpPage(),
      );
    },
  ),
];
