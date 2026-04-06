import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../entities/local_geo.dart';
import 'geo_service.dart';

/// Implementação real do [GeoService] usando geolocator + geocoding + Nominatim.
class GeoServiceImpl implements GeoService {
  /// Dio dedicado para chamadas externas (sem interceptors da API).
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'User-Agent': 'SosApp/1.0 (Flutter)',
      'Accept-Language': 'pt-BR,pt;q=0.9',
    },
  ));

  static const _nominatimUrl = 'https://nominatim.openstreetmap.org/search';

  @override
  Future<List<LocalGeo>> autocompletar(String query) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        _nominatimUrl,
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 5,
          'addressdetails': 1,
          'countrycodes': 'br',
        },
      );

      final data = response.data;
      if (data == null) return [];

      return data
          .whereType<Map<String, dynamic>>()
          .map((item) {
            final addr = item['address'] as Map<String, dynamic>?;
            final texto =
                _formatarEndereco(addr, item['display_name'] as String? ?? '');
            return LocalGeo(
              enderecoTexto: texto,
              latitude: double.tryParse(item['lat']?.toString() ?? '') ?? 0.0,
              longitude: double.tryParse(item['lon']?.toString() ?? '') ?? 0.0,
            );
          })
          .where((l) => l.enderecoTexto.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Formata o endereço de forma limpa a partir dos campos do Nominatim.
  String _formatarEndereco(Map<String, dynamic>? addr, String fallback) {
    if (addr == null) return fallback;

    final rua = addr['road'] as String? ?? '';
    final numero = addr['house_number'] as String? ?? '';
    final bairro =
        addr['suburb'] as String? ?? addr['neighbourhood'] as String? ?? '';
    final cidade = addr['city'] as String? ??
        addr['town'] as String? ??
        addr['village'] as String? ??
        '';
    final estado = addr['state'] as String? ?? '';

    final parts = <String>[
      if (rua.isNotEmpty) numero.isNotEmpty ? '$rua, $numero' : rua,
      if (bairro.isNotEmpty) bairro,
      if (cidade.isNotEmpty) cidade,
      if (estado.isNotEmpty) estado,
    ];

    return parts.isNotEmpty ? parts.join(' - ') : fallback;
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
