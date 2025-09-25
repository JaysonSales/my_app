import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:my_app/src/app.dart';
import 'package:my_app/src/provider/core/config_provider.dart';
import 'package:my_app/src/provider/core/gcloud_provider.dart';
import 'package:my_app/src/provider/core/auth_provider.dart';
import 'package:my_app/src/provider/core/user_provider.dart';
import 'package:my_app/src/provider/theme/theme_provider.dart';
import 'package:my_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configProvider = ConfigProvider();
  await configProvider.loadConfig();

  final firebaseOptions = DefaultFirebaseOptions.currentPlatform(
    configProvider,
  );
  await Firebase.initializeApp(options: firebaseOptions);

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
    );
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfigProvider>.value(value: configProvider),
        ChangeNotifierProvider<GCloudProvider>(
          create: (_) => GCloudProvider(firebaseOptions),
        ),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<GCloudProvider, UserProvider>(
          create: (_) => UserProvider(auth: null, db: null),
          update: (context, gcloudProvider, previous) {
            final gcloud = gcloudProvider.gcloud;
            if (gcloud == null) {
              previous?.setLoading(true);
              return previous!;
            }
            previous?.updateAuthAndDb(gcloud.auth, gcloud.db);
            return previous!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
