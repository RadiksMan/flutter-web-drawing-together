import 'package:drawing_together/bloc/authentication/authentication_bloc.dart';
import 'package:drawing_together/utils/firebase_options.dart';
import 'package:drawing_together/home_screen.dart';
import 'package:drawing_together/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drawing_together/providers/authentication.dart';

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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authProvider),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authProvider: authProvider,
            ),
          ),
        ],
        child: Scaffold(
          body: StreamBuilder<User?>(
            stream: authProvider.authChanged(),
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
