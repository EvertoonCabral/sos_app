import 'package:equatable/equatable.dart';

import '../../domain/entities/cliente.dart';

abstract class ClienteEvent extends Equatable {
  const ClienteEvent();

  @override
  List<Object?> get props => [];
}

class BuscarClientesEvent extends ClienteEvent {
  const BuscarClientesEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class CriarClienteEvent extends ClienteEvent {
  const CriarClienteEvent({
    required this.nome,
    required this.telefone,
    this.documento,
  });

  final String nome;
  final String telefone;
  final String? documento;

  @override
  List<Object?> get props => [nome, telefone, documento];
}

class AtualizarClienteEvent extends ClienteEvent {
  const AtualizarClienteEvent(this.cliente);

  final Cliente cliente;

  @override
  List<Object?> get props => [cliente];
}
