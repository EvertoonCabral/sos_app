import '../entities/tempo_por_etapa.dart';
import '../repositories/dashboard_repository.dart';

/// RN-038: Análise de tempo médio por etapa de atendimentos concluídos.
class ObterTempoPorEtapa {
  ObterTempoPorEtapa(this._repository);

  final DashboardRepository _repository;

  Future<TempoPorEtapa> call({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    return _repository.obterTempoPorEtapa(inicio: inicio, fim: fim);
  }
}
