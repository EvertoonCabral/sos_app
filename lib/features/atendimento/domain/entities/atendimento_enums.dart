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

// ---------------------------------------------------------------------------
// Conversores PascalCase ↔ camelCase para serialização com a API REST.
//
// O backend .NET serializa enums em PascalCase ("EmDeslocamento", "PorKm"),
// enquanto os nomes dos enums Dart são camelCase ("emDeslocamento", "porKm").
// ---------------------------------------------------------------------------

extension AtendimentoStatusApi on AtendimentoStatus {
  /// Converte para o valor PascalCase esperado pela API.
  /// Ex: `emDeslocamento` → `"EmDeslocamento"`
  String toApiValue() => name[0].toUpperCase() + name.substring(1);
}

extension TipoValorApi on TipoValor {
  /// Converte para o valor PascalCase esperado pela API.
  /// Ex: `porKm` → `"PorKm"`
  String toApiValue() => name[0].toUpperCase() + name.substring(1);
}

extension AtendimentoStatusParsing on String {
  /// Parseia valor PascalCase da API para o enum local.
  /// Ex: `"EmDeslocamento"` → `AtendimentoStatus.emDeslocamento`
  AtendimentoStatus toAtendimentoStatus() =>
      AtendimentoStatus.values.byName(this[0].toLowerCase() + substring(1));
}

extension TipoValorParsing on String {
  /// Parseia valor PascalCase da API para o enum local.
  /// Ex: `"PorKm"` → `TipoValor.porKm`
  TipoValor toTipoValor() =>
      TipoValor.values.byName(this[0].toLowerCase() + substring(1));
}
