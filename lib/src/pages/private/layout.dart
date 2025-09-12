import 'package:flutter/material.dart';
import 'package:my_app/src/pages/private/sidebar.dart';

class PrivateLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const PrivateLayout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: theme.textTheme.titleMedium),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
      ),
      drawer: const SideBar(),
      body: child,
    );
  }
}
