import 'dart:async';

import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/firebase_auth_provider.dart';
import 'package:drawing_together/providers/database_provider.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  AuthProvider({
    required this.firebaseAuthProvider,
    required this.databaseProvider,
  }) {
    firebaseAuthProvider.onUserModelChanged.listen((userModel) async {
      _rawUser = userModel;
      _user = await _setupUserData();
      _controller.add(_user);
    });
  }

  final DatabaseProvider databaseProvider;
  final FirebaseAuthProvider firebaseAuthProvider;
  RawUserModel? _rawUser;
  User? _user;

  final StreamController<User?> _controller = StreamController<User?>.broadcast();
  Stream<User?> get onUserChanged => _controller.stream;

  Future<User> _setupUserData() async {
    // check if user data saved in db
    final snapshot = await databaseProvider.ref.get();

    if (snapshot.exists) {
      final json = snapshot.value as Map<String, dynamic>;
      _user = User.fromJson(json);
    } else {
      // set up new user
      _user = User.createNewUser(_rawUser!);
      await databaseProvider.ref.set(_user!.toJson());
    }

    return _user!;
  }

  void dispose() {
    _controller.close();
  }

  Future<void> signOutUser() async {
    _controller.add(null);
    return firebaseAuthProvider.signOutUser();
  }
}
