import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';
import 'package:sos_app/features/atendimento/domain/repositories/atendimento_repository.dart';
import 'package:sos_app/features/atendimento/domain/usecases/listar_atendimentos.dart';

class MockAtendimentoRepository extends Mock implements AtendimentoRepository {}

void main() {
  late ListarAtendimentos usecase;
  late MockAtendimentoRepository mockRepository;

  const local = LocalGeo(
    enderecoTexto: 'Local',
    latitude: -23.55,
    longitude: -46.63,
  );

  final atendimentos = [
    Atendimento(
      id: 'at-1',
      clienteId: 'c1',
      usuarioId: 'u1',
      pontoDeSaida: local,
      localDeColeta: local,
      localDeEntrega: local,
      localDeRetorno: local,
      distanciaEstimadaKm: 10.0,
      valorPorKm: 5.0,
      tipoValor: TipoValor.porKm,
      criadoEm: DateTime(2024),
      atualizadoEm: DateTime(2024),
    ),
  ];

  setUp(() {
    mockRepository = MockAtendimentoRepository();
    usecase = ListarAtendimentos(mockRepository);
  });

  group('ListarAtendimentos', () {
    test('deve retornar todos os atendimentos quando status é null', () async {
      when(() => mockRepository.listar(status: null))
          .thenAnswer((_) async => atendimentos);

      final result = await usecase();

      expect(result, atendimentos);
      verify(() => mockRepository.listar(status: null)).called(1);
    });

    test('deve filtrar por status quando fornecido', () async {
      when(() => mockRepository.listar(status: AtendimentoStatus.rascunho))
          .thenAnswer((_) async => atendimentos);

      final result = await usecase(status: AtendimentoStatus.rascunho);

      expect(result, atendimentos);
      verify(() => mockRepository.listar(status: AtendimentoStatus.rascunho))
          .called(1);
    });

    test('deve retornar lista vazia quando não há atendimentos', () async {
      when(() => mockRepository.listar(status: null))
          .thenAnswer((_) async => []);

      final result = await usecase();

      expect(result, isEmpty);
    });
  });
}
