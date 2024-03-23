import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/firebase_auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseProvider {
  DatabaseProvider({required this.firebaseAuthProvider}) : _database = FirebaseDatabase.instance {
    firebaseAuthProvider.onUserModelChanged.listen((userModel) {
      _user = userModel;
    });
  }

  final FirebaseAuthProvider firebaseAuthProvider;
  final FirebaseDatabase _database;
  RawUserModel? _user;

  FirebaseDatabase get database => _database;

  // get ref db for logged user
  DatabaseReference get ref {
    if (_user == null) {
      throw Exception('No logged user presented.');
    }

    return _database.ref().child('users/${_user!.id}');
  }
}
