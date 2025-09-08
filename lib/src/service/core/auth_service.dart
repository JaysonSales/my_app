import 'dart:async';

class User {
  final String email;
  final String password;
  final String name;

  const User({required this.email, required this.password, required this.name});
}

class AuthService {
  static final List<User> _users = [
    const User(email: 'test@example.com', password: 'password', name: "Test User"),
    const User(email: 'user1@example.com', password: 'pass1', name: "User One"),
    const User(email: 'user2@example.com', password: 'pass2', name: "User Two"),
    const User(email: 'jayson', password: 'kahitano', name: "Jayson"),
  ];

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    for (final user in _users) {
      if (user.email == email && user.password == password) {
        _currentUser = user;
        return user;
      }
    }
    return null;
  }

  Future<void> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    for (final user in _users) {
      if (user.email == email) {
        throw Exception('User already exists');
      }
    }

    final newUser = User(email: email, password: password, name: 'New User');
    _users.add(newUser);
    _currentUser = newUser;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  bool get isLoggedIn => _currentUser != null;
}
