import 'dart:math';

/// Ponto geográfico simples para cálculos de distância.
/// Dart puro — sem dependência de Flutter.
class PontoGeo {
  const PontoGeo({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

/// Calcula distâncias geográficas usando a fórmula de Haversine.
/// Dart puro — sem dependência de Flutter ou geolocator.
class DistanceCalculator {
  static const double _earthRadiusKm = 6371.0;

  /// Retorna a distância total em km a partir de uma lista de pontos GPS.
  /// Cobre o percurso completo: soma Haversine entre pontos consecutivos.
  double calcularTotal(List<PontoGeo> pontos) {
    if (pontos.length < 2) return 0.0;

    double total = 0.0;
    for (int i = 0; i < pontos.length - 1; i++) {
      total += _haversine(
        pontos[i].latitude,
        pontos[i].longitude,
        pontos[i + 1].latitude,
        pontos[i + 1].longitude,
      );
    }
    return total;
  }

  /// Estimativa com 4 pontos fixos (usado na criação do atendimento).
  /// RN-010: saída→coleta + coleta→entrega + entrega→retorno.
  double calcularEstimativa({
    required PontoGeo saida,
    required PontoGeo coleta,
    required PontoGeo entrega,
    required PontoGeo retorno,
  }) {
    double km = 0.0;
    km += _haversine(
      saida.latitude,
      saida.longitude,
      coleta.latitude,
      coleta.longitude,
    );
    km += _haversine(
      coleta.latitude,
      coleta.longitude,
      entrega.latitude,
      entrega.longitude,
    );
    km += _haversine(
      entrega.latitude,
      entrega.longitude,
      retorno.latitude,
      retorno.longitude,
    );
    return km;
  }

  /// Fórmula de Haversine — retorna distância em km entre dois pontos.
  double _haversine(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180.0;
}
