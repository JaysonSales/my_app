import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _loading = true;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((usr) {
      _loading = true;
      notifyListeners();

      if (usr == null) {
        _user = null;
        _error = null;
      } else {
        _user = usr;
        _error = null;
      }

      _loading = false;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
