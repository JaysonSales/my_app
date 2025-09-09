import 'package:flutter/material.dart';
import 'package:my_app/src/service/core/config_service.dart';
import 'package:provider/provider.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = Provider.of<ConfigService>(context);
    final appName = configService.config?['app']['name'] ?? 'My App';

    return Text(
      appName,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
