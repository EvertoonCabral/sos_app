import '../entities/cliente.dart';
import '../repositories/cliente_repository.dart';

class BuscarClientes {
  BuscarClientes(this._repository);

  final ClienteRepository _repository;

  /// Busca clientes por query (nome ou telefone).
  /// Se query vazia, retorna todos.
  Future<List<Cliente>> call(String query) async {
    if (query.trim().isEmpty) {
      return _repository.listarTodos();
    }
    return _repository.buscar(query.trim());
  }
}
