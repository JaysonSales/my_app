import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:my_app/src/provider/core/user_provider.dart';
import 'package:my_app/src/widgets/core/redirect.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/pages/private/calculator/index.dart';
import 'package:my_app/src/pages/private/layout.dart';
import 'package:my_app/src/pages/private/dashboard/index.dart';
import 'package:my_app/src/pages/private/settings/index.dart';

final Logger _logger = Logger('PrivateRoutes');

Widget _privatePageBuilder(
  BuildContext context,
  String title,
  Widget Function(dynamic user) pageBuilder,
) {
  final userProvider = context.read<UserProvider>();
  final user = userProvider.userProfile;

  if (user == null) {
    _logger.warning('Unauthorized access to $title. Redirecting to /403...');
    return const RedirectPage(path: '/403');
  }

  final firstName = user.firstName;
  _logger.info('Building private page: $title for user: $firstName');

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
    builder: (context, state) =>
        _privatePageBuilder(context, 'Calculator', (user) => CalculatorPage(user: user)),
  ),
  GoRoute(
    path: '/settings',
    builder: (context, state) =>
        _privatePageBuilder(context, 'Settings', (user) => SettingsPage(user: user)),
  ),
];
