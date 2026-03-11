import '../entities/ponto_rastreamento.dart';
import '../repositories/rastreamento_repository.dart';

/// Retorna a lista de pontos GPS coletados para um atendimento.
class ObterPercurso {
  ObterPercurso(this._repository);

  final RastreamentoRepository _repository;

  Future<List<PontoRastreamento>> call(String atendimentoId) async {
    return _repository.obterPontosPorAtendimento(atendimentoId);
  }
}
