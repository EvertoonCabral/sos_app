import '../entities/local_geo.dart';
import '../network/network_info.dart';
import 'geo_service.dart';
import 'geocoding_cache_datasource.dart';

/// Serviço de geocoding com fallback offline.
///
/// Estratégia:
/// - Online → usa GeoService real → salva resultado no cache.
/// - Offline → busca no cache local de endereços já usados.
class OfflineGeoService implements GeoService {
  OfflineGeoService({
    required GeoService remoteGeoService,
    required GeocodingCacheDatasource cache,
    required NetworkInfo networkInfo,
  })  : _remote = remoteGeoService,
        _cache = cache,
        _networkInfo = networkInfo;

  final GeoService _remote;
  final GeocodingCacheDatasource _cache;
  final NetworkInfo _networkInfo;

  @override
  Future<List<LocalGeo>> autocompletar(String query) async {
    if (await _networkInfo.isConnected) {
      final results = await _remote.autocompletar(query);
      // Salva cada resultado no cache
      for (final local in results) {
        await _cache.salvar(local);
      }
      return results;
    }
    // Offline: busca no cache
    return _cache.buscar(query);
  }

  @override
  Future<LocalGeo?> geocodificar(String endereco) async {
    if (await _networkInfo.isConnected) {
      final result = await _remote.geocodificar(endereco);
      if (result != null) {
        await _cache.salvar(result);
      }
      return result;
    }
    // Offline: busca exata no cache
    return _cache.obterPorEndereco(endereco);
  }

  @override
  Future<LocalGeo?> reverseGeocodificar(
      double latitude, double longitude) async {
    if (await _networkInfo.isConnected) {
      final result = await _remote.reverseGeocodificar(latitude, longitude);
      if (result != null) {
        await _cache.salvar(result);
      }
      return result;
    }
    return null;
  }

  @override
  Future<LocalGeo?> obterLocalizacaoAtual() async {
    // GPS funciona offline, mas reverse geocoding pode não resolver
    return _remote.obterLocalizacaoAtual();
  }
}
