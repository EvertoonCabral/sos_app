import 'package:flutter/material.dart';

import '../../domain/entities/resumo_cliente.dart';

/// Ranking de clientes por KM e atendimentos (S7-08).
/// RN-038: Ranking de clientes por número de atendimentos e por KM gerado.
class RankingClientesWidget extends StatelessWidget {
  const RankingClientesWidget({
    super.key,
    required this.ranking,
  });

  final List<ResumoCliente> ranking;

  @override
  Widget build(BuildContext context) {
    if (ranking.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('Nenhum atendimento concluído no período'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ranking de Clientes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...ranking.asMap().entries.map((entry) {
              final index = entry.key;
              final cliente = entry.value;
              return _RankingItem(
                posicao: index + 1,
                cliente: cliente,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _RankingItem extends StatelessWidget {
  const _RankingItem({
    required this.posicao,
    required this.cliente,
  });

  final int posicao;
  final ResumoCliente cliente;

  @override
  Widget build(BuildContext context) {
    final medal = posicao <= 3 ? _medalIcon(posicao) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: medal ??
                Text(
                  '$posicao°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.clienteNome,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${cliente.totalAtendimentos} atendimentos • ${cliente.totalKm.toStringAsFixed(1)} km',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            'R\$ ${cliente.totalReceita.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _medalIcon(int pos) {
    final colors = {1: Colors.amber, 2: Colors.grey, 3: Colors.brown};
    return Icon(Icons.emoji_events, color: colors[pos], size: 24);
  }
}
