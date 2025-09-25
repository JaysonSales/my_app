import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GCloud {
  final FirebaseApp app;
  final FirebaseAuth auth;
  final FirebaseFirestore db;
  final FirebaseStorage storage;

  GCloud({
    required this.app,
    required this.auth,
    required this.db,
    required this.storage,
  });
}

class GCloudProvider with ChangeNotifier {
  bool _loading = true;
  GCloud? _gcloud;
  String? _error;

  bool get loading => _loading;
  GCloud? get gcloud => _gcloud;
  String? get error => _error;

  GCloudProvider(FirebaseOptions options) {
    _init(options);
  }

  Future<void> _init(FirebaseOptions options) async {
    try {
      final app = await Firebase.initializeApp(options: options);

      final auth = FirebaseAuth.instanceFor(app: app);
      final db = FirebaseFirestore.instanceFor(app: app);
      final storage = FirebaseStorage.instanceFor(app: app);

      _gcloud = GCloud(app: app, auth: auth, db: db, storage: storage);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
