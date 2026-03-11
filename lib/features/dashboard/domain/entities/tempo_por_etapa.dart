import 'package:equatable/equatable.dart';

/// Tempo médio por etapa do atendimento (em minutos).
/// RN-038: análise de tempo médio em cada status para análise operacional.
class TempoPorEtapa extends Equatable {
  const TempoPorEtapa({
    required this.mediaMinutosAteColeta,
    required this.mediaMinutosColetaEntrega,
    required this.mediaMinutosEntregaRetorno,
    required this.mediaMinutosRetornoBase,
    required this.totalAnalisados,
  });

  /// Tempo médio do início do deslocamento até a coleta.
  final double mediaMinutosAteColeta;

  /// Tempo médio da coleta até a entrega.
  final double mediaMinutosColetaEntrega;

  /// Tempo médio da entrega até início do retorno.
  final double mediaMinutosEntregaRetorno;

  /// Tempo médio do retorno até a conclusão.
  final double mediaMinutosRetornoBase;

  /// Quantidade de atendimentos usados no cálculo.
  final int totalAnalisados;

  @override
  List<Object?> get props => [
        mediaMinutosAteColeta,
        mediaMinutosColetaEntrega,
        mediaMinutosEntregaRetorno,
        mediaMinutosRetornoBase,
        totalAnalisados,
      ];
}
