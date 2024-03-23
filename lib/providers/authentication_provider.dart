import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AuthProvider {
  AuthProvider() : _firebaseAuth = FirebaseAuth.instance {
    //listen auth changes (user logins via google button || login form)
    _onAuthStateChanged = _firebaseAuth.authStateChanges()
      ..listen((usr) {
        if (usr is User && _user == null) {
          _user = getUserModelFromFirebaseUser(usr);
        }
      });
  }

  final FirebaseAuth _firebaseAuth;
  late final Stream<User?> _onAuthStateChanged;
  UserModel? _user;

  UserModel? get user => _user;

  Stream<User?> get onAuthStateChanged => _onAuthStateChanged;

  UserModel getUserModelFromFirebaseUser(User firebaseUser) => UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
      );

  ///signOutUser
  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
      _user = null;
    }
  }
}
