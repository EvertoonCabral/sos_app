import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Datasource local para queries de dashboard usando Drift.
abstract class DashboardLocalDatasource {
  Future<Map<String, dynamic>> obterResumoPeriodo({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<List<Map<String, dynamic>>> obterKmPorCliente({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<Map<String, dynamic>> obterTempoPorEtapa({
    required DateTime inicio,
    required DateTime fim,
  });

  Future<Map<DateTime, int>> obterAtendimentosPorDia({
    required DateTime inicio,
    required DateTime fim,
  });
}

class DashboardLocalDatasourceImpl implements DashboardLocalDatasource {
  DashboardLocalDatasourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Map<String, dynamic>> obterResumoPeriodo({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    // KM operacional e receita de concluídos
    final concluidos = await (_db.select(_db.atendimentos)
          ..where((t) =>
              t.status.equals('concluido') &
              t.concluidoEm.isBiggerOrEqualValue(inicio) &
              t.concluidoEm.isSmallerOrEqualValue(fim)))
        .get();

    double kmOperacional = 0;
    double kmCobrado = 0;
    double receitaTotal = 0;

    for (final a in concluidos) {
      // Fallback para atendimentos porKm concluídos sem GPS: usa distância estimada
      final kmReal = a.distanciaRealKm ?? a.distanciaEstimadaKm;
      kmOperacional += kmReal;
      kmCobrado += kmReal;
      receitaTotal += a.valorCobrado ?? (kmReal * a.valorPorKm);
    }

    // Contagem por status — usa concluidoEm/criadoEm conforme semântica:
    // totalConcluidos: concluídos NO período (consistente com km/receita)
    // totalAtendimentos, totalCancelados, totalEmAndamento: criados no período
    final todos = await (_db.select(_db.atendimentos)
          ..where((t) =>
              t.criadoEm.isBiggerOrEqualValue(inicio) &
              t.criadoEm.isSmallerOrEqualValue(fim)))
        .get();

    // totalConcluidos: mesma base do kmCobrado/receitaTotal (por concluidoEm)
    final totalConcluidos = concluidos.length;

    int totalCancelados = 0;
    int totalEmAndamento = 0;

    for (final a in todos) {
      switch (a.status) {
        case 'cancelado':
          totalCancelados++;
          break;
        case 'concluido':
          // já contabilizado em totalConcluidos
          break;
        default:
          totalEmAndamento++;
      }
    }

    return {
      'kmOperacional': kmOperacional,
      'kmCobrado': kmCobrado,
      'receitaTotal': receitaTotal,
      'totalAtendimentos': todos.length,
      'totalConcluidos': totalConcluidos,
      'totalCancelados': totalCancelados,
      'totalEmAndamento': totalEmAndamento,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> obterKmPorCliente({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    // Obter atendimentos concluídos no período
    final concluidos = await (_db.select(_db.atendimentos)
          ..where((t) =>
              t.status.equals('concluido') &
              t.concluidoEm.isBiggerOrEqualValue(inicio) &
              t.concluidoEm.isSmallerOrEqualValue(fim)))
        .get();

    // Agrupar por clienteId
    final Map<String, Map<String, dynamic>> agrupado = {};
    for (final a in concluidos) {
      final existing = agrupado[a.clienteId];
      if (existing == null) {
        agrupado[a.clienteId] = {
          'clienteId': a.clienteId,
          'totalAtendimentos': 1,
          'totalKm': a.distanciaRealKm ?? 0.0,
          'totalReceita': a.valorCobrado ?? 0.0,
        };
      } else {
        existing['totalAtendimentos'] =
            (existing['totalAtendimentos'] as int) + 1;
        existing['totalKm'] =
            (existing['totalKm'] as double) + (a.distanciaRealKm ?? 0.0);
        existing['totalReceita'] =
            (existing['totalReceita'] as double) + (a.valorCobrado ?? 0.0);
      }
    }

    // Buscar nomes dos clientes
    final result = <Map<String, dynamic>>[];
    for (final entry in agrupado.values) {
      final clienteRow = await (_db.select(_db.clientes)
            ..where((t) => t.id.equals(entry['clienteId'] as String)))
          .getSingleOrNull();

      result.add({
        ...entry,
        'clienteNome': clienteRow?.nome ?? 'Desconhecido',
      });
    }

    // Ordenar por totalKm desc
    result.sort(
        (a, b) => (b['totalKm'] as double).compareTo(a['totalKm'] as double));

    return result;
  }

  @override
  Future<Map<String, dynamic>> obterTempoPorEtapa({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    final concluidos = await (_db.select(_db.atendimentos)
          ..where((t) =>
              t.status.equals('concluido') &
              t.concluidoEm.isBiggerOrEqualValue(inicio) &
              t.concluidoEm.isSmallerOrEqualValue(fim)))
        .get();

    // Filtrar apenas os que têm todos os timestamps
    final completos = concluidos.where((a) =>
        a.iniciadoEm != null &&
        a.chegadaColetaEm != null &&
        a.chegadaEntregaEm != null &&
        a.inicioRetornoEm != null &&
        a.concluidoEm != null);

    if (completos.isEmpty) {
      return {
        'mediaMinutosAteColeta': 0.0,
        'mediaMinutosColetaEntrega': 0.0,
        'mediaMinutosEntregaRetorno': 0.0,
        'mediaMinutosRetornoBase': 0.0,
        'totalAnalisados': 0,
      };
    }

    double somaAteColeta = 0;
    double somaColetaEntrega = 0;
    double somaEntregaRetorno = 0;
    double somaRetornoBase = 0;
    int count = completos.length;

    for (final a in completos) {
      somaAteColeta +=
          a.chegadaColetaEm!.difference(a.iniciadoEm!).inSeconds / 60.0;
      somaColetaEntrega +=
          a.chegadaEntregaEm!.difference(a.chegadaColetaEm!).inSeconds / 60.0;
      somaEntregaRetorno +=
          a.inicioRetornoEm!.difference(a.chegadaEntregaEm!).inSeconds / 60.0;
      somaRetornoBase +=
          a.concluidoEm!.difference(a.inicioRetornoEm!).inSeconds / 60.0;
    }

    return {
      'mediaMinutosAteColeta': somaAteColeta / count,
      'mediaMinutosColetaEntrega': somaColetaEntrega / count,
      'mediaMinutosEntregaRetorno': somaEntregaRetorno / count,
      'mediaMinutosRetornoBase': somaRetornoBase / count,
      'totalAnalisados': count,
    };
  }

  @override
  Future<Map<DateTime, int>> obterAtendimentosPorDia({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    final concluidos = await (_db.select(_db.atendimentos)
          ..where((t) =>
              t.status.equals('concluido') &
              t.concluidoEm.isBiggerOrEqualValue(inicio) &
              t.concluidoEm.isSmallerOrEqualValue(fim)))
        .get();

    final Map<DateTime, int> resultado = {};
    for (final a in concluidos) {
      if (a.concluidoEm != null) {
        final dia = DateTime(
          a.concluidoEm!.year,
          a.concluidoEm!.month,
          a.concluidoEm!.day,
        );
        resultado[dia] = (resultado[dia] ?? 0) + 1;
      }
    }

    return resultado;
  }
}
