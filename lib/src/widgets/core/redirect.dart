
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectPage extends StatelessWidget {
  final String path;
  const RedirectPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(path);
    });
    return const SizedBox.shrink();
  }
}