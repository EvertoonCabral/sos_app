import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/core/utils/distance_calculator.dart';
import 'package:sos_app/features/rastreamento/domain/entities/ponto_rastreamento.dart';
import 'package:sos_app/features/rastreamento/domain/repositories/rastreamento_repository.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/calcular_valor_real.dart';

class MockRastreamentoRepository extends Mock
    implements RastreamentoRepository {}

class MockDistanceCalculator extends Mock implements DistanceCalculator {}

void main() {
  late CalcularValorReal usecase;
  late MockRastreamentoRepository mockRepository;
  late MockDistanceCalculator mockCalculator;

  final pontos = [
    PontoRastreamento(
      id: 'p-1',
      atendimentoId: 'at-1',
      latitude: -23.55,
      longitude: -46.63,
      accuracy: 10.0,
      timestamp: DateTime(2024, 1, 1, 10, 0),
    ),
    PontoRastreamento(
      id: 'p-2',
      atendimentoId: 'at-1',
      latitude: -23.56,
      longitude: -46.64,
      accuracy: 8.0,
      timestamp: DateTime(2024, 1, 1, 10, 1),
    ),
  ];

  setUp(() {
    mockRepository = MockRastreamentoRepository();
    mockCalculator = MockDistanceCalculator();
    usecase = CalcularValorReal(mockRepository, mockCalculator);

    registerFallbackValue(const PontoGeo(latitude: 0, longitude: 0));
    registerFallbackValue(<PontoGeo>[]);
  });

  group('CalcularValorReal', () {
    test('deve calcular distância real × valorPorKm', () async {
      when(() => mockRepository.obterPontosPorAtendimento('at-1'))
          .thenAnswer((_) async => pontos);
      when(() => mockCalculator.calcularTotal(any())).thenReturn(30.0);

      final result = await usecase(
        atendimentoId: 'at-1',
        valorPorKm: 5.0,
      );

      expect(result, 150.0); // 30 × 5
    });

    test('deve lançar ValidationFailure quando valorPorKm é zero', () async {
      expect(
        () => usecase(atendimentoId: 'at-1', valorPorKm: 0),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('deve lançar ValidationFailure quando valorPorKm é negativo',
        () async {
      expect(
        () => usecase(atendimentoId: 'at-1', valorPorKm: -1),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('deve lançar ValidationFailure quando não há pontos', () async {
      when(() => mockRepository.obterPontosPorAtendimento('at-99'))
          .thenAnswer((_) async => []);

      expect(
        () => usecase(atendimentoId: 'at-99', valorPorKm: 5.0),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}
