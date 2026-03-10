import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/cliente/domain/entities/cliente.dart';
import 'package:sos_app/features/cliente/domain/usecases/buscar_clientes.dart';
import 'package:sos_app/features/cliente/domain/usecases/criar_cliente.dart';
import 'package:sos_app/features/cliente/domain/usecases/atualizar_cliente.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_bloc.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_event.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_state.dart';
import 'package:sos_app/core/error/failures.dart';

class MockCriarCliente extends Mock implements CriarCliente {}

class MockBuscarClientes extends Mock implements BuscarClientes {}

class MockAtualizarCliente extends Mock implements AtualizarCliente {}

void main() {
  late ClienteBloc bloc;
  late MockCriarCliente mockCriar;
  late MockBuscarClientes mockBuscar;
  late MockAtualizarCliente mockAtualizar;

  setUp(() {
    mockCriar = MockCriarCliente();
    mockBuscar = MockBuscarClientes();
    mockAtualizar = MockAtualizarCliente();
    bloc = ClienteBloc(
      criarCliente: mockCriar,
      buscarClientes: mockBuscar,
      atualizarCliente: mockAtualizar,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const CriarClienteParams(id: 'fb-id', nome: 'fb', telefone: '0'),
    );
    registerFallbackValue(
      Cliente(
        id: 'fb',
        nome: 'fb',
        telefone: '0',
        criadoEm: DateTime(2026),
        atualizadoEm: DateTime(2026),
      ),
    );
  });

  tearDown(() => bloc.close());

  final tCliente = Cliente(
    id: 'cli-001',
    nome: 'Maria Silva',
    telefone: '+5511988880000',
    criadoEm: DateTime(2026, 3, 1),
    atualizadoEm: DateTime(2026, 3, 1),
  );

  test('estado inicial deve ser ClienteInicial', () {
    expect(bloc.state, const ClienteInicial());
  });

  // ─── BuscarClientesEvent ────────────────────────────────────

  group('BuscarClientesEvent', () {
    blocTest<ClienteBloc, ClienteState>(
      'deve emitir [Carregando, ListaCarregada] quando busca retorna resultados',
      build: () {
        when(() => mockBuscar('Maria')).thenAnswer((_) async => [tCliente]);
        return bloc;
      },
      act: (b) => b.add(const BuscarClientesEvent('Maria')),
      expect: () => [
        const ClienteCarregando(),
        ClienteListaCarregada([tCliente]),
      ],
    );

    blocTest<ClienteBloc, ClienteState>(
      'deve emitir [Carregando, ListaCarregada([])] quando sem resultados',
      build: () {
        when(() => mockBuscar('xyz')).thenAnswer((_) async => []);
        return bloc;
      },
      act: (b) => b.add(const BuscarClientesEvent('xyz')),
      expect: () => [
        const ClienteCarregando(),
        const ClienteListaCarregada([]),
      ],
    );

    blocTest<ClienteBloc, ClienteState>(
      'deve emitir [Carregando, Erro] quando busca lança exceção',
      build: () {
        when(() => mockBuscar(any())).thenThrow(
          const CacheFailure(message: 'Erro ao acessar banco'),
        );
        return bloc;
      },
      act: (b) => b.add(const BuscarClientesEvent('q')),
      expect: () => [
        const ClienteCarregando(),
        const ClienteErro('Erro ao acessar banco'),
      ],
    );
  });

  // ─── CriarClienteEvent ─────────────────────────────────────

  group('CriarClienteEvent', () {
    blocTest<ClienteBloc, ClienteState>(
      'deve emitir [Carregando, SalvoComSucesso] quando criação OK',
      build: () {
        when(() => mockCriar(any())).thenAnswer((_) async => tCliente);
        return bloc;
      },
      act: (b) => b.add(const CriarClienteEvent(
        nome: 'Maria Silva',
        telefone: '+5511988880000',
      )),
      expect: () => [
        const ClienteCarregando(),
        ClienteSalvoComSucesso(tCliente),
      ],
    );

    blocTest<ClienteBloc, ClienteState>(
      'deve emitir [Carregando, Erro] quando validação falha',
      build: () {
        when(() => mockCriar(any())).thenThrow(
          const ValidationFailure(message: 'Nome é obrigatório'),
        );
        return bloc;
      },
      act: (b) => b.add(const CriarClienteEvent(
        nome: '',
        telefone: '+5511988880000',
      )),
      expect: () => [
        const ClienteCarregando(),
        const ClienteErro('Nome é obrigatório'),
      ],
    );
  });

  // ─── AtualizarClienteEvent ──────────────────────────────────

  group('AtualizarClienteEvent', () {
    blocTest<ClienteBloc, ClienteState>(
      'deve emitir [Carregando, SalvoComSucesso] quando atualização OK',
      build: () {
        when(() => mockAtualizar(any())).thenAnswer((_) async => tCliente);
        return bloc;
      },
      act: (b) => b.add(AtualizarClienteEvent(tCliente)),
      expect: () => [
        const ClienteCarregando(),
        ClienteSalvoComSucesso(tCliente),
      ],
    );

    blocTest<ClienteBloc, ClienteState>(
      'deve emitir [Carregando, Erro] quando atualização falha',
      build: () {
        when(() => mockAtualizar(any())).thenThrow(
          const ServerFailure(message: 'Erro inesperado'),
        );
        return bloc;
      },
      act: (b) => b.add(AtualizarClienteEvent(tCliente)),
      expect: () => [
        const ClienteCarregando(),
        const ClienteErro('Erro inesperado'),
      ],
    );
  });
}
