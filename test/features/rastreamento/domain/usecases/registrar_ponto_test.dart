import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/rastreamento/domain/entities/ponto_rastreamento.dart';
import 'package:sos_app/features/rastreamento/domain/repositories/rastreamento_repository.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/registrar_ponto.dart';

class MockRastreamentoRepository extends Mock
    implements RastreamentoRepository {}

void main() {
  late RegistrarPonto usecase;
  late MockRastreamentoRepository mockRepository;

  final ponto = PontoRastreamento(
    id: 'p-1',
    atendimentoId: 'at-1',
    latitude: -23.55,
    longitude: -46.63,
    accuracy: 10.0,
    timestamp: DateTime(2024, 1, 1, 10, 0),
  );

  setUp(() {
    mockRepository = MockRastreamentoRepository();
    usecase = RegistrarPonto(mockRepository);

    registerFallbackValue(ponto);
  });

  group('RegistrarPonto', () {
    test('deve delegar para o repositório', () async {
      when(() => mockRepository.salvarPonto(any())).thenAnswer((_) async {});

      await usecase(ponto);

      verify(() => mockRepository.salvarPonto(ponto)).called(1);
    });
  });
}
