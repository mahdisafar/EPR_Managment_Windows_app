part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStartedEvent extends AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  final String password;

  const LoginSubmittedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class LogoutEvent extends AuthEvent {}

class ChangePasswordSubmittedEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordSubmittedEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword, confirmPassword];
}
