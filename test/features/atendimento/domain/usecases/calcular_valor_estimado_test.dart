import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/core/utils/distance_calculator.dart';
import 'package:sos_app/features/atendimento/domain/usecases/calcular_valor_estimado.dart';

class MockDistanceCalculator extends Mock implements DistanceCalculator {}

void main() {
  late CalcularValorEstimado usecase;
  late MockDistanceCalculator mockCalculator;

  const saida =
      LocalGeo(enderecoTexto: 'Base', latitude: -23.55, longitude: -46.63);
  const coleta =
      LocalGeo(enderecoTexto: 'Coleta', latitude: -23.56, longitude: -46.64);
  const entrega =
      LocalGeo(enderecoTexto: 'Entrega', latitude: -23.57, longitude: -46.65);
  const retorno =
      LocalGeo(enderecoTexto: 'Base', latitude: -23.55, longitude: -46.63);

  setUp(() {
    mockCalculator = MockDistanceCalculator();
    usecase = CalcularValorEstimado(mockCalculator);

    registerFallbackValue(const PontoGeo(latitude: 0, longitude: 0));
  });

  group('CalcularValorEstimado', () {
    test('deve retornar distância × valorPorKm', () {
      when(() => mockCalculator.calcularEstimativa(
            saida: any(named: 'saida'),
            coleta: any(named: 'coleta'),
            entrega: any(named: 'entrega'),
            retorno: any(named: 'retorno'),
          )).thenReturn(25.0);

      final result = usecase(
        saida: saida,
        coleta: coleta,
        entrega: entrega,
        retorno: retorno,
        valorPorKm: 5.0,
      );

      expect(result, 125.0); // 25 × 5
    });

    test('deve usar os 4 pontos no cálculo (inclui retorno)', () {
      when(() => mockCalculator.calcularEstimativa(
            saida: any(named: 'saida'),
            coleta: any(named: 'coleta'),
            entrega: any(named: 'entrega'),
            retorno: any(named: 'retorno'),
          )).thenReturn(10.0);

      usecase(
        saida: saida,
        coleta: coleta,
        entrega: entrega,
        retorno: retorno,
        valorPorKm: 3.0,
      );

      verify(() => mockCalculator.calcularEstimativa(
            saida: any(named: 'saida'),
            coleta: any(named: 'coleta'),
            entrega: any(named: 'entrega'),
            retorno: any(named: 'retorno'),
          )).called(1);
    });

    test('deve lançar ValidationFailure quando valorPorKm é zero', () {
      expect(
        () => usecase(
          saida: saida,
          coleta: coleta,
          entrega: entrega,
          retorno: retorno,
          valorPorKm: 0,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('deve lançar ValidationFailure quando valorPorKm é negativo', () {
      expect(
        () => usecase(
          saida: saida,
          coleta: coleta,
          entrega: entrega,
          retorno: retorno,
          valorPorKm: -1,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}
