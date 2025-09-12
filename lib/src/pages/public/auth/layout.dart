import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PublicLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hasLeading;

  const PublicLayout({
    super.key,
    this.hasLeading = false,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: theme.textTheme.titleMedium),
        leading: !hasLeading
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.go('/');
                },
              ),
      ),
      body: child,
    );
  }
}
