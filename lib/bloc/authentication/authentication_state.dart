part of 'authentication_bloc.dart';

sealed class AuthenticationState {
  const AuthenticationState();

  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;

  AuthenticationLoadingState({required this.isLoading});
}

final class AuthenticationSuccess extends AuthenticationState {
  final User user;

  const AuthenticationSuccess(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthenticationFailure extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
