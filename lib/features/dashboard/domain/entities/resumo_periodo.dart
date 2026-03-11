import 'package:equatable/equatable.dart';

/// Resumo de métricas para um período selecionado.
/// RN-038: km operacional, km cobrado, receita, contagem por status.
class ResumoPeriodo extends Equatable {
  const ResumoPeriodo({
    required this.kmOperacional,
    required this.kmCobrado,
    required this.receitaTotal,
    required this.totalAtendimentos,
    required this.totalConcluidos,
    required this.totalCancelados,
    required this.totalEmAndamento,
  });

  /// KM total rodado pela viatura (distância real).
  final double kmOperacional;

  /// KM total cobrado dos clientes (distância real de concluídos).
  final double kmCobrado;

  /// Soma de valorCobrado de atendimentos concluídos.
  final double receitaTotal;

  /// Total de atendimentos no período (todos os status).
  final int totalAtendimentos;

  /// Total de atendimentos concluídos.
  final int totalConcluidos;

  /// Total de atendimentos cancelados.
  final int totalCancelados;

  /// Total de atendimentos em andamento (não concluído nem cancelado).
  final int totalEmAndamento;

  @override
  List<Object?> get props => [
        kmOperacional,
        kmCobrado,
        receitaTotal,
        totalAtendimentos,
        totalConcluidos,
        totalCancelados,
        totalEmAndamento,
      ];
}
