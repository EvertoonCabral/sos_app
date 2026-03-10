import '../../../../core/error/failures.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../core/entities/local_geo.dart';

/// RN-011: valor estimado = distância total estimada × valor por km.
/// RN-011B: retorno sempre é cobrado — distância inclui os 4 trechos.
class CalcularValorEstimado {
  CalcularValorEstimado(this._distanceCalculator);

  final DistanceCalculator _distanceCalculator;

  double call({
    required LocalGeo saida,
    required LocalGeo coleta,
    required LocalGeo entrega,
    required LocalGeo retorno,
    required double valorPorKm,
  }) {
    if (valorPorKm <= 0) {
      throw const ValidationFailure(
        message: 'Valor por km deve ser maior que zero',
      );
    }

    final distanciaKm = _distanceCalculator.calcularEstimativa(
      saida: PontoGeo(latitude: saida.latitude, longitude: saida.longitude),
      coleta: PontoGeo(latitude: coleta.latitude, longitude: coleta.longitude),
      entrega: PontoGeo(
        latitude: entrega.latitude,
        longitude: entrega.longitude,
      ),
      retorno: PontoGeo(
        latitude: retorno.latitude,
        longitude: retorno.longitude,
      ),
    );

    return distanciaKm * valorPorKm;
  }
}
