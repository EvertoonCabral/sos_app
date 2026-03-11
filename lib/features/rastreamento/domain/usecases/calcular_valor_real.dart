import '../../../../core/error/failures.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../repositories/rastreamento_repository.dart';

/// RN-012: valor real = distância real percorrida × valor por km.
class CalcularValorReal {
  CalcularValorReal(this._repository, this._distanceCalculator);

  final RastreamentoRepository _repository;
  final DistanceCalculator _distanceCalculator;

  Future<double> call({
    required String atendimentoId,
    required double valorPorKm,
  }) async {
    if (valorPorKm <= 0) {
      throw const ValidationFailure(
        message: 'Valor por km deve ser maior que zero',
      );
    }

    final pontos = await _repository.obterPontosPorAtendimento(atendimentoId);

    if (pontos.isEmpty) {
      throw const ValidationFailure(
        message: 'Nenhum ponto de rastreamento encontrado',
      );
    }

    final pontosGeo = pontos
        .map((p) => PontoGeo(latitude: p.latitude, longitude: p.longitude))
        .toList();

    final distanciaKm = _distanceCalculator.calcularTotal(pontosGeo);
    return distanciaKm * valorPorKm;
  }
}
