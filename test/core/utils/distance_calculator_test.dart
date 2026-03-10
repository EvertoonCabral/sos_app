import 'package:flutter_test/flutter_test.dart';
import 'package:sos_app/core/utils/distance_calculator.dart';

void main() {
  late DistanceCalculator calculator;

  setUp(() {
    calculator = DistanceCalculator();
  });

  group('calcularTotal', () {
    test('lista vazia retorna 0.0', () {
      final resultado = calculator.calcularTotal([]);
      expect(resultado, 0.0);
    });

    test('lista com 1 ponto retorna 0.0', () {
      final resultado = calculator.calcularTotal([
        const PontoGeo(latitude: -23.550520, longitude: -46.633308),
      ]);
      expect(resultado, 0.0);
    });

    test('lista com 2 pontos retorna distância correta em km', () {
      // São Paulo (Praça da Sé) → Santos (~60 km em linha reta)
      final resultado = calculator.calcularTotal([
        const PontoGeo(latitude: -23.550520, longitude: -46.633308),
        const PontoGeo(latitude: -23.960833, longitude: -46.333889),
      ]);

      // Distância Haversine esperada: ~53-55 km
      expect(resultado, greaterThan(50.0));
      expect(resultado, lessThan(60.0));
    });

    test('lista com N pontos retorna soma correta dos trechos', () {
      // 3 pontos: A→B + B→C
      final pontos = [
        const PontoGeo(latitude: -23.550520, longitude: -46.633308), // Sé SP
        const PontoGeo(latitude: -23.561414, longitude: -46.655881), // Paulista
        const PontoGeo(
            latitude: -23.587416, longitude: -46.657028), // Ibirapuera
      ];

      final total = calculator.calcularTotal(pontos);

      // Calcular trecho a trecho para verificar
      final trechoAB = calculator.calcularTotal([pontos[0], pontos[1]]);
      final trechoBC = calculator.calcularTotal([pontos[1], pontos[2]]);

      expect(total, closeTo(trechoAB + trechoBC, 0.001));
    });

    test('pontos iguais retorna 0.0', () {
      final resultado = calculator.calcularTotal([
        const PontoGeo(latitude: -23.550520, longitude: -46.633308),
        const PontoGeo(latitude: -23.550520, longitude: -46.633308),
      ]);
      expect(resultado, 0.0);
    });
  });

  group('calcularEstimativa', () {
    test('4 pontos distintos retorna soma dos 3 trechos em km', () {
      const saida = PontoGeo(latitude: -23.550520, longitude: -46.633308);
      const coleta = PontoGeo(latitude: -23.561414, longitude: -46.655881);
      const entrega = PontoGeo(latitude: -23.587416, longitude: -46.657028);
      const retorno = PontoGeo(latitude: -23.596000, longitude: -46.690000);

      final resultado = calculator.calcularEstimativa(
        saida: saida,
        coleta: coleta,
        entrega: entrega,
        retorno: retorno,
      );

      // Deve ser saida→coleta + coleta→entrega + entrega→retorno
      final saidaColeta = calculator.calcularTotal([saida, coleta]);
      final coletaEntrega = calculator.calcularTotal([coleta, entrega]);
      final entregaRetorno = calculator.calcularTotal([entrega, retorno]);

      expect(resultado,
          closeTo(saidaColeta + coletaEntrega + entregaRetorno, 0.001));
      expect(resultado, greaterThan(0.0));
    });

    test('saída igual ao retorno (ida e volta simétrica) retorna valor correto',
        () {
      const saida = PontoGeo(latitude: -23.550520, longitude: -46.633308);
      const coleta = PontoGeo(latitude: -23.561414, longitude: -46.655881);
      const entrega = PontoGeo(latitude: -23.587416, longitude: -46.657028);

      final resultado = calculator.calcularEstimativa(
        saida: saida,
        coleta: coleta,
        entrega: entrega,
        retorno: saida, // retorna para o mesmo local de saída
      );

      final saidaColeta = calculator.calcularTotal([saida, coleta]);
      final coletaEntrega = calculator.calcularTotal([coleta, entrega]);
      final entregaSaida = calculator.calcularTotal([entrega, saida]);

      expect(resultado,
          closeTo(saidaColeta + coletaEntrega + entregaSaida, 0.001));
    });

    test('todos os pontos iguais retorna 0.0', () {
      const ponto = PontoGeo(latitude: -23.550520, longitude: -46.633308);

      final resultado = calculator.calcularEstimativa(
        saida: ponto,
        coleta: ponto,
        entrega: ponto,
        retorno: ponto,
      );

      expect(resultado, 0.0);
    });
  });
}
