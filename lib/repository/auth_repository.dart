import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/authentication_provider.dart';
import 'package:drawing_together/providers/database_provider.dart';

class AuthRepository {
  AuthRepository({
    required this.authProvider,
    required this.databaseProvider,
  });

  final AuthProvider authProvider;
  final DatabaseProvider databaseProvider;

  Future<DrawUser> setupUserData() async {
    // check if user data saved in db
    final snapshot = await databaseProvider.ref.get();

    if (snapshot.exists) {
      print('snapshot.exists ');
      final json = snapshot.value as Map<String, dynamic>;
      print(json);
      return DrawUser.fromJson(json);
    } else {
      // set up new user
      final newDrawUser = DrawUser.createNewUser(authProvider.user!);
      await databaseProvider.ref.set(newDrawUser.toJson());

      print('set up new user $newDrawUser');
      return newDrawUser;
    }
  }
}
