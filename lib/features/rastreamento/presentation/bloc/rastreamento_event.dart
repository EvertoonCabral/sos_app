import 'package:equatable/equatable.dart';

import '../../domain/entities/ponto_rastreamento.dart';

abstract class RastreamentoEvent extends Equatable {
  const RastreamentoEvent();

  @override
  List<Object?> get props => [];
}

class IniciarRastreamentoEvent extends RastreamentoEvent {
  const IniciarRastreamentoEvent({required this.atendimentoId});

  final String atendimentoId;

  @override
  List<Object?> get props => [atendimentoId];
}

class PararRastreamentoEvent extends RastreamentoEvent {
  const PararRastreamentoEvent();
}

class RegistrarPontoEvent extends RastreamentoEvent {
  const RegistrarPontoEvent({required this.ponto});

  final PontoRastreamento ponto;

  @override
  List<Object?> get props => [ponto];
}

class ObterPercursoEvent extends RastreamentoEvent {
  const ObterPercursoEvent({required this.atendimentoId});

  final String atendimentoId;

  @override
  List<Object?> get props => [atendimentoId];
}

class CalcularValorRealEvent extends RastreamentoEvent {
  const CalcularValorRealEvent({
    required this.atendimentoId,
    required this.valorPorKm,
  });

  final String atendimentoId;
  final double valorPorKm;

  @override
  List<Object?> get props => [atendimentoId, valorPorKm];
}
