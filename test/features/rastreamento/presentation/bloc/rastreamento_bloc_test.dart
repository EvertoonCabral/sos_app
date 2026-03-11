import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/core/utils/distance_calculator.dart';
import 'package:sos_app/features/rastreamento/domain/entities/ponto_rastreamento.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/calcular_valor_real.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/obter_percurso.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/registrar_ponto.dart';
import 'package:sos_app/features/rastreamento/presentation/bloc/rastreamento_bloc.dart';
import 'package:sos_app/features/rastreamento/presentation/bloc/rastreamento_event.dart';
import 'package:sos_app/features/rastreamento/presentation/bloc/rastreamento_state.dart';

class MockRegistrarPonto extends Mock implements RegistrarPonto {}

class MockObterPercurso extends Mock implements ObterPercurso {}

class MockCalcularValorReal extends Mock implements CalcularValorReal {}

class MockDistanceCalculator extends Mock implements DistanceCalculator {}

void main() {
  late RastreamentoBloc bloc;
  late MockRegistrarPonto mockRegistrar;
  late MockObterPercurso mockObterPercurso;
  late MockCalcularValorReal mockCalcularValorReal;
  late MockDistanceCalculator mockDistanceCalculator;

  final ponto = PontoRastreamento(
    id: 'p-1',
    atendimentoId: 'at-1',
    latitude: -23.55,
    longitude: -46.63,
    accuracy: 10.0,
    timestamp: DateTime(2024, 1, 1, 10, 0),
  );

  setUp(() {
    mockRegistrar = MockRegistrarPonto();
    mockObterPercurso = MockObterPercurso();
    mockCalcularValorReal = MockCalcularValorReal();
    mockDistanceCalculator = MockDistanceCalculator();

    bloc = RastreamentoBloc(
      registrarPonto: mockRegistrar,
      obterPercurso: mockObterPercurso,
      calcularValorReal: mockCalcularValorReal,
      distanceCalculator: mockDistanceCalculator,
    );

    registerFallbackValue(ponto);
    registerFallbackValue(<PontoGeo>[]);
  });

  tearDown(() => bloc.close());

  group('RastreamentoBloc', () {
    test('estado inicial é RastreamentoInicial', () {
      expect(bloc.state, const RastreamentoInicial());
    });

    blocTest<RastreamentoBloc, RastreamentoState>(
      'emite [RastreamentoEmAndamento] ao iniciar rastreamento',
      build: () => bloc,
      act: (b) => b.add(const IniciarRastreamentoEvent(atendimentoId: 'at-1')),
      expect: () => [
        const RastreamentoEmAndamento(
            atendimentoId: 'at-1', pontosColetados: 0),
      ],
    );

    blocTest<RastreamentoBloc, RastreamentoState>(
      'emite [RastreamentoParado] ao parar rastreamento',
      build: () => bloc,
      seed: () => const RastreamentoEmAndamento(
          atendimentoId: 'at-1', pontosColetados: 3),
      act: (b) => b.add(const PararRastreamentoEvent()),
      expect: () => [const RastreamentoParado()],
    );

    blocTest<RastreamentoBloc, RastreamentoState>(
      'emite [RastreamentoEmAndamento] ao registrar ponto com sucesso',
      build: () {
        when(() => mockRegistrar(any())).thenAnswer((_) async {});
        return bloc;
      },
      act: (b) {
        // Precisamos iniciar primeiro para definir _atendimentoIdAtivo
        b.add(const IniciarRastreamentoEvent(atendimentoId: 'at-1'));
        b.add(RegistrarPontoEvent(ponto: ponto));
      },
      expect: () => [
        const RastreamentoEmAndamento(
            atendimentoId: 'at-1', pontosColetados: 0),
        const RastreamentoEmAndamento(
            atendimentoId: 'at-1', pontosColetados: 1),
      ],
    );

    blocTest<RastreamentoBloc, RastreamentoState>(
      'emite [RastreamentoErro] ao registrar ponto com falha',
      build: () {
        when(() => mockRegistrar(any()))
            .thenThrow(const CacheFailure(message: 'Falha ao salvar'));
        return bloc;
      },
      act: (b) {
        b.add(const IniciarRastreamentoEvent(atendimentoId: 'at-1'));
        b.add(RegistrarPontoEvent(ponto: ponto));
      },
      expect: () => [
        const RastreamentoEmAndamento(
            atendimentoId: 'at-1', pontosColetados: 0),
        const RastreamentoErro('Falha ao salvar'),
      ],
    );

    blocTest<RastreamentoBloc, RastreamentoState>(
      'emite [PercursoCarregado] ao obter percurso',
      build: () {
        when(() => mockObterPercurso('at-1')).thenAnswer((_) async => [ponto]);
        return bloc;
      },
      act: (b) => b.add(const ObterPercursoEvent(atendimentoId: 'at-1')),
      expect: () => [
        PercursoCarregado([ponto]),
      ],
    );

    blocTest<RastreamentoBloc, RastreamentoState>(
      'emite [ValorRealCalculado] ao calcular valor real',
      build: () {
        when(() => mockObterPercurso('at-1')).thenAnswer((_) async => [ponto]);
        when(() => mockDistanceCalculator.calcularTotal(any()))
            .thenReturn(30.0);
        when(() => mockCalcularValorReal(
              atendimentoId: 'at-1',
              valorPorKm: 5.0,
            )).thenAnswer((_) async => 150.0);
        return bloc;
      },
      act: (b) => b.add(const CalcularValorRealEvent(
        atendimentoId: 'at-1',
        valorPorKm: 5.0,
      )),
      expect: () => [
        const ValorRealCalculado(valorReal: 150.0, distanciaKm: 30.0),
      ],
    );
  });
}
