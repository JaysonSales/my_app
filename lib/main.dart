import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/app.dart';
import 'package:my_app/src/provider/core/auth_provider.dart';
import 'package:my_app/src/provider/core/config_provider.dart';
import 'package:my_app/src/provider/theme/theme_provider.dart';
import 'package:my_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final configProvider = ConfigProvider();
  await configProvider.loadConfig();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform(configProvider),
  );

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
    );
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ConfigProvider>(create: (_) => configProvider),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
