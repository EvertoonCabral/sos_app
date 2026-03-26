import 'package:flutter/material.dart';

import '../../domain/entities/atendimento_enums.dart';

/// Widget para selecionar o tipo de valor: fixo ou por km.
class ValorSelectorWidget extends StatefulWidget {
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
  State<ValorSelectorWidget> createState() => _ValorSelectorWidgetState();
}

class _ValorSelectorWidgetState extends State<ValorSelectorWidget> {
  late final TextEditingController _fixoController;

  @override
  void initState() {
    super.initState();
    _fixoController = TextEditingController(
      text: widget.valorFixo != null
          ? widget.valorFixo!.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant ValorSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller only when switching back to fixo with an external value
    // and the field is currently empty (avoids overwriting user typing).
    if (widget.tipoValor == TipoValor.fixo &&
        oldWidget.tipoValor != TipoValor.fixo) {
      _fixoController.text = widget.valorFixo != null
          ? widget.valorFixo!.toStringAsFixed(2)
          : '';
    }
  }

  @override
  void dispose() {
    _fixoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo de Valor',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                )),
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
          selected: {widget.tipoValor},
          onSelectionChanged: (s) => widget.onTipoValorChanged(s.first),
        ),
        const SizedBox(height: 12),
        if (widget.tipoValor == TipoValor.porKm)
          Text(
            'Valor por KM: R\$ ${widget.valorPorKm.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (widget.tipoValor == TipoValor.fixo)
          TextField(
            key: const Key('valorFixoField'),
            decoration: const InputDecoration(
              labelText: 'Valor fixo (R\$)',
              prefixText: 'R\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _fixoController,
            onChanged: (v) {
              final parsed = double.tryParse(v.replaceAll(',', '.'));
              widget.onValorFixoChanged(parsed);
            },
          ),
      ],
    );
  }
}
