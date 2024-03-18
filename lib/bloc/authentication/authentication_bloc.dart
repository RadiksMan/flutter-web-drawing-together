import 'package:bloc/bloc.dart';
import 'package:drawing_together/models/user.dart';
import 'package:drawing_together/providers/authentication.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthProvider authProvider;

  AuthenticationBloc({
    required this.authProvider,
  }) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {});

    on<AuthenticationSignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user = await authProvider.signUpUser(event.email, event.password);
        if (user != null) {
          emit(AuthenticationSuccess(user));
        } else {
          emit(const AuthenticationFailure('create user failed'));
        }
      } catch (e) {
        //print(e.toString());
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
