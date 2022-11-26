import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthGGLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends AuthState {
  final String message;
  const RegisterSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthVerification extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthFail extends AuthState {
  final String? code;
  final String? error;

  const AuthFail({this.code, this.error});
  @override
  List<Object?> get props => [code, error];
}
