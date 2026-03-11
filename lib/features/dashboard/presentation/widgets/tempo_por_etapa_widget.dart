import 'package:flutter/material.dart';

import '../../domain/entities/tempo_por_etapa.dart';

/// Widget que mostra o tempo médio por etapa do atendimento (S7-03).
class TempoPorEtapaWidget extends StatelessWidget {
  const TempoPorEtapaWidget({super.key, required this.tempoPorEtapa});

  final TempoPorEtapa tempoPorEtapa;

  @override
  Widget build(BuildContext context) {
    if (tempoPorEtapa.totalAnalisados == 0) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('Nenhum atendimento completo para análise de tempo'),
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
              'Tempo Médio por Etapa',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${tempoPorEtapa.totalAnalisados} atendimentos analisados',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _EtapaRow(
              label: 'Até Coleta',
              icone: Icons.directions_car,
              cor: Colors.blue,
              minutos: tempoPorEtapa.mediaMinutosAteColeta,
            ),
            _EtapaRow(
              label: 'Coleta → Entrega',
              icone: Icons.local_shipping,
              cor: Colors.orange,
              minutos: tempoPorEtapa.mediaMinutosColetaEntrega,
            ),
            _EtapaRow(
              label: 'Entrega → Retorno',
              icone: Icons.swap_horiz,
              cor: Colors.purple,
              minutos: tempoPorEtapa.mediaMinutosEntregaRetorno,
            ),
            _EtapaRow(
              label: 'Retorno à Base',
              icone: Icons.home,
              cor: Colors.teal,
              minutos: tempoPorEtapa.mediaMinutosRetornoBase,
            ),
          ],
        ),
      ),
    );
  }
}

class _EtapaRow extends StatelessWidget {
  const _EtapaRow({
    required this.label,
    required this.icone,
    required this.cor,
    required this.minutos,
  });

  final String label;
  final IconData icone;
  final Color cor;
  final double minutos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, color: cor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            _formatarMinutos(minutos),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _formatarMinutos(double min) {
    if (min < 1) return '${(min * 60).round()} seg';
    if (min < 60) return '${min.round()} min';
    final horas = (min / 60).floor();
    final restante = (min % 60).round();
    return '${horas}h ${restante}min';
  }
}
