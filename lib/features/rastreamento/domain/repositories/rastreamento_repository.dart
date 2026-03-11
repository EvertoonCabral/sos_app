import '../entities/ponto_rastreamento.dart';

abstract class RastreamentoRepository {
  Future<void> salvarPonto(PontoRastreamento ponto);
  Future<List<PontoRastreamento>> obterPontosPorAtendimento(
      String atendimentoId);
  Future<void> marcarComoSincronizados(List<String> ids);
  Future<List<PontoRastreamento>> obterNaoSincronizados();
}
