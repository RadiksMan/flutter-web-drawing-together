import 'package:bloc/bloc.dart';
import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/auth_provider.dart';
import 'package:drawing_together/providers/firebase_auth_provider.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthProvider authProvider;
  final FirebaseAuthProvider firebaseAuthProvider;

  //late User _userData;

  AuthenticationBloc({
    required this.authProvider,
    required this.firebaseAuthProvider,
  }) : super(AuthenticationInitial()) {
    firebaseAuthProvider.onUserModelChanged.listen((usr) {
      if (usr is RawUserModel) {
        add(const AuthenticationSignUpUser());
      }
    });

    on<AuthenticationSignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        //_userData = await authProvider.setupUserData();

        //emit(AuthenticationSuccess(_userData));
      } catch (e) {
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
