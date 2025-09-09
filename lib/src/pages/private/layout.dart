import 'package:flutter/material.dart';
import 'sidebar.dart';

class PrivateLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const PrivateLayout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const SideBar(),
      body: child,
    );
  }
}
