/// Tipo de valor cobrado no atendimento.
enum TipoValor { fixo, porKm }

/// Status do ciclo de vida do atendimento.
/// Transições válidas:
/// rascunho → emDeslocamento → emColeta → emEntrega → retornando → concluido
/// Qualquer status antes de concluido pode ir para cancelado.
enum AtendimentoStatus {
  rascunho,
  emDeslocamento,
  emColeta,
  emEntrega,
  retornando,
  concluido,
  cancelado,
}

/// Mapa de transições válidas de status.
const Map<AtendimentoStatus, List<AtendimentoStatus>> transicoesValidas = {
  AtendimentoStatus.rascunho: [
    AtendimentoStatus.emDeslocamento,
    AtendimentoStatus.cancelado,
  ],
  AtendimentoStatus.emDeslocamento: [
    AtendimentoStatus.emColeta,
    AtendimentoStatus.cancelado,
  ],
  AtendimentoStatus.emColeta: [
    AtendimentoStatus.emEntrega,
    AtendimentoStatus.cancelado,
  ],
  AtendimentoStatus.emEntrega: [
    AtendimentoStatus.retornando,
    AtendimentoStatus.cancelado,
  ],
  AtendimentoStatus.retornando: [
    AtendimentoStatus.concluido,
    AtendimentoStatus.cancelado,
  ],
  AtendimentoStatus.concluido: [],
  AtendimentoStatus.cancelado: [],
};
