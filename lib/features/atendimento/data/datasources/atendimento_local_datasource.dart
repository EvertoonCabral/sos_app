import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/app_database.dart' show AppDatabase;
import '../models/atendimento_model.dart';

/// Datasource local para Atendimentos usando Drift.
abstract class AtendimentoLocalDatasource {
  Future<void> inserir(AtendimentoModel model);
  Future<void> atualizar(AtendimentoModel model);
  Future<AtendimentoModel?> obterPorId(String id);
  Future<List<AtendimentoModel>> listarTodos();
  Future<List<AtendimentoModel>> listarPorStatus(String status);
}

class AtendimentoLocalDatasourceImpl implements AtendimentoLocalDatasource {
  AtendimentoLocalDatasourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> inserir(AtendimentoModel model) async {
    await _db.into(_db.atendimentos).insert(
          db.AtendimentosCompanion.insert(
            id: model.id,
            clienteId: model.clienteId,
            usuarioId: model.usuarioId,
            pontoDeSaidaJson: model.pontoDeSaidaJson,
            localDeColetaJson: model.localDeColetaJson,
            localDeEntregaJson: model.localDeEntregaJson,
            localDeRetornoJson: model.localDeRetornoJson,
            valorPorKm: model.valorPorKm,
            distanciaEstimadaKm: model.distanciaEstimadaKm,
            distanciaRealKm: Value(model.distanciaRealKm),
            valorCobrado: Value(model.valorCobrado),
            tipoValor: model.tipoValor,
            status: model.status,
            observacoes: Value(model.observacoes),
            criadoEm: DateTime.parse(model.criadoEm),
            atualizadoEm: DateTime.parse(model.atualizadoEm),
            iniciadoEm: Value(
              model.iniciadoEm != null
                  ? DateTime.parse(model.iniciadoEm!)
                  : null,
            ),
            chegadaColetaEm: Value(
              model.chegadaColetaEm != null
                  ? DateTime.parse(model.chegadaColetaEm!)
                  : null,
            ),
            chegadaEntregaEm: Value(
              model.chegadaEntregaEm != null
                  ? DateTime.parse(model.chegadaEntregaEm!)
                  : null,
            ),
            inicioRetornoEm: Value(
              model.inicioRetornoEm != null
                  ? DateTime.parse(model.inicioRetornoEm!)
                  : null,
            ),
            concluidoEm: Value(
              model.concluidoEm != null
                  ? DateTime.parse(model.concluidoEm!)
                  : null,
            ),
            sincronizadoEm: Value(
              model.sincronizadoEm != null
                  ? DateTime.parse(model.sincronizadoEm!)
                  : null,
            ),
          ),
        );
  }

  @override
  Future<void> atualizar(AtendimentoModel model) async {
    await (_db.update(_db.atendimentos)..where((t) => t.id.equals(model.id)))
        .write(
      db.AtendimentosCompanion(
        clienteId: Value(model.clienteId),
        usuarioId: Value(model.usuarioId),
        pontoDeSaidaJson: Value(model.pontoDeSaidaJson),
        localDeColetaJson: Value(model.localDeColetaJson),
        localDeEntregaJson: Value(model.localDeEntregaJson),
        localDeRetornoJson: Value(model.localDeRetornoJson),
        valorPorKm: Value(model.valorPorKm),
        distanciaEstimadaKm: Value(model.distanciaEstimadaKm),
        distanciaRealKm: Value(model.distanciaRealKm),
        valorCobrado: Value(model.valorCobrado),
        tipoValor: Value(model.tipoValor),
        status: Value(model.status),
        observacoes: Value(model.observacoes),
        atualizadoEm: Value(DateTime.parse(model.atualizadoEm)),
        iniciadoEm: Value(
          model.iniciadoEm != null ? DateTime.parse(model.iniciadoEm!) : null,
        ),
        chegadaColetaEm: Value(
          model.chegadaColetaEm != null
              ? DateTime.parse(model.chegadaColetaEm!)
              : null,
        ),
        chegadaEntregaEm: Value(
          model.chegadaEntregaEm != null
              ? DateTime.parse(model.chegadaEntregaEm!)
              : null,
        ),
        inicioRetornoEm: Value(
          model.inicioRetornoEm != null
              ? DateTime.parse(model.inicioRetornoEm!)
              : null,
        ),
        concluidoEm: Value(
          model.concluidoEm != null ? DateTime.parse(model.concluidoEm!) : null,
        ),
        sincronizadoEm: Value(
          model.sincronizadoEm != null
              ? DateTime.parse(model.sincronizadoEm!)
              : null,
        ),
      ),
    );
  }

  @override
  Future<AtendimentoModel?> obterPorId(String id) async {
    final row = await (_db.select(_db.atendimentos)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _rowToModel(row);
  }

  @override
  Future<List<AtendimentoModel>> listarTodos() async {
    final rows = await (_db.select(_db.atendimentos)
          ..orderBy([(t) => OrderingTerm.desc(t.criadoEm)]))
        .get();
    return rows.map(_rowToModel).toList();
  }

  @override
  Future<List<AtendimentoModel>> listarPorStatus(String status) async {
    final rows = await (_db.select(_db.atendimentos)
          ..where((t) => t.status.equals(status))
          ..orderBy([(t) => OrderingTerm.desc(t.criadoEm)]))
        .get();
    return rows.map(_rowToModel).toList();
  }

  AtendimentoModel _rowToModel(db.Atendimento row) => AtendimentoModel(
        id: row.id,
        clienteId: row.clienteId,
        usuarioId: row.usuarioId,
        pontoDeSaidaJson: row.pontoDeSaidaJson,
        localDeColetaJson: row.localDeColetaJson,
        localDeEntregaJson: row.localDeEntregaJson,
        localDeRetornoJson: row.localDeRetornoJson,
        distanciaEstimadaKm: row.distanciaEstimadaKm,
        distanciaRealKm: row.distanciaRealKm,
        valorPorKm: row.valorPorKm,
        valorCobrado: row.valorCobrado,
        tipoValor: row.tipoValor,
        status: row.status,
        observacoes: row.observacoes,
        criadoEm: row.criadoEm.toIso8601String(),
        atualizadoEm: row.atualizadoEm.toIso8601String(),
        iniciadoEm: row.iniciadoEm?.toIso8601String(),
        chegadaColetaEm: row.chegadaColetaEm?.toIso8601String(),
        chegadaEntregaEm: row.chegadaEntregaEm?.toIso8601String(),
        inicioRetornoEm: row.inicioRetornoEm?.toIso8601String(),
        concluidoEm: row.concluidoEm?.toIso8601String(),
        sincronizadoEm: row.sincronizadoEm?.toIso8601String(),
      );
}
