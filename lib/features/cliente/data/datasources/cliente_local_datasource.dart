import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/app_database.dart' show AppDatabase;
import '../models/cliente_model.dart';

/// Datasource local para Clientes usando Drift.
abstract class ClienteLocalDatasource {
  Future<void> inserir(ClienteModel model);
  Future<void> atualizar(ClienteModel model);
  Future<ClienteModel?> obterPorId(String id);
  Future<List<ClienteModel>> buscar(String query);
  Future<List<ClienteModel>> listarTodos();
}

class ClienteLocalDatasourceImpl implements ClienteLocalDatasource {
  ClienteLocalDatasourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> inserir(ClienteModel model) async {
    await _db.into(_db.clientes).insert(
          db.ClientesCompanion.insert(
            id: model.id,
            nome: model.nome,
            telefone: model.telefone,
            documento: Value(model.documento),
            enderecoDefaultJson: Value(model.enderecoDefaultJson),
            criadoEm: DateTime.parse(model.criadoEm),
            atualizadoEm: DateTime.parse(model.atualizadoEm),
            sincronizadoEm: Value(
              model.sincronizadoEm != null
                  ? DateTime.parse(model.sincronizadoEm!)
                  : null,
            ),
          ),
        );
  }

  @override
  Future<void> atualizar(ClienteModel model) async {
    await (_db.update(_db.clientes)..where((t) => t.id.equals(model.id))).write(
      db.ClientesCompanion(
        nome: Value(model.nome),
        telefone: Value(model.telefone),
        documento: Value(model.documento),
        enderecoDefaultJson: Value(model.enderecoDefaultJson),
        atualizadoEm: Value(DateTime.parse(model.atualizadoEm)),
        sincronizadoEm: Value(
          model.sincronizadoEm != null
              ? DateTime.parse(model.sincronizadoEm!)
              : null,
        ),
      ),
    );
  }

  @override
  Future<ClienteModel?> obterPorId(String id) async {
    final row = await (_db.select(_db.clientes)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _rowToModel(row);
  }

  @override
  Future<List<ClienteModel>> buscar(String query) async {
    final pattern = '%$query%';
    final rows = await (_db.select(_db.clientes)
          ..where(
            (t) => t.nome.like(pattern) | t.telefone.like(pattern),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .get();
    return rows.map(_rowToModel).toList();
  }

  @override
  Future<List<ClienteModel>> listarTodos() async {
    final rows = await (_db.select(_db.clientes)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .get();
    return rows.map(_rowToModel).toList();
  }

  ClienteModel _rowToModel(db.Cliente row) => ClienteModel(
        id: row.id,
        nome: row.nome,
        telefone: row.telefone,
        documento: row.documento,
        enderecoDefaultJson: row.enderecoDefaultJson,
        criadoEm: row.criadoEm.toIso8601String(),
        atualizadoEm: row.atualizadoEm.toIso8601String(),
        sincronizadoEm: row.sincronizadoEm?.toIso8601String(),
      );
}
