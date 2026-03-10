import 'package:equatable/equatable.dart';

import '../../../../core/entities/local_geo.dart';
import '../../domain/entities/atendimento.dart';
import '../../domain/entities/atendimento_enums.dart';

abstract class AtendimentoEvent extends Equatable {
  const AtendimentoEvent();

  @override
  List<Object?> get props => [];
}

class ListarAtendimentosEvent extends AtendimentoEvent {
  const ListarAtendimentosEvent({this.status});

  final AtendimentoStatus? status;

  @override
  List<Object?> get props => [status];
}

class CriarAtendimentoEvent extends AtendimentoEvent {
  const CriarAtendimentoEvent({
    required this.id,
    required this.clienteId,
    required this.usuarioId,
    required this.pontoDeSaida,
    required this.localDeColeta,
    required this.localDeEntrega,
    required this.localDeRetorno,
    required this.valorPorKm,
    required this.tipoValor,
    this.valorFixo,
    this.observacoes,
  });

  final String id;
  final String clienteId;
  final String usuarioId;
  final LocalGeo pontoDeSaida;
  final LocalGeo localDeColeta;
  final LocalGeo localDeEntrega;
  final LocalGeo localDeRetorno;
  final double valorPorKm;
  final TipoValor tipoValor;
  final double? valorFixo;
  final String? observacoes;

  @override
  List<Object?> get props => [
        id,
        clienteId,
        usuarioId,
        pontoDeSaida,
        localDeColeta,
        localDeEntrega,
        localDeRetorno,
        valorPorKm,
        tipoValor,
        valorFixo,
        observacoes,
      ];
}

class AtualizarStatusEvent extends AtendimentoEvent {
  const AtualizarStatusEvent({
    required this.atendimento,
    required this.novoStatus,
  });

  final Atendimento atendimento;
  final AtendimentoStatus novoStatus;

  @override
  List<Object?> get props => [atendimento, novoStatus];
}
