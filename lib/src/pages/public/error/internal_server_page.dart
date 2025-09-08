import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InternalServerPage extends StatelessWidget {
  const InternalServerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internal Server Error"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 100),
            const SizedBox(height: 20),
            const Text(
              "500 - Internal Server Error",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Oops! Something went wrong on our end."),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text("Go Home"),
            ),
          ],
        ),
      ),
    );
  }
}
