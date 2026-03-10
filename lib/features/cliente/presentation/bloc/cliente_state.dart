import 'package:equatable/equatable.dart';

import '../../domain/entities/cliente.dart';

abstract class ClienteState extends Equatable {
  const ClienteState();

  @override
  List<Object?> get props => [];
}

class ClienteInicial extends ClienteState {
  const ClienteInicial();
}

class ClienteCarregando extends ClienteState {
  const ClienteCarregando();
}

class ClienteListaCarregada extends ClienteState {
  const ClienteListaCarregada(this.clientes);

  final List<Cliente> clientes;

  @override
  List<Object?> get props => [clientes];
}

class ClienteSalvoComSucesso extends ClienteState {
  const ClienteSalvoComSucesso(this.cliente);

  final Cliente cliente;

  @override
  List<Object?> get props => [cliente];
}

class ClienteErro extends ClienteState {
  const ClienteErro(this.mensagem);

  final String mensagem;

  @override
  List<Object?> get props => [mensagem];
}
