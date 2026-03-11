import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

/// Helper para adicionar e gerenciar operações na fila de sincronização.
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

  /// Retorna itens pendentes (tentativas < maxRetries e prontos para retry).
  Future<List<SyncQueueEntry>> obterPendentes({
    required int maxRetries,
  }) async {
    final now = DateTime.now();
    return (_db.select(_db.syncQueueTable)
          ..where((t) => t.tentativas.isSmallerThanValue(maxRetries))
          ..where((t) =>
              t.proximaTentativaEm.isNull() |
              t.proximaTentativaEm.isSmallerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.criadoEm)]))
        .get();
  }

  /// Remove um item da fila (sincronizado com sucesso).
  Future<void> remover(String id) async {
    await (_db.delete(_db.syncQueueTable)..where((t) => t.id.equals(id))).go();
  }

  /// Incrementa tentativas e calcula próxima tentativa com backoff.
  Future<void> incrementarTentativas(
    String id, {
    required Duration backoff,
  }) async {
    final entry = await (_db.select(_db.syncQueueTable)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    final novasTentativas = entry.tentativas + 1;
    await (_db.update(_db.syncQueueTable)..where((t) => t.id.equals(id))).write(
      SyncQueueTableCompanion(
        tentativas: Value(novasTentativas),
        proximaTentativaEm: Value(DateTime.now().add(backoff)),
      ),
    );
  }

  /// Conta itens na fila por status.
  Future<int> contarPendentes() async {
    final count = _db.syncQueueTable.id.count();
    final query = _db.selectOnly(_db.syncQueueTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Conta itens com tentativas esgotadas.
  Future<int> contarComErro({required int maxRetries}) async {
    final count = _db.syncQueueTable.id.count();
    final query = _db.selectOnly(_db.syncQueueTable)
      ..addColumns([count])
      ..where(_db.syncQueueTable.tentativas.isBiggerOrEqualValue(maxRetries));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
