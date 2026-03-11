import '../entities/resumo_cliente.dart';
import '../repositories/dashboard_repository.dart';

/// RN-038: Ranking de clientes por KM e número de atendimentos no período.
class ObterKmPorCliente {
  ObterKmPorCliente(this._repository);

  final DashboardRepository _repository;

  Future<List<ResumoCliente>> call({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    return _repository.obterKmPorCliente(inicio: inicio, fim: fim);
  }
}
