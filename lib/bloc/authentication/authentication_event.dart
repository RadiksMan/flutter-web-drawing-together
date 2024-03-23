part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class AuthenticationSignUpUser extends AuthenticationEvent {
  const AuthenticationSignUpUser();

  @override
  List<Object> get props => [];
}

class AuthenticationSignOut extends AuthenticationEvent {}
