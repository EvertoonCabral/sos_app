import '../../domain/entities/resumo_periodo.dart';

class ResumoPeriodoModel {
  const ResumoPeriodoModel({
    required this.kmOperacional,
    required this.kmCobrado,
    required this.receitaTotal,
    required this.totalAtendimentos,
    required this.totalConcluidos,
    required this.totalCancelados,
    required this.totalEmAndamento,
  });

  factory ResumoPeriodoModel.fromJson(Map<String, dynamic> json) {
    return ResumoPeriodoModel(
      kmOperacional: (json['kmOperacional'] as num).toDouble(),
      kmCobrado: (json['kmCobrado'] as num).toDouble(),
      receitaTotal: (json['receitaTotal'] as num).toDouble(),
      totalAtendimentos: json['totalAtendimentos'] as int,
      totalConcluidos: json['totalConcluidos'] as int,
      totalCancelados: json['totalCancelados'] as int,
      totalEmAndamento: json['totalEmAndamento'] as int,
    );
  }

  final double kmOperacional;
  final double kmCobrado;
  final double receitaTotal;
  final int totalAtendimentos;
  final int totalConcluidos;
  final int totalCancelados;
  final int totalEmAndamento;

  ResumoPeriodo toEntity() => ResumoPeriodo(
        kmOperacional: kmOperacional,
        kmCobrado: kmCobrado,
        receitaTotal: receitaTotal,
        totalAtendimentos: totalAtendimentos,
        totalConcluidos: totalConcluidos,
        totalCancelados: totalCancelados,
        totalEmAndamento: totalEmAndamento,
      );
}
