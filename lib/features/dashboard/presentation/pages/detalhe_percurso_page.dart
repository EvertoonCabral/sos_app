import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../atendimento/domain/entities/atendimento.dart';
import '../../../rastreamento/domain/usecases/obter_percurso.dart';
import '../../../rastreamento/domain/entities/ponto_rastreamento.dart';
import '../../../rastreamento/presentation/widgets/mapa_percurso_widget.dart';

/// Tela de detalhe do percurso com mapa (S7-09).
/// RN-039: visualizar percurso de um atendimento passado no mapa.
class DetalhePercursoPage extends StatefulWidget {
  const DetalhePercursoPage({
    super.key,
    required this.atendimento,
  });

  final Atendimento atendimento;

  @override
  State<DetalhePercursoPage> createState() => _DetalhePercursoPageState();
}

class _DetalhePercursoPageState extends State<DetalhePercursoPage> {
  late Future<List<PontoRastreamento>> _percursoFuture;

  @override
  void initState() {
    super.initState();
    _percursoFuture = GetIt.I<ObterPercurso>().call(widget.atendimento.id);
  }

  @override
  Widget build(BuildContext context) {
    final atendimento = widget.atendimento;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do Percurso'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Informações do atendimento
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atendimento',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Saída',
                    valor: atendimento.pontoDeSaida.enderecoTexto,
                  ),
                  _InfoRow(
                    label: 'Coleta',
                    valor: atendimento.localDeColeta.enderecoTexto,
                  ),
                  _InfoRow(
                    label: 'Entrega',
                    valor: atendimento.localDeEntrega.enderecoTexto,
                  ),
                  _InfoRow(
                    label: 'Retorno',
                    valor: atendimento.localDeRetorno.enderecoTexto,
                  ),
                  const Divider(),
                  _InfoRow(
                    label: 'Distância estimada',
                    valor:
                        '${atendimento.distanciaEstimadaKm.toStringAsFixed(1)} km',
                  ),
                  if (atendimento.distanciaRealKm != null)
                    _InfoRow(
                      label: 'Distância real',
                      valor:
                          '${atendimento.distanciaRealKm!.toStringAsFixed(1)} km',
                    ),
                  if (atendimento.valorCobrado != null)
                    _InfoRow(
                      label: 'Valor cobrado',
                      valor:
                          'R\$ ${atendimento.valorCobrado!.toStringAsFixed(2)}',
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Mapa do percurso
          Text(
            'Percurso no Mapa',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<PontoRastreamento>>(
            future: _percursoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Text('Erro ao carregar percurso: ${snapshot.error}'),
                  ),
                );
              }

              final pontos = snapshot.data ?? [];
              return MapaPercursoWidget(
                pontos: pontos,
                height: 400,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.valor});

  final String label;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
