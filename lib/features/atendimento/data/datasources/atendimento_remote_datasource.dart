import '../models/atendimento_model.dart';

/// Datasource remoto para Atendimentos (API REST).
abstract class AtendimentoRemoteDatasource {
  Future<AtendimentoModel> criar(AtendimentoModel model);
  Future<List<AtendimentoModel>> listarTodos();
  Future<AtendimentoModel> atualizar(AtendimentoModel model);
}
