import 'package:equatable/equatable.dart';

import '../../domain/entities/base.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

class ListarBasesEvent extends BaseEvent {
  const ListarBasesEvent();
}

class CriarBaseEvent extends BaseEvent {
  const CriarBaseEvent(this.base);

  final Base base;

  @override
  List<Object?> get props => [base];
}

class DefinirBasePrincipalEvent extends BaseEvent {
  const DefinirBasePrincipalEvent(this.baseId);

  final String baseId;

  @override
  List<Object?> get props => [baseId];
}
