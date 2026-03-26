import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/resumo_cliente.dart';
import '../../domain/entities/resumo_periodo.dart';
import '../../domain/entities/tempo_por_etapa.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  final DashboardLocalDatasource localDatasource;
  final DashboardRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  @override
  Future<ResumoPeriodo> obterResumoPeriodo({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDatasource.obterResumoPeriodo(
          inicio: inicio,
          fim: fim,
        );
        return remote.toEntity();
      } on ServerException {
        // fallback local
      }
    }

    final data = await localDatasource.obterResumoPeriodo(
      inicio: inicio,
      fim: fim,
    );
    return ResumoPeriodo(
      kmOperacional: data['kmOperacional'] as double,
      kmCobrado: data['kmCobrado'] as double,
      receitaTotal: data['receitaTotal'] as double,
      totalAtendimentos: data['totalAtendimentos'] as int,
      totalConcluidos: data['totalConcluidos'] as int,
      totalCancelados: data['totalCancelados'] as int,
      totalEmAndamento: data['totalEmAndamento'] as int,
    );
  }

  @override
  Future<List<ResumoCliente>> obterKmPorCliente({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDatasource.obterKmPorCliente(
          inicio: inicio,
          fim: fim,
        );
        return remote.map((item) => item.toEntity()).toList();
      } on ServerException {
        // fallback local
      }
    }

    final data = await localDatasource.obterKmPorCliente(
      inicio: inicio,
      fim: fim,
    );
    return data
        .map((item) => ResumoCliente(
              clienteId: item['clienteId'] as String,
              clienteNome: item['clienteNome'] as String,
              totalAtendimentos: item['totalAtendimentos'] as int,
              totalKm: item['totalKm'] as double,
              totalReceita: item['totalReceita'] as double,
            ))
        .toList();
  }

  @override
  Future<TempoPorEtapa> obterTempoPorEtapa({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDatasource.obterTempoPorEtapa(
          inicio: inicio,
          fim: fim,
        );
        return remote.toEntity();
      } on ServerException {
        // fallback local
      }
    }

    final data = await localDatasource.obterTempoPorEtapa(
      inicio: inicio,
      fim: fim,
    );
    return TempoPorEtapa(
      mediaMinutosAteColeta: data['mediaMinutosAteColeta'] as double,
      mediaMinutosColetaEntrega: data['mediaMinutosColetaEntrega'] as double,
      mediaMinutosEntregaRetorno: data['mediaMinutosEntregaRetorno'] as double,
      mediaMinutosRetornoBase: data['mediaMinutosRetornoBase'] as double,
      totalAnalisados: data['totalAnalisados'] as int,
    );
  }

  @override
  Future<Map<DateTime, int>> obterAtendimentosPorDia({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remote = await remoteDatasource.obterAtendimentosPorDia(
          inicio: inicio,
          fim: fim,
        );
        return {
          for (final item in remote)
            DateTime(item.data.year, item.data.month, item.data.day):
                item.quantidade,
        };
      } on ServerException {
        // fallback local
      }
    }

    return localDatasource.obterAtendimentosPorDia(
      inicio: inicio,
      fim: fim,
    );
  }
}
