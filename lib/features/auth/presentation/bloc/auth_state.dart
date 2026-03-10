import 'package:equatable/equatable.dart';

import '../../domain/entities/usuario.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInicial extends AuthState {
  const AuthInicial();
}

class AuthCarregando extends AuthState {
  const AuthCarregando();
}

class AuthAutenticado extends AuthState {
  const AuthAutenticado(this.usuario);

  final Usuario usuario;

  @override
  List<Object?> get props => [usuario];
}

class AuthNaoAutenticado extends AuthState {
  const AuthNaoAutenticado();
}

class AuthErro extends AuthState {
  const AuthErro(this.mensagem);

  final String mensagem;

  @override
  List<Object?> get props => [mensagem];
}
