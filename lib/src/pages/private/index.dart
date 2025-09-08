import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/private/dashboard/index.dart';
import 'package:my_app/src/service/core/auth_service.dart';
import 'package:provider/provider.dart';

final privateRoutes = <RouteBase>[
  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) {
      final auth = context.read<AuthService>();
      return HomePage(user: auth.currentUser!);
    },
  ),
];
