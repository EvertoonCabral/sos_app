import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';
import 'package:sos_app/features/atendimento/domain/usecases/atualizar_status_atendimento.dart';
import 'package:sos_app/features/atendimento/domain/usecases/criar_atendimento.dart';
import 'package:sos_app/features/atendimento/domain/usecases/listar_atendimentos.dart';
import 'package:sos_app/features/atendimento/presentation/bloc/atendimento_bloc.dart';
import 'package:sos_app/features/atendimento/presentation/bloc/atendimento_event.dart';
import 'package:sos_app/features/atendimento/presentation/bloc/atendimento_state.dart';

class MockCriarAtendimento extends Mock implements CriarAtendimento {}

class MockListarAtendimentos extends Mock implements ListarAtendimentos {}

class MockAtualizarStatusAtendimento extends Mock
    implements AtualizarStatusAtendimento {}

void main() {
  late AtendimentoBloc bloc;
  late MockCriarAtendimento mockCriar;
  late MockListarAtendimentos mockListar;
  late MockAtualizarStatusAtendimento mockAtualizarStatus;

  const local = LocalGeo(
    enderecoTexto: 'Local',
    latitude: -23.55,
    longitude: -46.63,
  );

  final atendimentoFake = Atendimento(
    id: 'at-1',
    clienteId: 'c1',
    usuarioId: 'u1',
    pontoDeSaida: local,
    localDeColeta: local,
    localDeEntrega: local,
    localDeRetorno: local,
    distanciaEstimadaKm: 25.0,
    valorPorKm: 5.0,
    tipoValor: TipoValor.porKm,
    criadoEm: DateTime(2024),
    atualizadoEm: DateTime(2024),
  );

  setUp(() {
    mockCriar = MockCriarAtendimento();
    mockListar = MockListarAtendimentos();
    mockAtualizarStatus = MockAtualizarStatusAtendimento();

    bloc = AtendimentoBloc(
      criarAtendimento: mockCriar,
      listarAtendimentos: mockListar,
      atualizarStatusAtendimento: mockAtualizarStatus,
    );

    registerFallbackValue(const CriarAtendimentoParams(
      id: 'any',
      clienteId: 'c1',
      usuarioId: 'u1',
      pontoDeSaida: local,
      localDeColeta: local,
      localDeEntrega: local,
      localDeRetorno: local,
      valorPorKm: 5.0,
      tipoValor: TipoValor.porKm,
    ));
    registerFallbackValue(atendimentoFake);
    registerFallbackValue(AtendimentoStatus.rascunho);
  });

  tearDown(() => bloc.close());

  group('AtendimentoBloc', () {
    blocTest<AtendimentoBloc, AtendimentoState>(
      'emite [Carregando, ListaCarregada] ao listar',
      build: () {
        when(() => mockListar(status: null))
            .thenAnswer((_) async => [atendimentoFake]);
        return bloc;
      },
      act: (b) => b.add(const ListarAtendimentosEvent()),
      expect: () => [
        const AtendimentoCarregando(),
        AtendimentoListaCarregada([atendimentoFake]),
      ],
    );

    blocTest<AtendimentoBloc, AtendimentoState>(
      'emite [Carregando, ListaCarregada] ao listar com filtro',
      build: () {
        when(() => mockListar(status: AtendimentoStatus.rascunho))
            .thenAnswer((_) async => [atendimentoFake]);
        return bloc;
      },
      act: (b) => b.add(
        const ListarAtendimentosEvent(status: AtendimentoStatus.rascunho),
      ),
      expect: () => [
        const AtendimentoCarregando(),
        AtendimentoListaCarregada([atendimentoFake]),
      ],
    );

    blocTest<AtendimentoBloc, AtendimentoState>(
      'emite [Carregando, SalvoComSucesso] ao criar',
      build: () {
        when(() => mockCriar(any())).thenAnswer((_) async => atendimentoFake);
        return bloc;
      },
      act: (b) => b.add(const CriarAtendimentoEvent(
        id: 'at-1',
        clienteId: 'c1',
        usuarioId: 'u1',
        pontoDeSaida: local,
        localDeColeta: local,
        localDeEntrega: local,
        localDeRetorno: local,
        valorPorKm: 5.0,
        tipoValor: TipoValor.porKm,
      )),
      expect: () => [
        const AtendimentoCarregando(),
        AtendimentoSalvoComSucesso(atendimentoFake),
      ],
    );

    blocTest<AtendimentoBloc, AtendimentoState>(
      'emite [Carregando, Erro] quando criar falha',
      build: () {
        when(() => mockCriar(any()))
            .thenThrow(const ValidationFailure(message: 'Erro'));
        return bloc;
      },
      act: (b) => b.add(const CriarAtendimentoEvent(
        id: 'at-1',
        clienteId: '',
        usuarioId: 'u1',
        pontoDeSaida: local,
        localDeColeta: local,
        localDeEntrega: local,
        localDeRetorno: local,
        valorPorKm: 5.0,
        tipoValor: TipoValor.porKm,
      )),
      expect: () => [
        const AtendimentoCarregando(),
        const AtendimentoErro('Erro'),
      ],
    );

    blocTest<AtendimentoBloc, AtendimentoState>(
      'emite [Carregando, StatusAtualizado] ao atualizar status',
      build: () {
        final atualizado = atendimentoFake.copyWith(
          status: AtendimentoStatus.emDeslocamento,
        );
        when(() => mockAtualizarStatus(
              atendimento: any(named: 'atendimento'),
              novoStatus: any(named: 'novoStatus'),
            )).thenAnswer((_) async => atualizado);
        return bloc;
      },
      act: (b) => b.add(AtualizarStatusEvent(
        atendimento: atendimentoFake,
        novoStatus: AtendimentoStatus.emDeslocamento,
      )),
      expect: () => [
        const AtendimentoCarregando(),
        AtendimentoStatusAtualizado(atendimentoFake.copyWith(
          status: AtendimentoStatus.emDeslocamento,
        )),
      ],
    );

    blocTest<AtendimentoBloc, AtendimentoState>(
      'emite [Carregando, Erro] quando atualizar status falha',
      build: () {
        when(() => mockAtualizarStatus(
              atendimento: any(named: 'atendimento'),
              novoStatus: any(named: 'novoStatus'),
            )).thenThrow(const ValidationFailure(
          message: 'Transição inválida',
        ));
        return bloc;
      },
      act: (b) => b.add(AtualizarStatusEvent(
        atendimento: atendimentoFake,
        novoStatus: AtendimentoStatus.concluido,
      )),
      expect: () => [
        const AtendimentoCarregando(),
        const AtendimentoErro('Transição inválida'),
      ],
    );

    blocTest<AtendimentoBloc, AtendimentoState>(
      'emite [Carregando, Erro] quando listar falha',
      build: () {
        when(() => mockListar(status: null))
            .thenThrow(const CacheFailure(message: 'Erro DB'));
        return bloc;
      },
      act: (b) => b.add(const ListarAtendimentosEvent()),
      expect: () => [
        const AtendimentoCarregando(),
        const AtendimentoErro('Erro DB'),
      ],
    );
  });
}
