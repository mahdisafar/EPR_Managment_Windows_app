import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.changePasswordUseCase,
  }) : super(AuthInitial()) {
    on<AuthStartedEvent>(_onStarted);
    on<LoginSubmittedEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<ChangePasswordSubmittedEvent>(_onChangePassword);
  }

  Future<void> _onStarted(
    AuthStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await loginUseCase('');
    emit(const AuthUnauthenticated());
  }

  Future<void> _onLogin(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.password);
    result.fold(
      (failure) => emit(AuthUnauthenticated(message: failure.message)),
      (isValid) => isValid
          ? emit(AuthAuthenticated())
          : emit(const AuthUnauthenticated(message: 'رمز عبور اشتباه است.')),
    );
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    emit(const AuthUnauthenticated());
  }

  Future<void> _onChangePassword(
    ChangePasswordSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await changePasswordUseCase.execute(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );
    result.fold(
      (failure) => emit(AuthPasswordChangeError(failure.message)),
      (_) => emit(AuthPasswordChanged()),
    );
  }
}
