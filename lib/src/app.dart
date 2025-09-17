import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/public/error/internal_server_page.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/pages/private/index.dart';
import 'package:my_app/src/pages/public/error/index.dart';
import 'package:my_app/src/pages/public/error/maintenance_page.dart';
import 'package:my_app/src/pages/public/error/not_found_page.dart';
import 'package:my_app/src/pages/public/index.dart';
import 'package:my_app/src/provider/core/auth_provider.dart';
import 'package:my_app/src/provider/core/config_provider.dart';
import 'package:my_app/src/provider/theme/theme_provider.dart';
import 'package:my_app/src/utils/themes/themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = context.watch<ConfigService>();
    final themeProvider = context.watch<ThemeProvider>();

    if (configService.loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (configService.error != null) {
      return MaterialApp(
        home: InternalServerPage(message: configService.error.toString()),
        debugShowCheckedModeBanner: false,
      );
    }

    final maintenanceConfig = configService.config?['maintenance'];
    final bool isMaintenanceEnabled =
        maintenanceConfig is Map && maintenanceConfig['enabled'] == true;

    if (isMaintenanceEnabled) {
      return const MaterialApp(
        home: MaintenancePage(),
        debugShowCheckedModeBanner: false,
      );
    }

    final router = GoRouter(
      routes: <RouteBase>[...publicRoutes, ...privateRoutes, ...errorRoutes],
      redirect: (context, state) {
        final auth = context.read<AuthProvider>();
        final location = state.uri.toString();

        final isAuthPath = location == '/signin' || location == '/signup';
        final isRoot = location == '/';

        if (!auth.isLoggedIn && isRoot) return '/signin';
        if (auth.isLoggedIn && isAuthPath) return '/home';

        return null;
      },

      errorBuilder: (_, state) => const NotFoundPage(),
    );

    final configTheme = configService.config?['app']?['theme'] ?? 'default';
    final ThemeData selectedTheme =
        appThemes[configTheme] ?? appThemes['default']!;

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: configService.config?['app']?['title'] ?? "My App",
      theme: selectedTheme,
      darkTheme: appThemes['dark'],
      themeMode: themeProvider.themeMode,
    );
  }
}
