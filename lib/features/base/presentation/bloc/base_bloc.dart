import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/criar_base.dart';
import '../../domain/usecases/definir_base_principal.dart';
import '../../domain/usecases/listar_bases.dart';
import 'base_event.dart';
import 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc({
    required CriarBase criarBase,
    required ListarBases listarBases,
    required DefinirBasePrincipal definirBasePrincipal,
  })  : _criarBase = criarBase,
        _listarBases = listarBases,
        _definirBasePrincipal = definirBasePrincipal,
        super(const BaseInicial()) {
    on<ListarBasesEvent>(_onListar);
    on<CriarBaseEvent>(_onCriar);
    on<DefinirBasePrincipalEvent>(_onDefinirPrincipal);
  }

  final CriarBase _criarBase;
  final ListarBases _listarBases;
  final DefinirBasePrincipal _definirBasePrincipal;

  Future<void> _onListar(
    ListarBasesEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(const BaseCarregando());
    try {
      final bases = await _listarBases();
      emit(BaseListaCarregada(bases));
    } on Failure catch (f) {
      emit(BaseErro(f.message));
    }
  }

  Future<void> _onCriar(
    CriarBaseEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(const BaseCarregando());
    try {
      final base = await _criarBase(event.base);
      emit(BaseSalvaComSucesso(base));
    } on Failure catch (f) {
      emit(BaseErro(f.message));
    }
  }

  Future<void> _onDefinirPrincipal(
    DefinirBasePrincipalEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(const BaseCarregando());
    try {
      await _definirBasePrincipal(event.baseId);
      // Recarrega a lista para refletir a mudança
      final bases = await _listarBases();
      emit(BaseListaCarregada(bases));
    } on Failure catch (f) {
      emit(BaseErro(f.message));
    }
  }
}
