import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/dashboard/data/datasources/dashboard_remote_datasource_impl.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late DashboardRemoteDatasourceImpl datasource;
  late MockDio mockDio;
  final inicio = DateTime.utc(2026, 3, 1);
  final fim = DateTime.utc(2026, 3, 31, 23, 59, 59);

  setUp(() {
    mockDio = MockDio();
    datasource = DashboardRemoteDatasourceImpl(mockDio);
    registerFallbackValue(RequestOptions(path: ''));
  });

  test('obterResumoPeriodo deve mapear DTO remoto', () async {
    when(() => mockDio.get<Map<String, dynamic>>(
          '/dashboard/resumo',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/dashboard/resumo'),
        statusCode: 200,
        data: {
          'kmOperacional': 100.0,
          'kmCobrado': 80.0,
          'receitaTotal': 450.0,
          'totalAtendimentos': 10,
          'totalConcluidos': 7,
          'totalCancelados': 1,
          'totalEmAndamento': 2,
        },
      ),
    );

    final result = await datasource.obterResumoPeriodo(
      inicio: inicio,
      fim: fim,
    );

    expect(result.totalConcluidos, 7);
  });

  test('obterKmPorCliente deve mapear lista remota', () async {
    when(() => mockDio.get<List<dynamic>>(
          '/dashboard/clientes',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/dashboard/clientes'),
        statusCode: 200,
        data: [
          {
            'clienteId': 'c1',
            'clienteNome': 'João',
            'totalAtendimentos': 3,
            'totalKm': 44.0,
            'totalReceita': 210.0,
          },
        ],
      ),
    );

    final result = await datasource.obterKmPorCliente(
      inicio: inicio,
      fim: fim,
    );

    expect(result.first.clienteNome, 'João');
  });

  test('obterTempoPorEtapa deve mapear DTO remoto', () async {
    when(() => mockDio.get<Map<String, dynamic>>(
          '/dashboard/etapas',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/dashboard/etapas'),
        statusCode: 200,
        data: {
          'mediaMinutosAteColeta': 12.0,
          'mediaMinutosColetaEntrega': 20.0,
          'mediaMinutosEntregaRetorno': 8.0,
          'mediaMinutosRetornoBase': 16.0,
          'totalAnalisados': 5,
        },
      ),
    );

    final result = await datasource.obterTempoPorEtapa(
      inicio: inicio,
      fim: fim,
    );

    expect(result.totalAnalisados, 5);
  });

  test('obterAtendimentosPorDia deve mapear lista remota', () async {
    when(() => mockDio.get<List<dynamic>>(
          '/dashboard/diario',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/dashboard/diario'),
        statusCode: 200,
        data: [
          {'data': '2026-03-10T00:00:00.000Z', 'quantidade': 3},
        ],
      ),
    );

    final result = await datasource.obterAtendimentosPorDia(
      inicio: inicio,
      fim: fim,
    );

    expect(result.first.quantidade, 3);
  });
}
