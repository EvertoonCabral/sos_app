import '../models/atendimentos_por_dia_model.dart';
import '../models/resumo_cliente_model.dart';
import '../models/resumo_periodo_model.dart';
import '../models/tempo_por_etapa_model.dart';

abstract class DashboardRemoteDatasource {
  Future<ResumoPeriodoModel> obterResumoPeriodo({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<List<ResumoClienteModel>> obterKmPorCliente({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<TempoPorEtapaModel> obterTempoPorEtapa({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<List<AtendimentosPorDiaModel>> obterAtendimentosPorDia({
    required DateTime inicio,
    required DateTime fim,
  });
}
