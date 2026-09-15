part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthAuthenticated extends AuthState {}

class AuthPasswordChanged extends AuthState {}

class AuthPasswordChangeError extends AuthState {
  final String message;

  const AuthPasswordChangeError(this.message);

  @override
  List<Object> get props => [message];
}
