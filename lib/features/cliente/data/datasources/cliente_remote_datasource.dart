import '../models/cliente_model.dart';

/// Contrato para CRUD de clientes via API REST.
/// O backend ainda será construído — este contrato define o que se espera.
///
/// Endpoints esperados:
///   POST   /clientes        → { nome, telefone, documento?, endereco_default? }
///   GET    /clientes?q=...  → [ { cliente } ]
///   PUT    /clientes/:id    → { nome, telefone, documento?, endereco_default? }
///   GET    /clientes/:id    → { cliente }
abstract class ClienteRemoteDatasource {
  /// POST /clientes
  Future<ClienteModel> criar(ClienteModel model);

  /// PUT /clientes/:id
  Future<ClienteModel> atualizar(ClienteModel model);

  /// GET /clientes?q=...
  Future<List<ClienteModel>> buscar(String query);

  /// GET /clientes/:id
  Future<ClienteModel> obterPorId(String id);
}
