import '../models/ponto_rastreamento_model.dart';

/// Datasource remoto para pontos de rastreamento (API REST).
abstract class RastreamentoRemoteDatasource {
  Future<void> enviarPontos(List<PontoRastreamentoModel> pontos);
  Future<List<PontoRastreamentoModel>> obterPontosPorAtendimento(
      String atendimentoId);
}
