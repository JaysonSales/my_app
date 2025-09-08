import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/service/core/auth_service.dart';
import 'package:my_app/src/pages/private/dashboard/index.dart';

final privateRoutes = <RouteBase>[
  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) {
      return HomePage(user: state.extra as User);
    },
  ),
];
