import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';
import 'package:sos_app/features/base/domain/usecases/criar_base.dart';
import 'package:sos_app/features/base/domain/usecases/definir_base_principal.dart';
import 'package:sos_app/features/base/domain/usecases/listar_bases.dart';
import 'package:sos_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:sos_app/features/base/presentation/bloc/base_event.dart';
import 'package:sos_app/features/base/presentation/bloc/base_state.dart';

class MockCriarBase extends Mock implements CriarBase {}

class MockListarBases extends Mock implements ListarBases {}

class MockDefinirBasePrincipal extends Mock implements DefinirBasePrincipal {}

void main() {
  late BaseBloc bloc;
  late MockCriarBase mockCriar;
  late MockListarBases mockListar;
  late MockDefinirBasePrincipal mockDefinirPrincipal;

  setUp(() {
    mockCriar = MockCriarBase();
    mockListar = MockListarBases();
    mockDefinirPrincipal = MockDefinirBasePrincipal();
    bloc = BaseBloc(
      criarBase: mockCriar,
      listarBases: mockListar,
      definirBasePrincipal: mockDefinirPrincipal,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      Base(
        id: 'fb',
        nome: 'fb',
        local: const LocalGeo(enderecoTexto: 'fb', latitude: 0, longitude: 0),
        criadoEm: DateTime(2026),
      ),
    );
  });

  tearDown(() => bloc.close());

  final tBase = Base(
    id: 'base-001',
    nome: 'Garagem SP',
    local: const LocalGeo(
      enderecoTexto: 'Rua X, 100',
      latitude: -23.5,
      longitude: -46.6,
    ),
    isPrincipal: true,
    criadoEm: DateTime(2026, 3, 1),
  );

  test('estado inicial deve ser BaseInicial', () {
    expect(bloc.state, const BaseInicial());
  });

  // ─── ListarBasesEvent ───────────────────────────────────────

  group('ListarBasesEvent', () {
    blocTest<BaseBloc, BaseState>(
      'deve emitir [Carregando, ListaCarregada] quando sucesso',
      build: () {
        when(() => mockListar()).thenAnswer((_) async => [tBase]);
        return bloc;
      },
      act: (b) => b.add(const ListarBasesEvent()),
      expect: () => [
        const BaseCarregando(),
        BaseListaCarregada([tBase]),
      ],
    );

    blocTest<BaseBloc, BaseState>(
      'deve emitir [Carregando, Erro] quando falha',
      build: () {
        when(() => mockListar()).thenThrow(
          const CacheFailure(message: 'Erro de leitura'),
        );
        return bloc;
      },
      act: (b) => b.add(const ListarBasesEvent()),
      expect: () => [
        const BaseCarregando(),
        const BaseErro('Erro de leitura'),
      ],
    );
  });

  // ─── CriarBaseEvent ─────────────────────────────────────────

  group('CriarBaseEvent', () {
    blocTest<BaseBloc, BaseState>(
      'deve emitir [Carregando, SalvaComSucesso] quando criação OK',
      build: () {
        when(() => mockCriar(any())).thenAnswer((_) async => tBase);
        return bloc;
      },
      act: (b) => b.add(CriarBaseEvent(tBase)),
      expect: () => [
        const BaseCarregando(),
        BaseSalvaComSucesso(tBase),
      ],
    );

    blocTest<BaseBloc, BaseState>(
      'deve emitir [Carregando, Erro] quando validação falha',
      build: () {
        when(() => mockCriar(any())).thenThrow(
          const ValidationFailure(message: 'Nome da base é obrigatório'),
        );
        return bloc;
      },
      act: (b) => b.add(CriarBaseEvent(tBase)),
      expect: () => [
        const BaseCarregando(),
        const BaseErro('Nome da base é obrigatório'),
      ],
    );
  });

  // ─── DefinirBasePrincipalEvent ──────────────────────────────

  group('DefinirBasePrincipalEvent', () {
    blocTest<BaseBloc, BaseState>(
      'deve emitir [Carregando, ListaCarregada] após definir principal',
      build: () {
        when(() => mockDefinirPrincipal('base-001'))
            .thenAnswer((_) async => tBase);
        when(() => mockListar()).thenAnswer((_) async => [tBase]);
        return bloc;
      },
      act: (b) => b.add(const DefinirBasePrincipalEvent('base-001')),
      expect: () => [
        const BaseCarregando(),
        BaseListaCarregada([tBase]),
      ],
    );

    blocTest<BaseBloc, BaseState>(
      'deve emitir [Carregando, Erro] quando falha',
      build: () {
        when(() => mockDefinirPrincipal('xxx')).thenThrow(
          const ValidationFailure(message: 'ID da base é obrigatório'),
        );
        return bloc;
      },
      act: (b) => b.add(const DefinirBasePrincipalEvent('xxx')),
      expect: () => [
        const BaseCarregando(),
        const BaseErro('ID da base é obrigatório'),
      ],
    );
  });
}
