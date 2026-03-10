import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/atualizar_status_atendimento.dart';
import '../../domain/usecases/criar_atendimento.dart';
import '../../domain/usecases/listar_atendimentos.dart';
import 'atendimento_event.dart';
import 'atendimento_state.dart';

class AtendimentoBloc extends Bloc<AtendimentoEvent, AtendimentoState> {
  AtendimentoBloc({
    required CriarAtendimento criarAtendimento,
    required ListarAtendimentos listarAtendimentos,
    required AtualizarStatusAtendimento atualizarStatusAtendimento,
  })  : _criarAtendimento = criarAtendimento,
        _listarAtendimentos = listarAtendimentos,
        _atualizarStatus = atualizarStatusAtendimento,
        super(const AtendimentoInicial()) {
    on<ListarAtendimentosEvent>(_onListar);
    on<CriarAtendimentoEvent>(_onCriar);
    on<AtualizarStatusEvent>(_onAtualizarStatus);
  }

  final CriarAtendimento _criarAtendimento;
  final ListarAtendimentos _listarAtendimentos;
  final AtualizarStatusAtendimento _atualizarStatus;

  Future<void> _onListar(
    ListarAtendimentosEvent event,
    Emitter<AtendimentoState> emit,
  ) async {
    emit(const AtendimentoCarregando());
    try {
      final lista = await _listarAtendimentos(status: event.status);
      emit(AtendimentoListaCarregada(lista));
    } on Failure catch (f) {
      emit(AtendimentoErro(f.message));
    }
  }

  Future<void> _onCriar(
    CriarAtendimentoEvent event,
    Emitter<AtendimentoState> emit,
  ) async {
    emit(const AtendimentoCarregando());
    try {
      final atendimento = await _criarAtendimento(CriarAtendimentoParams(
        id: event.id,
        clienteId: event.clienteId,
        usuarioId: event.usuarioId,
        pontoDeSaida: event.pontoDeSaida,
        localDeColeta: event.localDeColeta,
        localDeEntrega: event.localDeEntrega,
        localDeRetorno: event.localDeRetorno,
        valorPorKm: event.valorPorKm,
        tipoValor: event.tipoValor,
        valorFixo: event.valorFixo,
        observacoes: event.observacoes,
      ));
      emit(AtendimentoSalvoComSucesso(atendimento));
    } on Failure catch (f) {
      emit(AtendimentoErro(f.message));
    }
  }

  Future<void> _onAtualizarStatus(
    AtualizarStatusEvent event,
    Emitter<AtendimentoState> emit,
  ) async {
    emit(const AtendimentoCarregando());
    try {
      final atualizado = await _atualizarStatus(
        atendimento: event.atendimento,
        novoStatus: event.novoStatus,
      );
      emit(AtendimentoStatusAtualizado(atualizado));
    } on Failure catch (f) {
      emit(AtendimentoErro(f.message));
    }
  }
}
