import '../entities/local_geo.dart';

/// Interface para serviços de geocoding e localização.
abstract class GeoService {
  /// Autocomplete de endereço → lista de sugestões (Google Places).
  Future<List<LocalGeo>> autocompletar(String query);

  /// Geocoding direto: endereço texto → coordenadas.
  Future<LocalGeo?> geocodificar(String endereco);

  /// Reverse geocoding: coordenadas → endereço texto.
  Future<LocalGeo?> reverseGeocodificar(double latitude, double longitude);

  /// Obtém a localização atual do dispositivo via GPS.
  Future<LocalGeo?> obterLocalizacaoAtual();
}
