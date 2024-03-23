import 'package:bloc/bloc.dart';
import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/authentication_provider.dart';
import 'package:drawing_together/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthProvider authProvider;
  final AuthRepository authRepository;

  AuthenticationBloc({
    required this.authProvider,
    required this.authRepository,
  }) : super(AuthenticationInitial()) {
    authProvider.onAuthStateChanged.listen((usr) {
      if (usr is User) {
        add(const AuthenticationSignUpUser());
      }
    });

    on<AuthenticationSignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        assert(authProvider.user != null);

        final user = await authRepository.setupUserData();

        emit(AuthenticationSuccess(user));
      } catch (e) {
        print(e.toString());
        emit(const AuthenticationFailure('create user failed'));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<AuthenticationSignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        authProvider.signOutUser();
      } catch (e) {
        // print('error');
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}
