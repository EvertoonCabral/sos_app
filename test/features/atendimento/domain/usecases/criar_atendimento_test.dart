import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/core/utils/distance_calculator.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';
import 'package:sos_app/features/atendimento/domain/repositories/atendimento_repository.dart';
import 'package:sos_app/features/atendimento/domain/usecases/criar_atendimento.dart';

class MockAtendimentoRepository extends Mock implements AtendimentoRepository {}

class MockDistanceCalculator extends Mock implements DistanceCalculator {}

void main() {
  late CriarAtendimento usecase;
  late MockAtendimentoRepository mockRepository;
  late MockDistanceCalculator mockCalculator;

  const saida = LocalGeo(
    enderecoTexto: 'Base Central',
    latitude: -23.55,
    longitude: -46.63,
  );
  const coleta = LocalGeo(
    enderecoTexto: 'Rua A, 100',
    latitude: -23.56,
    longitude: -46.64,
  );
  const entrega = LocalGeo(
    enderecoTexto: 'Rua B, 200',
    latitude: -23.57,
    longitude: -46.65,
  );
  const retorno = LocalGeo(
    enderecoTexto: 'Base Central',
    latitude: -23.55,
    longitude: -46.63,
  );

  setUp(() {
    mockRepository = MockAtendimentoRepository();
    mockCalculator = MockDistanceCalculator();
    usecase = CriarAtendimento(mockRepository, mockCalculator);

    registerFallbackValue(Atendimento(
      id: 'any',
      clienteId: 'c1',
      usuarioId: 'u1',
      pontoDeSaida: saida,
      localDeColeta: coleta,
      localDeEntrega: entrega,
      localDeRetorno: retorno,
      distanciaEstimadaKm: 0,
      valorPorKm: 5.0,
      tipoValor: TipoValor.porKm,
      criadoEm: DateTime(2024),
      atualizadoEm: DateTime(2024),
    ));
    registerFallbackValue(const PontoGeo(latitude: 0, longitude: 0));
  });

  CriarAtendimentoParams buildParams({
    String clienteId = 'c1',
    String usuarioId = 'u1',
    TipoValor tipoValor = TipoValor.porKm,
    double? valorFixo,
  }) {
    return CriarAtendimentoParams(
      id: 'at-1',
      clienteId: clienteId,
      usuarioId: usuarioId,
      pontoDeSaida: saida,
      localDeColeta: coleta,
      localDeEntrega: entrega,
      localDeRetorno: retorno,
      valorPorKm: 5.0,
      tipoValor: tipoValor,
      valorFixo: valorFixo,
    );
  }

  group('CriarAtendimento', () {
    test('deve calcular distância estimada e criar atendimento', () async {
      when(() => mockCalculator.calcularEstimativa(
            saida: any(named: 'saida'),
            coleta: any(named: 'coleta'),
            entrega: any(named: 'entrega'),
            retorno: any(named: 'retorno'),
          )).thenReturn(25.5);

      when(() => mockRepository.criar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(buildParams());

      expect(result.distanciaEstimadaKm, 25.5);
      expect(result.status, AtendimentoStatus.rascunho);
      expect(result.clienteId, 'c1');
      verify(() => mockCalculator.calcularEstimativa(
            saida: any(named: 'saida'),
            coleta: any(named: 'coleta'),
            entrega: any(named: 'entrega'),
            retorno: any(named: 'retorno'),
          )).called(1);
      verify(() => mockRepository.criar(any())).called(1);
    });

    test('deve definir valorCobrado quando tipoValor é fixo', () async {
      when(() => mockCalculator.calcularEstimativa(
            saida: any(named: 'saida'),
            coleta: any(named: 'coleta'),
            entrega: any(named: 'entrega'),
            retorno: any(named: 'retorno'),
          )).thenReturn(10.0);

      when(() => mockRepository.criar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(buildParams(
        tipoValor: TipoValor.fixo,
        valorFixo: 150.0,
      ));

      expect(result.tipoValor, TipoValor.fixo);
      expect(result.valorCobrado, 150.0);
    });

    test('deve manter valorCobrado null quando tipoValor é porKm', () async {
      when(() => mockCalculator.calcularEstimativa(
            saida: any(named: 'saida'),
            coleta: any(named: 'coleta'),
            entrega: any(named: 'entrega'),
            retorno: any(named: 'retorno'),
          )).thenReturn(10.0);

      when(() => mockRepository.criar(any())).thenAnswer(
        (inv) async => inv.positionalArguments[0] as Atendimento,
      );

      final result = await usecase(buildParams(tipoValor: TipoValor.porKm));

      expect(result.tipoValor, TipoValor.porKm);
      expect(result.valorCobrado, isNull);
    });

    test('deve lançar ValidationFailure quando clienteId está vazio', () async {
      expect(
        () => usecase(buildParams(clienteId: '')),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('deve lançar ValidationFailure quando usuarioId está vazio', () async {
      expect(
        () => usecase(buildParams(usuarioId: '')),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}
