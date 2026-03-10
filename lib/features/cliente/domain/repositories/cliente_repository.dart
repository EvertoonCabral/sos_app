import '../entities/cliente.dart';

/// Contrato do repositório de clientes.
/// Dart puro — sem dependências de Flutter ou pacotes externos.
abstract class ClienteRepository {
  /// Cria um novo cliente e o persiste localmente.
  /// Adiciona à fila de sincronização.
  Future<Cliente> criar(Cliente cliente);

  /// Busca clientes pelo nome ou telefone (busca parcial).
  /// Retorna lista vazia se nenhum resultado.
  Future<List<Cliente>> buscar(String query);

  /// Atualiza um cliente existente.
  /// Adiciona à fila de sincronização.
  Future<Cliente> atualizar(Cliente cliente);

  /// Obtém um cliente pelo ID.
  /// Retorna `null` se não encontrado.
  Future<Cliente?> obterPorId(String id);

  /// Lista todos os clientes ordenados por nome.
  Future<List<Cliente>> listarTodos();
}
