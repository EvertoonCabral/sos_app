import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/usuario.dart';
import '../repositories/auth_repository.dart';

class AutenticarUsuario {
  AutenticarUsuario(this._repository);

  final AuthRepository _repository;

  Future<Usuario> call(AutenticarUsuarioParams params) async {
    if (params.email.trim().isEmpty) {
      throw const ValidationFailure(message: 'Email não pode ser vazio');
    }
    if (params.senha.trim().isEmpty) {
      throw const ValidationFailure(message: 'Senha não pode ser vazia');
    }

    return _repository.autenticar(
      email: params.email.trim(),
      senha: params.senha,
    );
  }
}

class AutenticarUsuarioParams extends Equatable {
  const AutenticarUsuarioParams({
    required this.email,
    required this.senha,
  });

  final String email;
  final String senha;

  @override
  List<Object?> get props => [email, senha];
}
