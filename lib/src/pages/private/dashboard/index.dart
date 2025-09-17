import 'package:flutter/material.dart';
import 'package:my_app/src/provider/core/auth_provider.dart';

class HomePage extends StatelessWidget {
  final UserProfile user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Welcome, ${user.firstName}!!')));
  }
}
