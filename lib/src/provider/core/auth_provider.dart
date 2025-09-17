import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('AuthProvider');

class UserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;
  final DateTime birthDate;
  final String location;

  UserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.location,
  });

  String get fullName {
    if (middleName != null && middleName!.isNotEmpty) {
      return '$firstName $middleName $lastName';
    }
    return '$firstName $lastName';
  }

  static UserProfile fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      email: data['email'] as String? ?? 'no-email@placeholder.com',
      firstName: data['firstName'] as String? ?? '',
      middleName: data['middleName'] as String?,
      lastName: data['lastName'] as String? ?? '',
      birthDate: (data['birthDate'] is Timestamp)
          ? (data['birthDate'] as Timestamp).toDate()
          : DateTime.now(),
      location: data['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'birthDate': Timestamp.fromDate(birthDate),
      'location': location,
    };
  }
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfile? _currentUserProfile;
  bool _loading = true;
  String? _error;
  late final StreamSubscription<User?> _authSubscription;

  UserProfile? get currentUserProfile => _currentUserProfile;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn =>
      _auth.currentUser != null && _currentUserProfile != null;

  AuthProvider() {
    _authSubscription = _auth.authStateChanges().listen((user) async {
      _loading = true;
      _error = null;
      notifyListeners();

      if (user != null) {
        _logger.info('User signed in: ${user.uid}');
        await _loadOrCreateUserProfile(user);
      } else {
        _logger.info('User signed out.');
        _currentUserProfile = null;
        _loading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _loadOrCreateUserProfile(User user) async {
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        try {
          _currentUserProfile = UserProfile.fromMap(
            user.uid,
            docSnapshot.data()!,
          );
          _logger.info('Loaded user profile for ${user.uid}');
        } catch (e, stack) {
          _logger.severe(
            'Failed to map user profile for ${user.uid}',
            e,
            stack,
          );
          _error = 'Failed to load user profile. Malformed data.';
          _currentUserProfile = null;
          await _firestore.collection('users').doc(user.uid).delete();
          _logger.warning(
            'Deleted corrupted user profile document for ${user.uid}.',
          );
        }
      } else {
        final newProfile = UserProfile(
          uid: user.uid,
          email: user.email!,
          firstName: '',
          lastName: '',
          birthDate: DateTime.now(),
          location: '',
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newProfile.toMap());
        _currentUserProfile = newProfile;
        _logger.warning(
          'User profile not found for ${user.uid}, created a new one.',
        );
      }
    } catch (e, stack) {
      _logger.severe(
        'Failed to load or create user profile for ${user.uid}',
        e,
        stack,
      );
      _error = 'Failed to load user profile. Please try again.';
      _currentUserProfile = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<UserProfile?> login(String email, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _logger.info('User signed in: ${userCredential.user!.uid}');
      final user = userCredential.user;
      _logger.info('Login successful for ${user!.uid}');

      await _loadOrCreateUserProfile(user);
      return currentUserProfile;
    } on FirebaseAuthException catch (e) {
      _logger.warning('Login failed: ${e.message}');
      _error = e.message;
      _loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<UserProfile?> register({
    required String email,
    required String password,
    required String firstName,
    String? middleName,
    required String lastName,
    required DateTime birthDate,
    required String location,
  }) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );
      final uid = userCredential.user!.uid;

      final userProfile = UserProfile(
        uid: uid,
        email: email.toLowerCase().trim(),
        firstName: firstName.toLowerCase().trim(),
        middleName: middleName?.toLowerCase().trim(),
        lastName: lastName.toLowerCase().trim(),
        birthDate: birthDate,
        location: location.toLowerCase().trim(),
      );

      await _firestore.collection('users').doc(uid).set(userProfile.toMap());
      _currentUserProfile = userProfile;
      _logger.info('User registered: $uid');
      _loading = false;
      notifyListeners();
      return userProfile;
    } on FirebaseAuthException catch (e) {
      _logger.warning('Registration failed: ${e.message}');
      _error = e.message;
      _loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _logger.info('User logged out');
    } on FirebaseAuthException catch (e) {
      _logger.warning('Logout failed: ${e.message}');
      _error = e.message;
      notifyListeners();
    }
  }
}
