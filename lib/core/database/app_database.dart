import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// --------------------------------------------------------------------------
// Tabela: clientes
// --------------------------------------------------------------------------
class Clientes extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get telefone => text()();
  TextColumn get documento => text().nullable()();
  TextColumn get enderecoDefaultJson => text().nullable()();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// --------------------------------------------------------------------------
// Tabela: usuarios
// --------------------------------------------------------------------------
class Usuarios extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get telefone => text()();
  TextColumn get email => text()();
  TextColumn get role => text()(); // 'operador' | 'administrador'
  RealColumn get valorPorKmDefault => real().withDefault(const Constant(5.0))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// --------------------------------------------------------------------------
// Tabela: bases
// --------------------------------------------------------------------------
class Bases extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get localJson => text()();
  BoolColumn get isPrincipal => boolean().withDefault(const Constant(false))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// --------------------------------------------------------------------------
// Tabela: atendimentos
// --------------------------------------------------------------------------
@TableIndex(name: 'idx_atendimentos_status', columns: {#status})
@TableIndex(name: 'idx_atendimentos_cliente', columns: {#clienteId})
@TableIndex(name: 'idx_atendimentos_criado', columns: {#criadoEm})
class Atendimentos extends Table {
  TextColumn get id => text()();
  TextColumn get clienteId => text().references(Clientes, #id)();
  TextColumn get usuarioId => text().references(Usuarios, #id)();

  // 4 pontos obrigatórios (RN-007) — JSON serializado de LocalGeo
  TextColumn get pontoDeSaidaJson => text()();
  TextColumn get localDeColetaJson => text()();
  TextColumn get localDeEntregaJson => text()();
  TextColumn get localDeRetornoJson => text()();

  // Distâncias e valores
  RealColumn get valorPorKm => real()();
  // RN-010: saída→coleta + coleta→entrega + entrega→retorno
  RealColumn get distanciaEstimadaKm => real()();
  RealColumn get distanciaRealKm => real().nullable()();
  RealColumn get valorCobrado => real().nullable()();
  TextColumn get tipoValor => text()(); // 'fixo' | 'porKm'

  // Status e controle
  TextColumn get status => text()(); // AtendimentoStatus
  TextColumn get observacoes => text().nullable()();

  // Timestamps por etapa
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get atualizadoEm => dateTime()();
  DateTimeColumn get iniciadoEm => dateTime().nullable()(); // → emDeslocamento
  DateTimeColumn get chegadaColetaEm => dateTime().nullable()(); // → emColeta
  DateTimeColumn get chegadaEntregaEm => dateTime().nullable()(); // → emEntrega
  DateTimeColumn get inicioRetornoEm => dateTime().nullable()(); // → retornando
  DateTimeColumn get concluidoEm => dateTime().nullable()(); // → concluido
  DateTimeColumn get sincronizadoEm => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// --------------------------------------------------------------------------
// Tabela: pontos_rastreamento
// --------------------------------------------------------------------------
@TableIndex(name: 'idx_pontos_atendimento', columns: {#atendimentoId})
@TableIndex(name: 'idx_pontos_synced', columns: {#synced})
class PontosRastreamento extends Table {
  TextColumn get id => text()();
  TextColumn get atendimentoId => text().references(Atendimentos, #id)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracy => real()();
  RealColumn get velocidade => real().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// --------------------------------------------------------------------------
// Tabela: sync_queue
// --------------------------------------------------------------------------
@DataClassName('SyncQueueEntry')
@TableIndex(name: 'idx_sync_proxima_tentativa', columns: {#proximaTentativaEm})
class SyncQueueTable extends Table {
  TextColumn get id => text()();
  TextColumn get entidade => text()();
  TextColumn get operacao => text()(); // 'create' | 'update' | 'delete'
  TextColumn get payload => text()();
  IntColumn get tentativas => integer().withDefault(const Constant(0))();
  DateTimeColumn get criadoEm => dateTime()();
  DateTimeColumn get proximaTentativaEm => dateTime().nullable()();

  @override
  String get tableName => 'sync_queue';

  @override
  Set<Column> get primaryKey => {id};
}

// --------------------------------------------------------------------------
// Tabela: geocoding_cache
// --------------------------------------------------------------------------
class GeocodingCache extends Table {
  TextColumn get enderecoTexto => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {enderecoTexto};
}

// --------------------------------------------------------------------------
// Database
// --------------------------------------------------------------------------
@DriftDatabase(tables: [
  Clientes,
  Usuarios,
  Bases,
  Atendimentos,
  PontosRastreamento,
  SyncQueueTable,
  GeocodingCache,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          // v1 → v2: adicionar índices de performance
          if (from < 2) {
            await migrator.createIndex(
              Index('idx_atendimentos_status',
                  'CREATE INDEX idx_atendimentos_status ON atendimentos (status)'),
            );
            await migrator.createIndex(
              Index('idx_atendimentos_cliente',
                  'CREATE INDEX idx_atendimentos_cliente ON atendimentos (cliente_id)'),
            );
            await migrator.createIndex(
              Index('idx_atendimentos_criado',
                  'CREATE INDEX idx_atendimentos_criado ON atendimentos (criado_em)'),
            );
            await migrator.createIndex(
              Index('idx_pontos_atendimento',
                  'CREATE INDEX idx_pontos_atendimento ON pontos_rastreamento (atendimento_id)'),
            );
            await migrator.createIndex(
              Index('idx_pontos_synced',
                  'CREATE INDEX idx_pontos_synced ON pontos_rastreamento (synced)'),
            );
            await migrator.createIndex(
              Index('idx_sync_proxima_tentativa',
                  'CREATE INDEX idx_sync_proxima_tentativa ON sync_queue (proxima_tentativa_em)'),
            );
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'guincho_app_db');
  }
}
