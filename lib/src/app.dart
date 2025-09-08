import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/pages/private/index.dart';
import 'package:my_app/src/pages/public/error/index.dart';
import 'package:my_app/src/pages/public/error/maintenance_page.dart';
import 'package:my_app/src/pages/public/error/not_found_page.dart';
import 'package:my_app/src/pages/public/index.dart';
import 'package:my_app/src/service/core/auth_service.dart';
import 'package:my_app/src/service/core/config_service.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = context.watch<ConfigService>();

    if (configService.loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (configService.error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text("Configuration Error")),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text("Failed to load app configuration.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(configService.error.toString(), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final maintenanceConfig = configService.config?['maintenance'];
    final bool isMaintenanceEnabled = maintenanceConfig is Map ? maintenanceConfig['enabled'] == true : false;

    if (isMaintenanceEnabled) {
      return const MaterialApp(
        home: MaintenancePage(),
        debugShowCheckedModeBanner: false,
      );
    }

    final GoRouter router = GoRouter(
      routes: <RouteBase>[...publicRoutes, ...privateRoutes, ...errorRoutes],
      redirect: (context, state) {
        final auth = context.read<AuthService>();
        final location = state.uri.toString();

        final loggingIn = location == '/signin' || location == '/signup';

        if (!auth.isLoggedIn && location == '/home') {
          return '/403';
        }

        if (auth.isLoggedIn && loggingIn) {
          return '/home';
        }
        return null;
      },
      errorBuilder: (context, state) => const NotFoundPage(),
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: configService.config?['app']?['title'] ?? "My App",
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
