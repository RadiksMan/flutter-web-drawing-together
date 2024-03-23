import 'package:drawing_together/bloc/authentication/authentication_bloc.dart';
import 'package:drawing_together/providers/database_provider.dart';
import 'package:drawing_together/repository/auth_repository.dart';
import 'package:drawing_together/utils/firebase_options.dart';
import 'package:drawing_together/home_screen.dart';
import 'package:drawing_together/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drawing_together/providers/authentication_provider.dart';

void main() async {
  // Firebase configuration
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MaterialApp(home: RootWidget()));
}

class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider();
    final databaseProvider = DatabaseProvider(authProvider: authProvider);

    final authRepository = AuthRepository(authProvider: authProvider, databaseProvider: databaseProvider);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authProvider),
        RepositoryProvider.value(value: databaseProvider),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authProvider: authProvider,
              authRepository: authRepository,
            ),
          ),
        ],
        child: Scaffold(
          body: StreamBuilder<User?>(
            stream: authProvider.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return const SignupScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
