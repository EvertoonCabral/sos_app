import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/sync/sync_manager.dart';

/// Tela para gerenciar a sincronização manualmente.
class SincronizacaoPage extends StatefulWidget {
  const SincronizacaoPage({super.key});

  @override
  State<SincronizacaoPage> createState() => _SincronizacaoPageState();
}

class _SincronizacaoPageState extends State<SincronizacaoPage> {
  final SyncManager _syncManager = GetIt.I<SyncManager>();
  Map<String, dynamic>? _resumo;
  bool _sincronizando = false;
  String? _mensagem;

  @override
  void initState() {
    super.initState();
    _carregarResumo();
  }

  Future<void> _carregarResumo() async {
    final resumo = await _syncManager.obterResumo();
    if (mounted) setState(() => _resumo = resumo);
  }

  Future<void> _sincronizarAgora() async {
    setState(() {
      _sincronizando = true;
      _mensagem = null;
    });

    try {
      final sincronizados = await _syncManager.processar();
      if (mounted) {
        setState(() {
          _mensagem = sincronizados > 0
              ? '$sincronizados item(ns) sincronizado(s) com sucesso!'
              : 'Nenhum item pendente para sincronizar.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _mensagem = 'Erro ao sincronizar: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _sincronizando = false);
        await _carregarResumo();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronização'),
      ),
      body: RefreshIndicator(
        onRefresh: _carregarResumo,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status geral
            _buildStatusCard(theme),
            const SizedBox(height: 16),

            // Detalhes da fila
            if (_resumo != null) _buildFilaCard(theme),
            const SizedBox(height: 16),

            // Último pull
            if (_resumo != null) _buildPullCard(theme),
            const SizedBox(height: 24),

            // Botão sincronizar
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                key: const Key('sincronizarManualButton'),
                onPressed: _sincronizando ? null : _sincronizarAgora,
                icon: _sincronizando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.sync),
                label: Text(
                    _sincronizando ? 'Sincronizando...' : 'Sincronizar Agora'),
              ),
            ),

            // Mensagem de feedback
            if (_mensagem != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _mensagem!.contains('Erro')
                    ? theme.colorScheme.errorContainer
                    : theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        _mensagem!.contains('Erro')
                            ? Icons.error_outline
                            : Icons.check_circle_outline,
                        color: _mensagem!.contains('Erro')
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _mensagem!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Explicação
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Como funciona',
                            style: theme.textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Dados são salvos localmente primeiro (offline-first)\n'
                      '• Quando há internet, o envio é feito automaticamente\n'
                      '• Se perder conexão, os dados ficam na fila\n'
                      '• Ao reconectar, a sincronização é retomada\n'
                      '• Use o botão acima para forçar a sincronização',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    final total = _resumo?['total'] as int? ?? 0;
    final pendentes = _resumo?['pendentes'] as int? ?? 0;
    final comErro = _resumo?['comErro'] as int? ?? 0;

    final (icon, color, label) = total == 0
        ? (Icons.cloud_done, Colors.green, 'Tudo sincronizado')
        : comErro > 0
            ? (Icons.cloud_off, Colors.red, '$comErro item(ns) com erro')
            : (Icons.cloud_upload, Colors.orange,
                '$pendentes item(ns) pendente(s)');

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(label, style: theme.textTheme.titleMedium),
        subtitle: Text('$total item(ns) na fila de sincronização'),
      ),
    );
  }

  Widget _buildFilaCard(ThemeData theme) {
    final porEntidade =
        _resumo!['porEntidade'] as Map<String, int>? ?? {};

    if (porEntidade.isEmpty) {
      return const SizedBox.shrink();
    }

    final nomes = {
      'cliente': 'Clientes',
      'atendimento': 'Atendimentos',
      'base': 'Bases',
      'ponto_rastreamento': 'Rastreamento GPS',
    };

    final icones = {
      'cliente': Icons.people,
      'atendimento': Icons.local_shipping,
      'base': Icons.warehouse,
      'ponto_rastreamento': Icons.gps_fixed,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fila por tipo', style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            ...porEntidade.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        icones[e.key] ?? Icons.data_object,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(nomes[e.key] ?? e.key)),
                      Text(
                        '${e.value}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPullCard(ThemeData theme) {
    final ultimoPull = _resumo!['ultimoPull'] as DateTime?;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Icon(Icons.cloud_download,
              color: theme.colorScheme.secondary),
        ),
        title: const Text('Último download do servidor'),
        subtitle: Text(
          ultimoPull != null
              ? _formatarData(ultimoPull.toLocal())
              : 'Nunca sincronizado',
        ),
      ),
    );
  }

  String _formatarData(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} às '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
