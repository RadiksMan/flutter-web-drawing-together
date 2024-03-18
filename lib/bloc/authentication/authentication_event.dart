part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class AuthenticationSignUpUser extends AuthenticationEvent {
  final String email;
  final String password;

  const AuthenticationSignUpUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthenticationSignOut extends AuthenticationEvent {}
