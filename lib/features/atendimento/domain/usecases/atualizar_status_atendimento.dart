import '../../../../core/error/failures.dart';
import '../entities/atendimento.dart';
import '../entities/atendimento_enums.dart';
import '../repositories/atendimento_repository.dart';
import '../../../rastreamento/domain/usecases/calcular_valor_real.dart';

/// RN-016 a RN-022B: valida transições de status e atualiza timestamps.
class AtualizarStatusAtendimento {
  AtualizarStatusAtendimento(this._repository, this._calcularValorReal);

  final AtendimentoRepository _repository;
  final CalcularValorReal _calcularValorReal;

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
        if (atendimento.tipoValor == TipoValor.porKm) {
          final valorCobrado = await _calcularValorReal(
            atendimentoId: atendimento.id,
            valorPorKm: atendimento.valorPorKm,
          );
          atualizado = atualizado.copyWith(
            distanciaRealKm: valorCobrado / atendimento.valorPorKm,
            valorCobrado: valorCobrado,
          );
        }
        break;
      default:
        break;
    }

    return _repository.atualizarStatus(atualizado);
  }
}
