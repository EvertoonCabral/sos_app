import '../../../../core/error/failures.dart';
import '../entities/cliente.dart';
import '../repositories/cliente_repository.dart';

class AtualizarCliente {
  AtualizarCliente(this._repository);

  final ClienteRepository _repository;

  Future<Cliente> call(Cliente cliente) async {
    if (cliente.nome.trim().isEmpty) {
      throw const ValidationFailure(message: 'Nome não pode ser vazio');
    }
    if (cliente.telefone.trim().isEmpty) {
      throw const ValidationFailure(message: 'Telefone não pode ser vazio');
    }

    final atualizado = cliente.copyWith(atualizadoEm: DateTime.now());
    return _repository.atualizar(atualizado);
  }
}
