import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';
import 'package:sos_app/features/atendimento/domain/repositories/atendimento_repository.dart';
import 'package:sos_app/features/atendimento/domain/usecases/atualizar_status_atendimento.dart';

class MockAtendimentoRepository extends Mock implements AtendimentoRepository {}

void main() {
  late AtualizarStatusAtendimento usecase;
  late MockAtendimentoRepository mockRepository;

  const local = LocalGeo(
    enderecoTexto: 'Local',
    latitude: -23.55,
    longitude: -46.63,
  );

  Atendimento buildAtendimento({
    AtendimentoStatus status = AtendimentoStatus.rascunho,
  }) {
    return Atendimento(
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
      status: status,
      criadoEm: DateTime(2024),
      atualizadoEm: DateTime(2024),
    );
  }

  setUp(() {
    mockRepository = MockAtendimentoRepository();
    usecase = AtualizarStatusAtendimento(mockRepository);

    registerFallbackValue(buildAtendimento());
  });

  group('AtualizarStatusAtendimento', () {
    test('rascunho → emDeslocamento deve preencher iniciadoEm', () async {
      when(() => mockRepository.atualizar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(
        atendimento: buildAtendimento(),
        novoStatus: AtendimentoStatus.emDeslocamento,
      );

      expect(result.status, AtendimentoStatus.emDeslocamento);
      expect(result.iniciadoEm, isNotNull);
    });

    test('emDeslocamento → emColeta deve preencher chegadaColetaEm', () async {
      when(() => mockRepository.atualizar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(
        atendimento: buildAtendimento(status: AtendimentoStatus.emDeslocamento),
        novoStatus: AtendimentoStatus.emColeta,
      );

      expect(result.status, AtendimentoStatus.emColeta);
      expect(result.chegadaColetaEm, isNotNull);
    });

    test('emColeta → emEntrega deve preencher chegadaEntregaEm', () async {
      when(() => mockRepository.atualizar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(
        atendimento: buildAtendimento(status: AtendimentoStatus.emColeta),
        novoStatus: AtendimentoStatus.emEntrega,
      );

      expect(result.status, AtendimentoStatus.emEntrega);
      expect(result.chegadaEntregaEm, isNotNull);
    });

    test('emEntrega → retornando deve preencher inicioRetornoEm', () async {
      when(() => mockRepository.atualizar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(
        atendimento: buildAtendimento(status: AtendimentoStatus.emEntrega),
        novoStatus: AtendimentoStatus.retornando,
      );

      expect(result.status, AtendimentoStatus.retornando);
      expect(result.inicioRetornoEm, isNotNull);
    });

    test('retornando → concluido deve preencher concluidoEm', () async {
      when(() => mockRepository.atualizar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(
        atendimento: buildAtendimento(status: AtendimentoStatus.retornando),
        novoStatus: AtendimentoStatus.concluido,
      );

      expect(result.status, AtendimentoStatus.concluido);
      expect(result.concluidoEm, isNotNull);
    });

    test('rascunho → cancelado deve ser permitido', () async {
      when(() => mockRepository.atualizar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(
        atendimento: buildAtendimento(),
        novoStatus: AtendimentoStatus.cancelado,
      );

      expect(result.status, AtendimentoStatus.cancelado);
    });

    test('rascunho → emColeta deve lançar ValidationFailure', () async {
      expect(
        () => usecase(
          atendimento: buildAtendimento(),
          novoStatus: AtendimentoStatus.emColeta,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('concluido → qualquer deve lançar ValidationFailure', () async {
      expect(
        () => usecase(
          atendimento: buildAtendimento(status: AtendimentoStatus.concluido),
          novoStatus: AtendimentoStatus.cancelado,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('emEntrega → concluido deve lançar ValidationFailure (RN-022B)',
        () async {
      // RN-022B: concluido só a partir de retornando
      expect(
        () => usecase(
          atendimento: buildAtendimento(status: AtendimentoStatus.emEntrega),
          novoStatus: AtendimentoStatus.concluido,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}
