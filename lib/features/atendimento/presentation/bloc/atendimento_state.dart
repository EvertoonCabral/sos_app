import 'package:equatable/equatable.dart';

import '../../domain/entities/atendimento.dart';

abstract class AtendimentoState extends Equatable {
  const AtendimentoState();

  @override
  List<Object?> get props => [];
}

class AtendimentoInicial extends AtendimentoState {
  const AtendimentoInicial();
}

class AtendimentoCarregando extends AtendimentoState {
  const AtendimentoCarregando();
}

class AtendimentoListaCarregada extends AtendimentoState {
  const AtendimentoListaCarregada(this.atendimentos);

  final List<Atendimento> atendimentos;

  @override
  List<Object?> get props => [atendimentos];
}

class AtendimentoSalvoComSucesso extends AtendimentoState {
  const AtendimentoSalvoComSucesso(this.atendimento);

  final Atendimento atendimento;

  @override
  List<Object?> get props => [atendimento];
}

class AtendimentoStatusAtualizado extends AtendimentoState {
  const AtendimentoStatusAtualizado(this.atendimento);

  final Atendimento atendimento;

  @override
  List<Object?> get props => [atendimento];
}

class AtendimentoErro extends AtendimentoState {
  const AtendimentoErro(this.mensagem);

  final String mensagem;

  @override
  List<Object?> get props => [mensagem];
}
