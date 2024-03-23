import 'package:drawing_together/providers/authentication_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseProvider {
  DatabaseProvider({required this.authProvider}) : _database = FirebaseDatabase.instance;

  final AuthProvider authProvider;
  final FirebaseDatabase _database;

  FirebaseDatabase get database => _database;

  // get ref db for logged user
  DatabaseReference get ref {
    if (authProvider.user == null) {
      throw Exception('No logged user presented.');
    }

    return _database.ref().child('users/${authProvider.user!.id}');
  }
}
