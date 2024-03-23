import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../models/user.dart';

class FirebaseAuthProvider {
  FirebaseAuthProvider() : _firebaseAuth = fb_auth.FirebaseAuth.instance {
    //listen auth changes (user logins via google button || login form)
    _firebaseAuth.authStateChanges().listen((usr) {
      if (usr is fb_auth.User && _rawUser == null) {
        _rawUser = getUserModelFromFirebaseUser(usr);
        _controller.add(_rawUser);
      } else if (usr == null && _rawUser != null) {
        _controller.add(null);
        _rawUser = null;
      }
    });
  }

  final fb_auth.FirebaseAuth _firebaseAuth;
  RawUserModel? _rawUser;

  final StreamController<RawUserModel?> _controller = StreamController<RawUserModel?>.broadcast();
  Stream<RawUserModel?> get onUserModelChanged => _controller.stream;

  void dispose() {
    _controller.close();
  }

  RawUserModel getUserModelFromFirebaseUser(fb_auth.User firebaseUser) => RawUserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
      );

  ///signOutUser
  Future<void> signOutUser() async {
    final fb_auth.User? firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await fb_auth.FirebaseAuth.instance.signOut();
    }
  }
}
