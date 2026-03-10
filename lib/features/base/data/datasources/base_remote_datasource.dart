import '../models/base_model.dart';

/// Contrato do datasource remoto para Bases.
/// Define a API esperada quando o backend estiver disponível.
abstract class BaseRemoteDatasource {
  /// POST /bases
  Future<BaseModel> criar(BaseModel model);

  /// GET /bases
  Future<List<BaseModel>> listarTodas();

  /// PUT /bases/:id/principal
  Future<BaseModel> definirPrincipal(String id);
}
