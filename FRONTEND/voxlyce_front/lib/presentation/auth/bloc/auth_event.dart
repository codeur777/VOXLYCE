import 'package:equatable/equatable.dart';

/// Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;
  final String? classroom;

  const RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
    this.classroom,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password, role, classroom];
}

class Verify2FARequested extends AuthEvent {
  final String email;
  final String code;

  const Verify2FARequested({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
