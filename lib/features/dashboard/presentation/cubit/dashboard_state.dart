import 'package:equatable/equatable.dart';

import '../../domain/entities/resumo_cliente.dart';
import '../../domain/entities/resumo_periodo.dart';
import '../../domain/entities/tempo_por_etapa.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInicial extends DashboardState {
  const DashboardInicial();
}

class DashboardCarregando extends DashboardState {
  const DashboardCarregando();
}

class DashboardCarregado extends DashboardState {
  const DashboardCarregado({
    required this.resumo,
    required this.rankingClientes,
    required this.tempoPorEtapa,
    required this.atendimentosPorDia,
    required this.inicio,
    required this.fim,
  });

  final ResumoPeriodo resumo;
  final List<ResumoCliente> rankingClientes;
  final TempoPorEtapa tempoPorEtapa;
  final Map<DateTime, int> atendimentosPorDia;
  final DateTime inicio;
  final DateTime fim;

  @override
  List<Object?> get props => [
        resumo,
        rankingClientes,
        tempoPorEtapa,
        atendimentosPorDia,
        inicio,
        fim,
      ];
}

class DashboardErro extends DashboardState {
  const DashboardErro(this.mensagem);

  final String mensagem;

  @override
  List<Object?> get props => [mensagem];
}
