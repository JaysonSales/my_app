import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/service/core/auth_service.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              
              if (!context.mounted) return;
              context.go('/');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, ${user.name}!!'),
      ),
    );
  }
}
