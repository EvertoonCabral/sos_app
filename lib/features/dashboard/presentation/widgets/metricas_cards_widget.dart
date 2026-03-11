import 'package:flutter/material.dart';

import '../../domain/entities/resumo_periodo.dart';

/// Cards de métricas do dashboard (S7-05).
/// RN-038: km operacional, km cobrado, receita, atendimentos.
class MetricasCardsWidget extends StatelessWidget {
  const MetricasCardsWidget({super.key, required this.resumo});

  final ResumoPeriodo resumo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricaCard(
                key: const Key('cardKmOperacional'),
                titulo: 'KM Operacional',
                valor: '${resumo.kmOperacional.toStringAsFixed(1)} km',
                icone: Icons.route,
                cor: Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricaCard(
                key: const Key('cardKmCobrado'),
                titulo: 'KM Cobrado',
                valor: '${resumo.kmCobrado.toStringAsFixed(1)} km',
                icone: Icons.attach_money,
                cor: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetricaCard(
                key: const Key('cardReceita'),
                titulo: 'Receita',
                valor: 'R\$ ${resumo.receitaTotal.toStringAsFixed(2)}',
                icone: Icons.monetization_on,
                cor: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricaCard(
                key: const Key('cardAtendimentos'),
                titulo: 'Atendimentos',
                valor: resumo.totalAtendimentos.toString(),
                icone: Icons.local_shipping,
                cor: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetricaCard(
                key: const Key('cardConcluidos'),
                titulo: 'Concluídos',
                valor: resumo.totalConcluidos.toString(),
                icone: Icons.check_circle,
                cor: Colors.teal,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricaCard(
                key: const Key('cardEmAndamento'),
                titulo: 'Em Andamento',
                valor: resumo.totalEmAndamento.toString(),
                icone: Icons.pending,
                cor: Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricaCard extends StatelessWidget {
  const _MetricaCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.cor,
  });

  final String titulo;
  final String valor;
  final IconData icone;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: cor, size: 28),
            const SizedBox(height: 8),
            Text(
              titulo,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              valor,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
