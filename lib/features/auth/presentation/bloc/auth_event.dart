import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSolicitado extends AuthEvent {
  const LoginSolicitado({required this.email, required this.senha});

  final String email;
  final String senha;

  @override
  List<Object?> get props => [email, senha];
}

class LogoutSolicitado extends AuthEvent {
  const LogoutSolicitado();
}

class SessaoVerificada extends AuthEvent {
  const SessaoVerificada();
}
