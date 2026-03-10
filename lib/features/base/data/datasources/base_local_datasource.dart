import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/app_database.dart' show AppDatabase;
import '../models/base_model.dart';

/// Datasource local para Bases usando Drift.
abstract class BaseLocalDatasource {
  Future<void> inserir(BaseModel model);
  Future<void> atualizar(BaseModel model);
  Future<List<BaseModel>> listarTodas();
  Future<BaseModel?> obterPorId(String id);

  /// Remove flag isPrincipal de todas e define na base com [id].
  Future<void> definirPrincipal(String id);
}

class BaseLocalDatasourceImpl implements BaseLocalDatasource {
  BaseLocalDatasourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> inserir(BaseModel model) async {
    await _db.into(_db.bases).insert(
          db.BasesCompanion.insert(
            id: model.id,
            nome: model.nome,
            localJson: model.localJson,
            isPrincipal: Value(model.isPrincipal),
            criadoEm: DateTime.parse(model.criadoEm),
            sincronizadoEm: Value(
              model.sincronizadoEm != null
                  ? DateTime.parse(model.sincronizadoEm!)
                  : null,
            ),
          ),
        );
  }

  @override
  Future<void> atualizar(BaseModel model) async {
    await (_db.update(_db.bases)..where((t) => t.id.equals(model.id))).write(
      db.BasesCompanion(
        nome: Value(model.nome),
        localJson: Value(model.localJson),
        isPrincipal: Value(model.isPrincipal),
        sincronizadoEm: Value(
          model.sincronizadoEm != null
              ? DateTime.parse(model.sincronizadoEm!)
              : null,
        ),
      ),
    );
  }

  @override
  Future<List<BaseModel>> listarTodas() async {
    final rows = await (_db.select(_db.bases)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .get();
    return rows.map(_rowToModel).toList();
  }

  @override
  Future<BaseModel?> obterPorId(String id) async {
    final row = await (_db.select(_db.bases)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _rowToModel(row);
  }

  @override
  Future<void> definirPrincipal(String id) async {
    await _db.transaction(() async {
      // Remove principal de todas
      await (_db.update(_db.bases)).write(
        const db.BasesCompanion(isPrincipal: Value(false)),
      );
      // Define a selecionada como principal
      await (_db.update(_db.bases)..where((t) => t.id.equals(id))).write(
        const db.BasesCompanion(isPrincipal: Value(true)),
      );
    });
  }

  BaseModel _rowToModel(db.Base row) => BaseModel(
        id: row.id,
        nome: row.nome,
        localJson: row.localJson,
        isPrincipal: row.isPrincipal,
        criadoEm: row.criadoEm.toIso8601String(),
        sincronizadoEm: row.sincronizadoEm?.toIso8601String(),
      );
}
