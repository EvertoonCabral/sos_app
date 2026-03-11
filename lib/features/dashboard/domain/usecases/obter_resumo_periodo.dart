import '../entities/resumo_periodo.dart';
import '../repositories/dashboard_repository.dart';

/// RN-038: Obtém resumo de métricas de produtividade para um período.
class ObterResumoPeriodo {
  ObterResumoPeriodo(this._repository);

  final DashboardRepository _repository;

  Future<ResumoPeriodo> call({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    return _repository.obterResumoPeriodo(inicio: inicio, fim: fim);
  }
}
