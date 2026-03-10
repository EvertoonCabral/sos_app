import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/atualizar_cliente.dart';
import '../../domain/usecases/buscar_clientes.dart';
import '../../domain/usecases/criar_cliente.dart';
import 'cliente_event.dart';
import 'cliente_state.dart';

class ClienteBloc extends Bloc<ClienteEvent, ClienteState> {
  ClienteBloc({
    required CriarCliente criarCliente,
    required BuscarClientes buscarClientes,
    required AtualizarCliente atualizarCliente,
  })  : _criarCliente = criarCliente,
        _buscarClientes = buscarClientes,
        _atualizarCliente = atualizarCliente,
        super(const ClienteInicial()) {
    on<BuscarClientesEvent>(_onBuscar);
    on<CriarClienteEvent>(_onCriar);
    on<AtualizarClienteEvent>(_onAtualizar);
  }

  final CriarCliente _criarCliente;
  final BuscarClientes _buscarClientes;
  final AtualizarCliente _atualizarCliente;

  Future<void> _onBuscar(
    BuscarClientesEvent event,
    Emitter<ClienteState> emit,
  ) async {
    emit(const ClienteCarregando());
    try {
      final clientes = await _buscarClientes(event.query);
      emit(ClienteListaCarregada(clientes));
    } on Failure catch (f) {
      emit(ClienteErro(f.message));
    }
  }

  Future<void> _onCriar(
    CriarClienteEvent event,
    Emitter<ClienteState> emit,
  ) async {
    emit(const ClienteCarregando());
    try {
      final cliente = await _criarCliente(
        CriarClienteParams(
          id: const Uuid().v4(),
          nome: event.nome,
          telefone: event.telefone,
          documento: event.documento,
        ),
      );
      emit(ClienteSalvoComSucesso(cliente));
    } on Failure catch (f) {
      emit(ClienteErro(f.message));
    }
  }

  Future<void> _onAtualizar(
    AtualizarClienteEvent event,
    Emitter<ClienteState> emit,
  ) async {
    emit(const ClienteCarregando());
    try {
      final cliente = await _atualizarCliente(event.cliente);
      emit(ClienteSalvoComSucesso(cliente));
    } on Failure catch (f) {
      emit(ClienteErro(f.message));
    }
  }
}
