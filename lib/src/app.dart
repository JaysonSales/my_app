import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/public/error/internal_server_page.dart';
import 'package:my_app/src/provider/core/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/pages/private/index.dart';
import 'package:my_app/src/pages/public/error/index.dart';
import 'package:my_app/src/pages/public/error/maintenance_page.dart';
import 'package:my_app/src/pages/public/error/not_found_page.dart';
import 'package:my_app/src/pages/public/index.dart';
import 'package:my_app/src/provider/core/config_provider.dart';
import 'package:my_app/src/provider/theme/theme_provider.dart';
import 'package:my_app/src/utils/themes/themes.dart';
import 'package:my_app/src/provider/messaging/alert_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _router = GoRouter(
      refreshListenable: userProvider,
      routes: <RouteBase>[...publicRoutes, ...privateRoutes, ...errorRoutes],
      redirect: (BuildContext context, GoRouterState state) {
        final bool isLoggedIn = userProvider.isLoggedIn;
        final bool justLoggedIn = userProvider.justLoggedIn;
        final String location = state.uri.toString();
        final bool isAuthPath = location == '/signin' || location == '/signup';
        final bool isRoot = location == '/';

        if (!isLoggedIn && isRoot) {
          return '/signin';
        }
        if (isLoggedIn && (isAuthPath || isRoot)) {
          if (justLoggedIn) return null;
          return '/home';
        }

        return null;
      },
      errorBuilder: (context, state) => const NotFoundPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<ConfigProvider>();
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    if (configProvider.loading || userProvider.loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (configProvider.error != null) {
      return MaterialApp(
        home: InternalServerPage(message: configProvider.error.toString()),
        debugShowCheckedModeBanner: false,
      );
    }

    final maintenanceConfig = configProvider.config?['maintenance'];
    final bool isMaintenanceEnabled =
        maintenanceConfig is Map && maintenanceConfig['enabled'] == true;

    if (isMaintenanceEnabled) {
      return const MaterialApp(
        home: MaintenancePage(),
        debugShowCheckedModeBanner: false,
      );
    }

    final configTheme = configProvider.config?['app']?['theme'] ?? 'default';
    final ThemeData selectedTheme =
        appThemes[configTheme] ?? appThemes['default'] ?? ThemeData.light();

    return MaterialApp.router(
      scaffoldMessengerKey: AlertProvider.messengerKey,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: configProvider.config?['app']?['title'] ?? "My App",
      theme: selectedTheme,
      darkTheme: appThemes['dark'] ?? ThemeData.dark(),
      themeMode: themeProvider.themeMode,
    );
  }
}
