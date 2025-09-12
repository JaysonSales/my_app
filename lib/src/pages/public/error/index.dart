import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/public/error/forbidden_page.dart';
import 'package:my_app/src/pages/public/error/internal_server_page.dart';
import 'package:my_app/src/pages/public/error/not_found_page.dart';

final errorRoutes = <RouteBase>[
  GoRoute(
    path: '/500',
    builder: (BuildContext context, GoRouterState state) {
      return const InternalServerPage(
        message: "An unexpected error occurred. Please try again later.",
      );
    },
  ),
  GoRoute(
    path: '/403',
    builder: (BuildContext context, GoRouterState state) {
      return const ForbiddenPage();
    },
  ),
  GoRoute(
    path: '/404',
    builder: (BuildContext context, GoRouterState state) {
      return const NotFoundPage();
    },
  ),
];
