import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/geo/geo_service.dart';
import 'package:sos_app/core/geo/geocoding_cache_datasource.dart';
import 'package:sos_app/core/geo/offline_geo_service.dart';
import 'package:sos_app/core/network/network_info.dart';

class MockGeoService extends Mock implements GeoService {}

class MockGeocodingCacheDatasource extends Mock
    implements GeocodingCacheDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late OfflineGeoService service;
  late MockGeoService mockRemote;
  late MockGeocodingCacheDatasource mockCache;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockGeoService();
    mockCache = MockGeocodingCacheDatasource();
    mockNetwork = MockNetworkInfo();
    service = OfflineGeoService(
      remoteGeoService: mockRemote,
      cache: mockCache,
      networkInfo: mockNetwork,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const LocalGeo(
        enderecoTexto: 'fb',
        latitude: 0,
        longitude: 0,
      ),
    );
  });

  const tLocal = LocalGeo(
    enderecoTexto: 'Rua das Flores, 123',
    latitude: -23.5,
    longitude: -46.6,
  );

  // ─── autocompletar ──────────────────────────────────────────

  group('autocompletar', () {
    test('online: deve usar remote e salvar no cache', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.autocompletar('Rua'))
          .thenAnswer((_) async => [tLocal]);
      when(() => mockCache.salvar(any())).thenAnswer((_) async {});

      final result = await service.autocompletar('Rua');

      expect(result, [tLocal]);
      verify(() => mockRemote.autocompletar('Rua')).called(1);
      verify(() => mockCache.salvar(tLocal)).called(1);
    });

    test('offline: deve buscar no cache', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(() => mockCache.buscar('Rua')).thenAnswer((_) async => [tLocal]);

      final result = await service.autocompletar('Rua');

      expect(result, [tLocal]);
      verifyNever(() => mockRemote.autocompletar(any()));
      verify(() => mockCache.buscar('Rua')).called(1);
    });

    test('offline: deve retornar vazio quando nada no cache', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(() => mockCache.buscar('xyz')).thenAnswer((_) async => []);

      final result = await service.autocompletar('xyz');

      expect(result, isEmpty);
    });
  });

  // ─── geocodificar ───────────────────────────────────────────

  group('geocodificar', () {
    test('online: deve geocodificar e salvar no cache', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.geocodificar('Rua das Flores'))
          .thenAnswer((_) async => tLocal);
      when(() => mockCache.salvar(any())).thenAnswer((_) async {});

      final result = await service.geocodificar('Rua das Flores');

      expect(result, tLocal);
      verify(() => mockCache.salvar(tLocal)).called(1);
    });

    test('online: retorna null quando remote retorna null', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.geocodificar('inexistente'))
          .thenAnswer((_) async => null);

      final result = await service.geocodificar('inexistente');

      expect(result, isNull);
      verifyNever(() => mockCache.salvar(any()));
    });

    test('offline: deve buscar no cache por endereço exato', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(() => mockCache.obterPorEndereco('Rua das Flores'))
          .thenAnswer((_) async => tLocal);

      final result = await service.geocodificar('Rua das Flores');

      expect(result, tLocal);
      verifyNever(() => mockRemote.geocodificar(any()));
    });

    test('offline: retorna null quando não está no cache', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(() => mockCache.obterPorEndereco('unknown'))
          .thenAnswer((_) async => null);

      final result = await service.geocodificar('unknown');

      expect(result, isNull);
    });
  });

  // ─── reverseGeocodificar ────────────────────────────────────

  group('reverseGeocodificar', () {
    test('online: deve reverse geocodificar e salvar no cache', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.reverseGeocodificar(-23.5, -46.6))
          .thenAnswer((_) async => tLocal);
      when(() => mockCache.salvar(any())).thenAnswer((_) async {});

      final result = await service.reverseGeocodificar(-23.5, -46.6);

      expect(result, tLocal);
      verify(() => mockCache.salvar(tLocal)).called(1);
    });

    test('offline: retorna null', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      final result = await service.reverseGeocodificar(-23.5, -46.6);

      expect(result, isNull);
    });
  });

  // ─── obterLocalizacaoAtual ──────────────────────────────────

  group('obterLocalizacaoAtual', () {
    test('deve delegar para o remote (GPS funciona offline)', () async {
      when(() => mockRemote.obterLocalizacaoAtual())
          .thenAnswer((_) async => tLocal);

      final result = await service.obterLocalizacaoAtual();

      expect(result, tLocal);
      verify(() => mockRemote.obterLocalizacaoAtual()).called(1);
    });

    test('retorna null quando GPS não disponível', () async {
      when(() => mockRemote.obterLocalizacaoAtual())
          .thenAnswer((_) async => null);

      final result = await service.obterLocalizacaoAtual();

      expect(result, isNull);
    });
  });
}
