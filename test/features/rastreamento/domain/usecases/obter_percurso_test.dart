import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/rastreamento/domain/entities/ponto_rastreamento.dart';
import 'package:sos_app/features/rastreamento/domain/repositories/rastreamento_repository.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/obter_percurso.dart';

class MockRastreamentoRepository extends Mock
    implements RastreamentoRepository {}

void main() {
  late ObterPercurso usecase;
  late MockRastreamentoRepository mockRepository;

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
    usecase = ObterPercurso(mockRepository);
  });

  group('ObterPercurso', () {
    test('deve retornar lista de pontos do repositório', () async {
      when(() => mockRepository.obterPontosPorAtendimento('at-1'))
          .thenAnswer((_) async => pontos);

      final result = await usecase('at-1');

      expect(result, hasLength(2));
      expect(result.first.id, 'p-1');
      expect(result.last.id, 'p-2');
    });

    test('deve retornar lista vazia quando não há pontos', () async {
      when(() => mockRepository.obterPontosPorAtendimento('at-99'))
          .thenAnswer((_) async => []);

      final result = await usecase('at-99');

      expect(result, isEmpty);
    });
  });
}
