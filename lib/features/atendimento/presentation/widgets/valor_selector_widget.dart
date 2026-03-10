import 'package:flutter/material.dart';

import '../../domain/entities/atendimento_enums.dart';

/// Widget para selecionar o tipo de valor: fixo ou por km.
class ValorSelectorWidget extends StatelessWidget {
  const ValorSelectorWidget({
    super.key,
    required this.tipoValor,
    required this.valorPorKm,
    this.valorFixo,
    required this.onTipoValorChanged,
    required this.onValorFixoChanged,
  });

  final TipoValor tipoValor;
  final double valorPorKm;
  final double? valorFixo;
  final ValueChanged<TipoValor> onTipoValorChanged;
  final ValueChanged<double?> onValorFixoChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo de Valor', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<TipoValor>(
          key: const Key('tipoValorSegmented'),
          segments: const [
            ButtonSegment(
              value: TipoValor.porKm,
              label: Text('Por KM'),
              icon: Icon(Icons.speed),
            ),
            ButtonSegment(
              value: TipoValor.fixo,
              label: Text('Fixo'),
              icon: Icon(Icons.attach_money),
            ),
          ],
          selected: {tipoValor},
          onSelectionChanged: (s) => onTipoValorChanged(s.first),
        ),
        const SizedBox(height: 12),
        if (tipoValor == TipoValor.porKm)
          Text(
            'Valor por KM: R\$ ${valorPorKm.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (tipoValor == TipoValor.fixo)
          TextField(
            key: const Key('valorFixoField'),
            decoration: const InputDecoration(
              labelText: 'Valor fixo (R\$)',
              border: OutlineInputBorder(),
              prefixText: 'R\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: TextEditingController(
              text: valorFixo?.toStringAsFixed(2) ?? '',
            ),
            onChanged: (v) {
              final parsed = double.tryParse(v.replaceAll(',', '.'));
              onValorFixoChanged(parsed);
            },
          ),
      ],
    );
  }
}
