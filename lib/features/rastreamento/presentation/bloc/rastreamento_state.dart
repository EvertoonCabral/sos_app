import 'package:equatable/equatable.dart';

import '../../domain/entities/ponto_rastreamento.dart';

abstract class RastreamentoState extends Equatable {
  const RastreamentoState();

  @override
  List<Object?> get props => [];
}

class RastreamentoInicial extends RastreamentoState {
  const RastreamentoInicial();
}

class RastreamentoEmAndamento extends RastreamentoState {
  const RastreamentoEmAndamento({
    required this.atendimentoId,
    required this.pontosColetados,
  });

  final String atendimentoId;
  final int pontosColetados;

  @override
  List<Object?> get props => [atendimentoId, pontosColetados];
}

class RastreamentoParado extends RastreamentoState {
  const RastreamentoParado();
}

class PercursoCarregado extends RastreamentoState {
  const PercursoCarregado(this.pontos);

  final List<PontoRastreamento> pontos;

  @override
  List<Object?> get props => [pontos];
}

class ValorRealCalculado extends RastreamentoState {
  const ValorRealCalculado({
    required this.valorReal,
    required this.distanciaKm,
  });

  final double valorReal;
  final double distanciaKm;

  @override
  List<Object?> get props => [valorReal, distanciaKm];
}

class RastreamentoErro extends RastreamentoState {
  const RastreamentoErro(this.mensagem);

  final String mensagem;

  @override
  List<Object?> get props => [mensagem];
}
