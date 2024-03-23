import 'package:drawing_together/bloc/authentication/authentication_bloc.dart';
import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/auth_provider.dart';
import 'package:drawing_together/providers/database_provider.dart';
import 'package:drawing_together/utils/firebase_options.dart';
import 'package:drawing_together/home_screen.dart';
import 'package:drawing_together/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drawing_together/providers/firebase_auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // Firebase configuration
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MaterialApp(home: RootWidget()));
}

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  late final FirebaseAuthProvider firebaseAuthProvider;
  late final DatabaseProvider databaseProvider;
  late final AuthProvider authProvider;

  @override
  void initState() {
    super.initState();

    firebaseAuthProvider = FirebaseAuthProvider();
    databaseProvider = DatabaseProvider(firebaseAuthProvider: firebaseAuthProvider);
    authProvider = AuthProvider(
      firebaseAuthProvider: firebaseAuthProvider,
      databaseProvider: databaseProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: firebaseAuthProvider),
        RepositoryProvider.value(value: databaseProvider),
        RepositoryProvider.value(value: authProvider),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              firebaseAuthProvider: firebaseAuthProvider,
              authProvider: authProvider,
            ),
          ),
        ],
        child: Scaffold(
          body: StreamBuilder<RawUserModel?>(
            stream: firebaseAuthProvider.onUserModelChanged,
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
