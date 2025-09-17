import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Api {
  Future<Map<String, dynamic>> get(String path) async {
    await Future.delayed(Duration(seconds: 1));
    if (path == "/whoami") {
      return {"id": "123", "name": "John Doe"};
    }
    throw Exception("Unknown path");
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name']);
  }
}

class UserProvider extends ChangeNotifier {
  final Api api;

  bool loading = true;
  User? user;
  Object? error;

  UserProvider({required this.api}) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    loading = true;
    error = null;
    user = null;
    notifyListeners();

    try {
      final data = await api.get("/whoami");
      if (data['id'] != null) {
        user = User.fromJson(data);
      } else {
        throw Exception("Account not verified");
      }
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

// Hook-like shortcut (like useUser)
UserProvider useUser(BuildContext context) {
  return Provider.of<UserProvider>(context, listen: true);
}
