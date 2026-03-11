import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/sync/sync_manager.dart';
import 'package:sos_app/core/widgets/sync_status_widget.dart';

class MockSyncManager extends Mock implements SyncManager {}

void main() {
  late MockSyncManager mockSyncManager;
  late StreamController<SyncStatus> statusController;

  setUp(() {
    mockSyncManager = MockSyncManager();
    statusController = StreamController<SyncStatus>.broadcast();
    when(() => mockSyncManager.statusStream)
        .thenAnswer((_) => statusController.stream);
    when(() => mockSyncManager.processar()).thenAnswer((_) async => 0);
  });

  tearDown(() => statusController.close());

  Widget buildWidget() => MaterialApp(
        home: Scaffold(
          body: SyncStatusWidget(syncManager: mockSyncManager),
        ),
      );

  group('SyncStatusWidget', () {
    testWidgets('exibe ícone verde para sincronizado', (tester) async {
      await tester.pumpWidget(buildWidget());
      statusController.add(SyncStatus.sincronizado);
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.cloud_done);
      expect(icon.color, Colors.green);
    });

    testWidgets('exibe ícone laranja para pendente', (tester) async {
      await tester.pumpWidget(buildWidget());
      statusController.add(SyncStatus.pendente);
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.cloud_upload);
      expect(icon.color, Colors.orange);
    });

    testWidgets('exibe ícone vermelho para erro', (tester) async {
      await tester.pumpWidget(buildWidget());
      statusController.add(SyncStatus.erro);
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.cloud_off);
      expect(icon.color, Colors.red);
    });

    testWidgets('exibe ícone azul para sincronizando', (tester) async {
      await tester.pumpWidget(buildWidget());
      statusController.add(SyncStatus.sincronizando);
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.sync);
      expect(icon.color, Colors.blue);
    });

    testWidgets('tap no ícone dispara processar', (tester) async {
      await tester.pumpWidget(buildWidget());
      statusController.add(SyncStatus.pendente);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      verify(() => mockSyncManager.processar()).called(1);
    });

    testWidgets('exibe cloud_done como padrão antes de receber stream',
        (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.cloud_done);
    });
  });
}
