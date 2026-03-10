import 'package:drift/drift.dart';

import '../entities/local_geo.dart';
import '../database/app_database.dart';

/// Cache local de resultados de geocoding usando Drift.
class GeocodingCacheDatasource {
  GeocodingCacheDatasource(this._db);

  final AppDatabase _db;

  /// Salva um resultado de geocoding no cache.
  Future<void> salvar(LocalGeo local) async {
    await _db.into(_db.geocodingCache).insertOnConflictUpdate(
          GeocodingCacheCompanion.insert(
            enderecoTexto: local.enderecoTexto,
            latitude: local.latitude,
            longitude: local.longitude,
            criadoEm: DateTime.now(),
          ),
        );
  }

  /// Busca endereços no cache que correspondem ao [query] (LIKE).
  Future<List<LocalGeo>> buscar(String query) async {
    final pattern = '%$query%';
    final rows = await (_db.select(_db.geocodingCache)
          ..where((t) => t.enderecoTexto.like(pattern))
          ..orderBy([(t) => OrderingTerm.desc(t.criadoEm)])
          ..limit(10))
        .get();
    return rows
        .map((r) => LocalGeo(
              enderecoTexto: r.enderecoTexto,
              latitude: r.latitude,
              longitude: r.longitude,
            ))
        .toList();
  }

  /// Busca exata por endereço texto.
  Future<LocalGeo?> obterPorEndereco(String enderecoTexto) async {
    final row = await (_db.select(_db.geocodingCache)
          ..where((t) => t.enderecoTexto.equals(enderecoTexto)))
        .getSingleOrNull();
    if (row == null) return null;
    return LocalGeo(
      enderecoTexto: row.enderecoTexto,
      latitude: row.latitude,
      longitude: row.longitude,
    );
  }
}
