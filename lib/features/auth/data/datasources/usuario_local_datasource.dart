import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/app_database.dart' show AppDatabase;
import '../models/usuario_model.dart';

abstract class UsuarioLocalDatasource {
  Future<void> inserir(UsuarioModel model);
  Future<void> atualizar(UsuarioModel model);
  Future<UsuarioModel?> obterPorId(String id);
}

class UsuarioLocalDatasourceImpl implements UsuarioLocalDatasource {
  UsuarioLocalDatasourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> inserir(UsuarioModel model) async {
    await _db.into(_db.usuarios).insert(
          db.UsuariosCompanion.insert(
            id: model.id,
            nome: model.nome,
            telefone: model.telefone,
            email: model.email,
            role: model.role,
            valorPorKmDefault: Value(model.valorPorKmDefault),
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
  Future<void> atualizar(UsuarioModel model) async {
    await (_db.update(_db.usuarios)..where((t) => t.id.equals(model.id))).write(
      db.UsuariosCompanion(
        nome: Value(model.nome),
        telefone: Value(model.telefone),
        email: Value(model.email),
        role: Value(model.role),
        valorPorKmDefault: Value(model.valorPorKmDefault),
        sincronizadoEm: Value(
          model.sincronizadoEm != null
              ? DateTime.parse(model.sincronizadoEm!)
              : null,
        ),
      ),
    );
  }

  @override
  Future<UsuarioModel?> obterPorId(String id) async {
    final row = await (_db.select(_db.usuarios)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return UsuarioModel(
      id: row.id,
      nome: row.nome,
      telefone: row.telefone,
      email: row.email,
      role: row.role,
      valorPorKmDefault: row.valorPorKmDefault,
      criadoEm: row.criadoEm.toIso8601String(),
      sincronizadoEm: row.sincronizadoEm?.toIso8601String(),
    );
  }
}
