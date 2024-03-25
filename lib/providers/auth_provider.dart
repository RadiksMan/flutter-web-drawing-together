import 'dart:async';

import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/firebase_auth_provider.dart';
import 'package:drawing_together/providers/database_provider.dart';

class AuthProvider {
  AuthProvider({
    required this.firebaseAuthProvider,
    required this.databaseProvider,
  }) {
    firebaseAuthProvider.onUserModelChanged.listen((userModel) async {
      _rawUser = userModel;
      _user = await _setupInitialUserData();
      _controller.add(_user);
    });
  }

  final DatabaseProvider databaseProvider;
  final FirebaseAuthProvider firebaseAuthProvider;
  RawUserModel? _rawUser;
  User? _user;

  final StreamController<User?> _controller = StreamController<User?>.broadcast();
  Stream<User?> get onUserChanged => _controller.stream;

  Future<User> _setupInitialUserData() async {
    // check if user data saved in db
    final snapshot = await databaseProvider.currentUser.get();

    if (snapshot.exists) {
      final json = snapshot.value as Map<String, dynamic>;
      _user = User.fromJson(json);
    } else {
      // set up new user
      _user = User.createNewUser(_rawUser!);
      await databaseProvider.currentUser.set(_user!.toJson());
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
