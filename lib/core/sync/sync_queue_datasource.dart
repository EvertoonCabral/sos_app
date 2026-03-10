import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

/// Helper para adicionar operações à fila de sincronização.
class SyncQueueDatasource {
  SyncQueueDatasource(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Adiciona uma operação à fila de sincronização.
  Future<void> adicionar({
    required String entidade,
    required String operacao,
    required Map<String, dynamic> payload,
  }) async {
    await _db.into(_db.syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: _uuid.v4(),
            entidade: entidade,
            operacao: operacao,
            payload: jsonEncode(payload),
            criadoEm: DateTime.now(),
          ),
        );
  }
}
