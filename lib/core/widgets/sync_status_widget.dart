import 'package:flutter/material.dart';

import '../../core/sync/sync_manager.dart';

/// RN-037: Indicador visual do estado de sincronização.
/// 🟢 Sincronizado — 🟡 Pendente — 🔴 Erro — 🔄 Sincronizando
class SyncStatusWidget extends StatelessWidget {
  const SyncStatusWidget({
    super.key,
    required this.syncManager,
  });

  final SyncManager syncManager;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncStatus>(
      stream: syncManager.statusStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? SyncStatus.sincronizado;
        return _buildIndicator(context, status);
      },
    );
  }

  Widget _buildIndicator(BuildContext context, SyncStatus status) {
    final (icon, color, tooltip) = switch (status) {
      SyncStatus.sincronizado => (
          Icons.cloud_done,
          Colors.green,
          'Sincronizado',
        ),
      SyncStatus.pendente => (
          Icons.cloud_upload,
          Colors.orange,
          'Pendente de sincronização',
        ),
      SyncStatus.erro => (
          Icons.cloud_off,
          Colors.red,
          'Erro na sincronização',
        ),
      SyncStatus.sincronizando => (
          Icons.sync,
          Colors.blue,
          'Sincronizando...',
        ),
    };

    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: status == SyncStatus.sincronizando
            ? null
            : () => syncManager.processar(),
      ),
    );
  }
}
