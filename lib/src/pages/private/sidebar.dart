import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/widgets/core/app_name.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/service/core/auth_service.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appName = AppName();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: appName,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.go('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Calculator'),
            onTap: () {
              context.go('/calculator');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.pop();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              final authService = context.read<AuthService>();
              await authService.logout();
              if (!context.mounted) return;
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
