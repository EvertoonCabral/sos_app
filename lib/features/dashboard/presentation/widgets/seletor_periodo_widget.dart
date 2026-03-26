import 'package:flutter/material.dart';

/// Seletor de período para o dashboard (S7-06).
/// Opções: Hoje, Semana, Mês, Personalizado.
enum PeriodoTipo { hoje, semana, mes, personalizado }

class SeletorPeriodoWidget extends StatefulWidget {
  const SeletorPeriodoWidget({
    super.key,
    required this.onPeriodoSelecionado,
    this.periodoInicial = PeriodoTipo.mes,
  });

  final void Function(PeriodoTipo tipo, DateTime inicio, DateTime fim)
      onPeriodoSelecionado;
  final PeriodoTipo periodoInicial;

  @override
  State<SeletorPeriodoWidget> createState() => _SeletorPeriodoWidgetState();
}

class _SeletorPeriodoWidgetState extends State<SeletorPeriodoWidget> {
  late PeriodoTipo _selecionado;

  @override
  void initState() {
    super.initState();
    _selecionado = widget.periodoInicial;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PeriodoTipo>(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.primary;
          }
          return Colors.white;
        }),
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.primary;
          }
          return Colors.white;
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: Colors.white54),
        ),
      ),
      segments: const [
        ButtonSegment(
          value: PeriodoTipo.hoje,
          label: Text('Hoje'),
          icon: Icon(Icons.today),
        ),
        ButtonSegment(
          value: PeriodoTipo.semana,
          label: Text('Semana'),
          icon: Icon(Icons.date_range),
        ),
        ButtonSegment(
          value: PeriodoTipo.mes,
          label: Text('Mês'),
          icon: Icon(Icons.calendar_month),
        ),
        ButtonSegment(
          value: PeriodoTipo.personalizado,
          label: Text('Custom'),
          icon: Icon(Icons.edit_calendar),
        ),
      ],
      selected: {_selecionado},
      onSelectionChanged: (selected) async {
        final tipo = selected.first;
        setState(() => _selecionado = tipo);

        if (tipo == PeriodoTipo.personalizado) {
          await _selecionarPeriodoCustom(context);
        } else {
          final (inicio, fim) = _calcularPeriodo(tipo);
          widget.onPeriodoSelecionado(tipo, inicio, fim);
        }
      },
    );
  }

  (DateTime, DateTime) _calcularPeriodo(PeriodoTipo tipo) {
    final agora = DateTime.now();
    switch (tipo) {
      case PeriodoTipo.hoje:
        final inicio = DateTime(agora.year, agora.month, agora.day);
        final fim = inicio.add(const Duration(days: 1)).subtract(
              const Duration(milliseconds: 1),
            );
        return (inicio, fim);
      case PeriodoTipo.semana:
        final inicio = DateTime(agora.year, agora.month, agora.day)
            .subtract(Duration(days: agora.weekday - 1));
        final fim = inicio
            .add(const Duration(days: 7))
            .subtract(const Duration(milliseconds: 1));
        return (inicio, fim);
      case PeriodoTipo.mes:
        final inicio = DateTime(agora.year, agora.month);
        final fim = DateTime(agora.year, agora.month + 1)
            .subtract(const Duration(milliseconds: 1));
        return (inicio, fim);
      case PeriodoTipo.personalizado:
        // Handled by date picker
        return (agora, agora);
    }
  }

  Future<void> _selecionarPeriodoCustom(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (range != null && mounted) {
      final inicio = DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
      );
      final fim = DateTime(
        range.end.year,
        range.end.month,
        range.end.day,
        23,
        59,
        59,
        999,
      );
      widget.onPeriodoSelecionado(PeriodoTipo.personalizado, inicio, fim);
    }
  }
}
