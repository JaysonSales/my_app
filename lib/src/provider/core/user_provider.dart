import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class UserProfile {
  final String uid;
  final String email;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final DateTime? birthDate;
  final String? location;

  UserProfile({
    required this.uid,
    required this.email,
    this.firstName,
    this.middleName,
    this.lastName,
    this.birthDate,
    this.location,
  });

  String get fullName {
    final names = [
      firstName,
      middleName,
      lastName,
    ].where((n) => n != null && n.isNotEmpty).join(' ');
    return names.isNotEmpty ? names : email;
  }

  factory UserProfile.fromFirebaseUser(User user) {
    return UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      firstName: user.displayName,
    );
  }

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      email: data['email'] ?? '',
      firstName: data['firstName'],
      middleName: data['middleName'],
      lastName: data['lastName'],
      birthDate: data['birthDate'] != null
          ? (data['birthDate'] as Timestamp).toDate()
          : null,
      location: data['location'],
    );
  }
}

class UserProvider with ChangeNotifier {
  FirebaseAuth? _auth;
  FirebaseFirestore? _db;
  UserProfile? _userProfile;
  bool _loading = true;
  StreamSubscription<User?>? _authSubscription;
  bool _justLoggedIn = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoggedIn => _userProfile != null;
  bool get loading => _loading;
  bool get justLoggedIn => _justLoggedIn;

  UserProvider({FirebaseAuth? auth, FirebaseFirestore? db}) {
    _auth = auth;
    _db = db;
    if (_auth != null) {
      _authSubscription = _auth!.authStateChanges().listen(_onAuthStateChanged);
    } else {
      _loading = false;
    }
  }

  void updateAuthAndDb(FirebaseAuth auth, FirebaseFirestore db) {
    _auth = auth;
    _db = db;
    _authSubscription?.cancel();
    _authSubscription = _auth!.authStateChanges().listen(_onAuthStateChanged);
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _userProfile = null;
    } else if (_db != null) {
      final doc = await _db!.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        _userProfile = UserProfile.fromFirestore(user.uid, doc.data()!);
      } else {
        _userProfile = UserProfile.fromFirebaseUser(user);
      }
    } else {
      _userProfile = UserProfile.fromFirebaseUser(user);
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    if (_auth == null) return;
    await _auth!.signInWithEmailAndPassword(email: email, password: password);
    _justLoggedIn = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      _justLoggedIn = false;
      notifyListeners();
    });
  }

  Future<void> register({
    required String email,
    required String password,
    String? firstName,
    String? middleName,
    String? lastName,
    DateTime? birthDate,
    String? location,
  }) async {
    if (_auth == null || _db == null) return;

    UserCredential userCredential = await _auth!.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      await user.updateDisplayName('$firstName $lastName');

      await _db!.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate,
        'middleName': middleName,
        'email': email,
        'location': location,
      });
    }
  }

  Future<void> signOut() async {
    if (_auth == null) return;
    await _auth!.signOut();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
