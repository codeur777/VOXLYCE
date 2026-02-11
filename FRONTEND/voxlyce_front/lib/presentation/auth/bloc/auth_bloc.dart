import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/auth_response_model.dart';

/// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<Verify2FARequested>(_onVerify2FARequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authResponse = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      if (authResponse.requires2FA) {
        emit(Auth2FARequired(event.email));
      } else {
        emit(AuthAuthenticated(authResponse));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authResponse = await _authRepository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        role: event.role,
        classroom: event.classroom,
      );

      emit(AuthAuthenticated(authResponse));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerify2FARequested(
    Verify2FARequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authResponse = await _authRepository.verify2FA(
        email: event.email,
        code: event.code,
      );

      emit(AuthAuthenticated(authResponse));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      final role = await _authRepository.getUserRole();
      // Create a minimal auth response for checking status
      emit(AuthAuthenticated(
        AuthResponseModel(
          email: '',
          role: role ?? 'STUDENT',
          requires2FA: false,
        ),
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
