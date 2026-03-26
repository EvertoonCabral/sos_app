import '../../domain/entities/tempo_por_etapa.dart';

class TempoPorEtapaModel {
  const TempoPorEtapaModel({
    required this.mediaMinutosAteColeta,
    required this.mediaMinutosColetaEntrega,
    required this.mediaMinutosEntregaRetorno,
    required this.mediaMinutosRetornoBase,
    required this.totalAnalisados,
  });

  factory TempoPorEtapaModel.fromJson(Map<String, dynamic> json) {
    return TempoPorEtapaModel(
      mediaMinutosAteColeta: (json['mediaMinutosAteColeta'] as num).toDouble(),
      mediaMinutosColetaEntrega:
          (json['mediaMinutosColetaEntrega'] as num).toDouble(),
      mediaMinutosEntregaRetorno:
          (json['mediaMinutosEntregaRetorno'] as num).toDouble(),
      mediaMinutosRetornoBase:
          (json['mediaMinutosRetornoBase'] as num).toDouble(),
      totalAnalisados: json['totalAnalisados'] as int,
    );
  }

  final double mediaMinutosAteColeta;
  final double mediaMinutosColetaEntrega;
  final double mediaMinutosEntregaRetorno;
  final double mediaMinutosRetornoBase;
  final int totalAnalisados;

  TempoPorEtapa toEntity() => TempoPorEtapa(
        mediaMinutosAteColeta: mediaMinutosAteColeta,
        mediaMinutosColetaEntrega: mediaMinutosColetaEntrega,
        mediaMinutosEntregaRetorno: mediaMinutosEntregaRetorno,
        mediaMinutosRetornoBase: mediaMinutosRetornoBase,
        totalAnalisados: totalAnalisados,
      );
}
