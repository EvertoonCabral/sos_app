import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/dashboard/domain/entities/resumo_cliente.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_km_por_cliente.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late ObterKmPorCliente usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = ObterKmPorCliente(mockRepository);
  });

  final inicio = DateTime(2026, 3, 1);
  final fim = DateTime(2026, 3, 31, 23, 59, 59);

  final ranking = [
    const ResumoCliente(
      clienteId: 'c1',
      clienteNome: 'João Silva',
      totalAtendimentos: 10,
      totalKm: 250.5,
      totalReceita: 1252.50,
    ),
    const ResumoCliente(
      clienteId: 'c2',
      clienteNome: 'Maria Santos',
      totalAtendimentos: 5,
      totalKm: 120.0,
      totalReceita: 600.00,
    ),
  ];

  test('deve retornar ranking de clientes por KM', () async {
    when(() => mockRepository.obterKmPorCliente(
          inicio: inicio,
          fim: fim,
        )).thenAnswer((_) async => ranking);

    final result = await usecase(inicio: inicio, fim: fim);

    expect(result, ranking);
    expect(result.first.totalKm, greaterThan(result.last.totalKm));
    verify(() => mockRepository.obterKmPorCliente(
          inicio: inicio,
          fim: fim,
        )).called(1);
  });

  test('deve retornar lista vazia quando sem dados', () async {
    when(() => mockRepository.obterKmPorCliente(
          inicio: inicio,
          fim: fim,
        )).thenAnswer((_) async => []);

    final result = await usecase(inicio: inicio, fim: fim);

    expect(result, isEmpty);
  });

  test('deve propagar exceção', () async {
    when(() => mockRepository.obterKmPorCliente(
          inicio: any(named: 'inicio'),
          fim: any(named: 'fim'),
        )).thenThrow(Exception('Erro'));

    expect(
      () => usecase(inicio: inicio, fim: fim),
      throwsA(isA<Exception>()),
    );
  });
}
