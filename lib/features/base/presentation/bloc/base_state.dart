import 'package:equatable/equatable.dart';

import '../../domain/entities/base.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class BaseInicial extends BaseState {
  const BaseInicial();
}

class BaseCarregando extends BaseState {
  const BaseCarregando();
}

class BaseListaCarregada extends BaseState {
  const BaseListaCarregada(this.bases);

  final List<Base> bases;

  @override
  List<Object?> get props => [bases];
}

class BaseSalvaComSucesso extends BaseState {
  const BaseSalvaComSucesso(this.base);

  final Base base;

  @override
  List<Object?> get props => [base];
}

class BaseErro extends BaseState {
  const BaseErro(this.mensagem);

  final String mensagem;

  @override
  List<Object?> get props => [mensagem];
}
