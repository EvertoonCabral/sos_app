import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/dashboard/domain/entities/tempo_por_etapa.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_tempo_por_etapa.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late ObterTempoPorEtapa usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = ObterTempoPorEtapa(mockRepository);
  });

  final inicio = DateTime(2026, 3, 1);
  final fim = DateTime(2026, 3, 31, 23, 59, 59);

  const tempos = TempoPorEtapa(
    mediaMinutosAteColeta: 25.5,
    mediaMinutosColetaEntrega: 35.0,
    mediaMinutosEntregaRetorno: 5.0,
    mediaMinutosRetornoBase: 20.0,
    totalAnalisados: 15,
  );

  test('deve retornar tempo médio por etapa', () async {
    when(() => mockRepository.obterTempoPorEtapa(
          inicio: inicio,
          fim: fim,
        )).thenAnswer((_) async => tempos);

    final result = await usecase(inicio: inicio, fim: fim);

    expect(result, tempos);
    expect(result.totalAnalisados, 15);
    expect(result.mediaMinutosAteColeta, 25.5);
    verify(() => mockRepository.obterTempoPorEtapa(
          inicio: inicio,
          fim: fim,
        )).called(1);
  });

  test('deve retornar zeros quando sem atendimentos completos', () async {
    const vazio = TempoPorEtapa(
      mediaMinutosAteColeta: 0,
      mediaMinutosColetaEntrega: 0,
      mediaMinutosEntregaRetorno: 0,
      mediaMinutosRetornoBase: 0,
      totalAnalisados: 0,
    );

    when(() => mockRepository.obterTempoPorEtapa(
          inicio: inicio,
          fim: fim,
        )).thenAnswer((_) async => vazio);

    final result = await usecase(inicio: inicio, fim: fim);

    expect(result.totalAnalisados, 0);
    expect(result.mediaMinutosAteColeta, 0);
  });

  test('deve propagar exceção', () async {
    when(() => mockRepository.obterTempoPorEtapa(
          inicio: any(named: 'inicio'),
          fim: any(named: 'fim'),
        )).thenThrow(Exception('Erro'));

    expect(
      () => usecase(inicio: inicio, fim: fim),
      throwsA(isA<Exception>()),
    );
  });
}
