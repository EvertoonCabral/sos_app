import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SyncCursorDatasource {
  SyncCursorDatasource(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _pullCursorKey = 'sync_pull_cursor';

  Future<DateTime?> obterUltimoPull() async {
    final value = await _secureStorage.read(key: _pullCursorKey);
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  Future<void> salvarUltimoPull(DateTime timestamp) async {
    await _secureStorage.write(
      key: _pullCursorKey,
      value: timestamp.toUtc().toIso8601String(),
    );
  }
}
