import 'package:flutter/material.dart';
import 'package:my_app/src/provider/core/config_provider.dart';
import 'package:provider/provider.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = Provider.of<ConfigService>(context);
    final appName = configService.config?['app']['name'] ?? 'My App';
    final theme = Theme.of(context);

    return Text(appName, style: theme.textTheme.titleLarge);
  }
}
