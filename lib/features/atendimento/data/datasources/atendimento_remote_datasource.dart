import '../models/atendimento_model.dart';

/// Datasource remoto para Atendimentos (API REST).
abstract class AtendimentoRemoteDatasource {
  Future<AtendimentoModel> criar(AtendimentoModel model);
  Future<List<AtendimentoModel>> listarTodos({
    String? status,
    int page = 1,
    int pageSize = 20,
  });
  Future<AtendimentoModel> atualizar(AtendimentoModel model);
}
