import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/dashboard/domain/entities/resumo_periodo.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_resumo_periodo.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late ObterResumoPeriodo usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = ObterResumoPeriodo(mockRepository);
  });

  final inicio = DateTime(2026, 3, 1);
  final fim = DateTime(2026, 3, 31, 23, 59, 59);

  const resumo = ResumoPeriodo(
    kmOperacional: 450.5,
    kmCobrado: 450.5,
    receitaTotal: 2252.50,
    totalAtendimentos: 30,
    totalConcluidos: 25,
    totalCancelados: 2,
    totalEmAndamento: 3,
  );

  test('deve retornar resumo do período via repositório', () async {
    when(() => mockRepository.obterResumoPeriodo(
          inicio: inicio,
          fim: fim,
        )).thenAnswer((_) async => resumo);

    final result = await usecase(inicio: inicio, fim: fim);

    expect(result, resumo);
    verify(() => mockRepository.obterResumoPeriodo(
          inicio: inicio,
          fim: fim,
        )).called(1);
  });

  test('deve propagar exceção do repositório', () async {
    when(() => mockRepository.obterResumoPeriodo(
          inicio: any(named: 'inicio'),
          fim: any(named: 'fim'),
        )).thenThrow(Exception('Erro no banco'));

    expect(
      () => usecase(inicio: inicio, fim: fim),
      throwsA(isA<Exception>()),
    );
  });

  test('deve retornar valores zerados quando não há dados', () async {
    const vazio = ResumoPeriodo(
      kmOperacional: 0,
      kmCobrado: 0,
      receitaTotal: 0,
      totalAtendimentos: 0,
      totalConcluidos: 0,
      totalCancelados: 0,
      totalEmAndamento: 0,
    );

    when(() => mockRepository.obterResumoPeriodo(
          inicio: inicio,
          fim: fim,
        )).thenAnswer((_) async => vazio);

    final result = await usecase(inicio: inicio, fim: fim);

    expect(result.totalAtendimentos, 0);
    expect(result.kmOperacional, 0);
    expect(result.receitaTotal, 0);
  });
}
