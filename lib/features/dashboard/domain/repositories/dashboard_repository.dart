import '../entities/resumo_cliente.dart';
import '../entities/resumo_periodo.dart';
import '../entities/tempo_por_etapa.dart';

/// Repositório para consultas de dashboard. Opera apenas no banco local.
abstract class DashboardRepository {
  /// Obtém resumo de métricas para um período.
  Future<ResumoPeriodo> obterResumoPeriodo({
    required DateTime inicio,
    required DateTime fim,
  });

  /// Obtém ranking de clientes por KM e atendimentos no período.
  Future<List<ResumoCliente>> obterKmPorCliente({
    required DateTime inicio,
    required DateTime fim,
  });

  /// Obtém tempo médio por etapa de atendimentos concluídos no período.
  Future<TempoPorEtapa> obterTempoPorEtapa({
    required DateTime inicio,
    required DateTime fim,
  });

  /// Obtém contagem de atendimentos concluídos agrupada por data.
  Future<Map<DateTime, int>> obterAtendimentosPorDia({
    required DateTime inicio,
    required DateTime fim,
  });
}
