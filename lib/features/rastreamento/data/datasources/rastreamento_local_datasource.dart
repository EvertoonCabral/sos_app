import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/app_database.dart' show AppDatabase;
import '../models/ponto_rastreamento_model.dart';

abstract class RastreamentoLocalDatasource {
  Future<void> inserir(PontoRastreamentoModel model);
  Future<List<PontoRastreamentoModel>> listarPorAtendimento(
      String atendimentoId);
  Future<List<PontoRastreamentoModel>> listarNaoSincronizados();
  Future<void> marcarComoSincronizados(List<String> ids);
}

class RastreamentoLocalDatasourceImpl implements RastreamentoLocalDatasource {
  RastreamentoLocalDatasourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> inserir(PontoRastreamentoModel model) async {
    await _db.into(_db.pontosRastreamento).insert(
          db.PontosRastreamentoCompanion.insert(
            id: model.id,
            atendimentoId: model.atendimentoId,
            latitude: model.latitude,
            longitude: model.longitude,
            accuracy: model.accuracy,
            velocidade: Value(model.velocidade),
            timestamp: DateTime.parse(model.timestamp),
          ),
        );
  }

  @override
  Future<List<PontoRastreamentoModel>> listarPorAtendimento(
      String atendimentoId) async {
    final rows = await (_db.select(_db.pontosRastreamento)
          ..where((t) => t.atendimentoId.equals(atendimentoId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
    return rows.map(_rowToModel).toList();
  }

  @override
  Future<List<PontoRastreamentoModel>> listarNaoSincronizados() async {
    final rows = await (_db.select(_db.pontosRastreamento)
          ..where((t) => t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
    return rows.map(_rowToModel).toList();
  }

  @override
  Future<void> marcarComoSincronizados(List<String> ids) async {
    await (_db.update(_db.pontosRastreamento)..where((t) => t.id.isIn(ids)))
        .write(
      const db.PontosRastreamentoCompanion(synced: Value(true)),
    );
  }

  PontoRastreamentoModel _rowToModel(db.PontosRastreamentoData row) =>
      PontoRastreamentoModel(
        id: row.id,
        atendimentoId: row.atendimentoId,
        latitude: row.latitude,
        longitude: row.longitude,
        accuracy: row.accuracy,
        velocidade: row.velocidade,
        timestamp: row.timestamp.toIso8601String(),
        synced: row.synced,
      );
}
