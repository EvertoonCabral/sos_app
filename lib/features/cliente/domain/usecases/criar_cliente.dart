import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/cliente.dart';
import '../repositories/cliente_repository.dart';

class CriarCliente {
  CriarCliente(this._repository);

  final ClienteRepository _repository;

  Future<Cliente> call(CriarClienteParams params) async {
    if (params.nome.trim().isEmpty) {
      throw const ValidationFailure(message: 'Nome não pode ser vazio');
    }
    if (params.telefone.trim().isEmpty) {
      throw const ValidationFailure(message: 'Telefone não pode ser vazio');
    }

    return _repository.criar(params.toCliente());
  }
}

class CriarClienteParams extends Equatable {
  const CriarClienteParams({
    required this.id,
    required this.nome,
    required this.telefone,
    this.documento,
  });

  final String id;
  final String nome;
  final String telefone;
  final String? documento;

  Cliente toCliente() {
    final now = DateTime.now();
    return Cliente(
      id: id,
      nome: nome.trim(),
      telefone: telefone.trim(),
      documento: documento?.trim(),
      criadoEm: now,
      atualizadoEm: now,
    );
  }

  @override
  List<Object?> get props => [id, nome, telefone, documento];
}
