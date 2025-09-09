import 'package:flutter/material.dart';
import 'package:my_app/src/service/core/auth_service.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Welcome, ${user.name}!!')));
  }
}
