import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../entities/local_geo.dart';
import 'geo_service.dart';

/// Implementação real do [GeoService] usando geolocator + geocoding.
///
/// Nota: A integração com Google Places Autocomplete é feita no widget
/// (flutter_google_places_sdk). Esta classe cuida de geocoding, reverse
/// geocoding e localização GPS.
class GeoServiceImpl implements GeoService {
  @override
  Future<List<LocalGeo>> autocompletar(String query) async {
    // Implementação futura com Google Places Autocomplete API.
    // No momento, retorna lista vazia; o widget usa flutter_google_places_sdk.
    return [];
  }

  @override
  Future<LocalGeo?> geocodificar(String endereco) async {
    final locations = await geocoding.locationFromAddress(endereco);
    if (locations.isEmpty) return null;
    final loc = locations.first;

    final placemarks = await geocoding.placemarkFromCoordinates(
      loc.latitude,
      loc.longitude,
    );
    final rua =
        placemarks.isNotEmpty ? _formatPlacemark(placemarks.first) : endereco;

    return LocalGeo(
      enderecoTexto: rua,
      latitude: loc.latitude,
      longitude: loc.longitude,
    );
  }

  @override
  Future<LocalGeo?> reverseGeocodificar(
      double latitude, double longitude) async {
    final placemarks =
        await geocoding.placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) return null;

    return LocalGeo(
      enderecoTexto: _formatPlacemark(placemarks.first),
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<LocalGeo?> obterLocalizacaoAtual() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );

    return reverseGeocodificar(position.latitude, position.longitude);
  }

  String _formatPlacemark(geocoding.Placemark p) {
    final parts = <String>[
      if (p.thoroughfare != null && p.thoroughfare!.isNotEmpty) p.thoroughfare!,
      if (p.subThoroughfare != null && p.subThoroughfare!.isNotEmpty)
        p.subThoroughfare!,
      if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality!,
      if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
    ];
    return parts.isEmpty ? 'Endereço desconhecido' : parts.join(', ');
  }
}
