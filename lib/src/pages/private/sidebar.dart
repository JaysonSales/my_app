import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/provider/core/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/widgets/messaging/confirm_dialog.dart';
import 'package:my_app/src/widgets/core/app_name.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appName = AppName();
    final theme = Theme.of(context);

    final currentRoute = GoRouterState.of(context).uri.toString();

    Widget buildMenuItem({
      required IconData icon,
      required String label,
      required String route,
    }) {
      final isSelected = currentRoute == route;

      return ListTile(
        leading: Icon(
          icon,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.primary : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor:
            // ignore: deprecated_member_use
            isSelected ? theme.colorScheme.primary.withOpacity(0.1) : null,
        enabled: !isSelected,
        onTap: () {
          context.go(route);
        },
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: theme.appBarTheme.backgroundColor),
            child: appName,
          ),
          buildMenuItem(icon: Icons.home, label: 'Home', route: '/home'),
          buildMenuItem(
            icon: Icons.calculate,
            label: 'Calculator',
            route: '/calculator',
          ),
          buildMenuItem(
            icon: Icons.settings,
            label: 'Settings',
            route: '/settings',
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              ConfirmDialog.showConfirmDialog(
                context: context,
                message: 'Are you sure you want to sign out?',
                successMessage: 'Signed out successfully',
                onAccept: () async {
                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  await userProvider.signOut();
                  if (!context.mounted) return;
                  context.go('/');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
