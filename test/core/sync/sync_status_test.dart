import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/sync/sync_manager.dart';

void main() {
  group('SyncStatus', () {
    test('valores do enum', () {
      expect(SyncStatus.values, hasLength(4));
      expect(SyncStatus.values, contains(SyncStatus.sincronizado));
      expect(SyncStatus.values, contains(SyncStatus.pendente));
      expect(SyncStatus.values, contains(SyncStatus.erro));
      expect(SyncStatus.values, contains(SyncStatus.sincronizando));
    });
  });
}
