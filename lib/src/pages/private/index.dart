import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/pages/private/calculator/index.dart';
import 'package:my_app/src/pages/private/layout.dart';
import 'package:my_app/src/provider/core/auth_provider.dart';
import 'package:my_app/src/pages/private/dashboard/index.dart';

Widget _privatePageBuilder(
  BuildContext context,
  String title,
  Widget Function(dynamic user) pageBuilder,
) {
  final auth = context.read<AuthService>();
  final user = auth.currentUser;

  if (user == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/403');
    });
    return const SizedBox.shrink();
  }

  return PrivateLayout(title: title, child: pageBuilder(user));
}

final privateRoutes = <RouteBase>[
  GoRoute(
    path: '/home',
    builder: (context, state) =>
        _privatePageBuilder(context, 'Home', (user) => HomePage(user: user)),
  ),
  GoRoute(
    path: '/calculator',
    builder: (context, state) => _privatePageBuilder(
      context,
      'Calculator',
      (user) => CalculatorPage(user: user),
    ),
  ),
];
