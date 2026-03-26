import '../../../../core/error/failures.dart';
import '../entities/atendimento.dart';
import '../entities/atendimento_enums.dart';
import '../repositories/atendimento_repository.dart';

/// RN-016 a RN-022B: valida transições de status e atualiza timestamps.
class AtualizarStatusAtendimento {
  AtualizarStatusAtendimento(this._repository);

  final AtendimentoRepository _repository;

  Future<Atendimento> call({
    required Atendimento atendimento,
    required AtendimentoStatus novoStatus,
  }) async {
    final permitidos = transicoesValidas[atendimento.status] ?? [];
    if (!permitidos.contains(novoStatus)) {
      throw ValidationFailure(
        message:
            'Transição inválida: ${atendimento.status.name} → ${novoStatus.name}',
      );
    }

    final now = DateTime.now();
    var atualizado = atendimento.copyWith(
      status: novoStatus,
      atualizadoEm: now,
    );

    switch (novoStatus) {
      case AtendimentoStatus.emDeslocamento:
        atualizado = atualizado.copyWith(iniciadoEm: now);
        break;
      case AtendimentoStatus.emColeta:
        atualizado = atualizado.copyWith(chegadaColetaEm: now);
        break;
      case AtendimentoStatus.emEntrega:
        atualizado = atualizado.copyWith(chegadaEntregaEm: now);
        break;
      case AtendimentoStatus.retornando:
        atualizado = atualizado.copyWith(inicioRetornoEm: now);
        break;
      case AtendimentoStatus.concluido:
        atualizado = atualizado.copyWith(concluidoEm: now);
        break;
      default:
        break;
    }

    return _repository.atualizarStatus(atualizado);
  }
}
