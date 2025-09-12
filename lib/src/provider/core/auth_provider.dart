import 'dart:async';

class User {
  final String email;
  final String password;
  final String firstName;
  final String? middleName;
  final String lastName;
  final DateTime birthDate;
  final String location;

  const User({
    required this.email,
    required this.password,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.location,
  });

  String get fullName {
    if (middleName != null && middleName!.isNotEmpty) {
      return "$firstName ${middleName![0]}. $lastName";
    }
    return "$firstName $lastName";
  }
}

class AuthService {
  static final List<User> _users = [
    User(
      email: 'test@example.com',
      password: 'password',
      firstName: "Test",
      lastName: "User",
      birthDate: DateTime(1995, 5, 20),
      location: "New York, USA",
    ),
    User(
      email: 'user1@example.com',
      password: 'pass1',
      firstName: "User",
      lastName: "One",
      birthDate: DateTime(1990, 1, 1),
      location: "California, USA",
    ),
    User(
      email: 'user2@example.com',
      password: 'pass2',
      firstName: "User",
      lastName: "Two",
      birthDate: DateTime(1992, 6, 15),
      location: "Texas, USA",
    ),
    User(
      email: 'jayson',
      password: 'kahitano',
      firstName: "Jayson",
      lastName: "Sales",
      middleName: "V",
      birthDate: DateTime(2000, 12, 5),
      location: "Philippines",
    ),
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

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    String? middleName,
    required String lastName,
    required DateTime birthDate,
    required String location,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    for (final user in _users) {
      if (user.email == email) {
        throw Exception('Email already exists');
      }
    }

    final newUser = User(
      email: email,
      password: password,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      birthDate: birthDate,
      location: location,
    );

    _users.add(newUser);
    _currentUser = newUser;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  bool get isLoggedIn => _currentUser != null;

  List<User> get allUsers => List.unmodifiable(_users);
}
