import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Gráfico de barras simples para atendimentos concluídos por dia (S7-07).
/// Usa widgets nativos do Flutter (sem lib externa de charts).
class GraficoAtendimentosWidget extends StatelessWidget {
  const GraficoAtendimentosWidget({
    super.key,
    required this.atendimentosPorDia,
  });

  final Map<DateTime, int> atendimentosPorDia;

  @override
  Widget build(BuildContext context) {
    if (atendimentosPorDia.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('Nenhum atendimento concluído no período'),
        ),
      );
    }

    final sortedEntries = atendimentosPorDia.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final maxValor =
        sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atendimentos por Dia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: sortedEntries.map((entry) {
                  final proporcao = maxValor > 0 ? entry.value / maxValor : 0.0;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            entry.value.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 140 * proporcao,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM').format(entry.key),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
