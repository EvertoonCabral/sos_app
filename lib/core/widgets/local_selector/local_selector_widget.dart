import 'package:flutter/material.dart';

import '../../entities/local_geo.dart';
import '../../geo/geo_service.dart';
import '../../../features/base/domain/entities/base.dart';
import 'local_selector_opcao.dart';
import 'sub_widgets/endereco_autocomplete_field.dart';
import 'sub_widgets/mapa_selector_sheet.dart';

/// Widget reutilizável para seleção de localização.
///
/// Exibe o endereço selecionado (ou placeholder) e um botão que abre
/// um bottom sheet com as opções disponíveis.
class LocalSelectorWidget extends StatefulWidget {
  const LocalSelectorWidget({
    super.key,
    required this.label,
    required this.onLocalSelecionado,
    this.valorInicial,
    this.opcoes = LocalSelectorOpcao.values,
    required this.geoService,
    this.basesDisponiveis = const [],
  });

  final String label;
  final ValueChanged<LocalGeo> onLocalSelecionado;
  final LocalGeo? valorInicial;
  final List<LocalSelectorOpcao> opcoes;
  final GeoService geoService;
  final List<Base> basesDisponiveis;

  @override
  State<LocalSelectorWidget> createState() => _LocalSelectorWidgetState();
}

class _LocalSelectorWidgetState extends State<LocalSelectorWidget> {
  LocalGeo? _selecionado;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _selecionado = widget.valorInicial;
  }

  @override
  void didUpdateWidget(covariant LocalSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valorInicial != oldWidget.valorInicial) {
      _selecionado = widget.valorInicial;
    }
  }

  void _selecionar(LocalGeo local) {
    setState(() => _selecionado = local);
    widget.onLocalSelecionado(local);
  }

  Future<void> _obterLocalizacaoAtual() async {
    setState(() => _carregando = true);
    try {
      final local = await widget.geoService.obterLocalizacaoAtual();
      if (local != null && mounted) {
        _selecionar(local);
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _selecionarBase() {
    showModalBottomSheet<Base>(
      context: context,
      builder: (_) => _BaseSelectorSheet(
        bases: widget.basesDisponiveis,
      ),
    ).then((base) {
      if (base != null) {
        _selecionar(base.local);
      }
    });
  }

  void _digitarEndereco() {
    showModalBottomSheet<LocalGeo>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EnderecoAutocompleteField(
        geoService: widget.geoService,
      ),
    ).then((local) {
      if (local != null) {
        _selecionar(local);
      }
    });
  }

  void _selecionarNoMapa() {
    showModalBottomSheet<LocalGeo>(
      context: context,
      isScrollControlled: true,
      builder: (_) => MapaSelectorSheet(
        geoService: widget.geoService,
        posicaoInicial: _selecionado,
      ),
    ).then((local) {
      if (local != null) {
        _selecionar(local);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        InkWell(
          key: const Key('localSelectorTap'),
          onTap: _carregando ? null : _showOpcoes,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _carregando
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selecionado?.enderecoTexto ??
                              'Toque para selecionar...',
                          style: TextStyle(
                            color: _selecionado != null
                                ? null
                                : Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_selecionado != null)
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 20),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _showOpcoes() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.opcoes.contains(LocalSelectorOpcao.localizacaoAtual))
              ListTile(
                key: const Key('opcaoLocalizacaoAtual'),
                leading: const Icon(Icons.my_location),
                title: const Text('Localização Atual'),
                onTap: () {
                  Navigator.pop(context);
                  _obterLocalizacaoAtual();
                },
              ),
            if (widget.opcoes.contains(LocalSelectorOpcao.selecionarBase))
              ListTile(
                key: const Key('opcaoSelecionarBase'),
                leading: const Icon(Icons.warehouse_outlined),
                title: const Text('Selecionar Base'),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarBase();
                },
              ),
            if (widget.opcoes.contains(LocalSelectorOpcao.digitarEndereco))
              ListTile(
                key: const Key('opcaoDigitarEndereco'),
                leading: const Icon(Icons.edit_location_outlined),
                title: const Text('Digitar Endereço'),
                onTap: () {
                  Navigator.pop(context);
                  _digitarEndereco();
                },
              ),
            if (widget.opcoes.contains(LocalSelectorOpcao.selecionarNoMapa))
              ListTile(
                key: const Key('opcaoSelecionarNoMapa'),
                leading: const Icon(Icons.map_outlined),
                title: const Text('Selecionar no Mapa'),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarNoMapa();
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Seletor de Base ────────────────────────────────────────────

class _BaseSelectorSheet extends StatelessWidget {
  const _BaseSelectorSheet({required this.bases});

  final List<Base> bases;

  @override
  Widget build(BuildContext context) {
    if (bases.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('Nenhuma base cadastrada.')),
      );
    }
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: bases.length,
        itemBuilder: (context, index) {
          final base = bases[index];
          return ListTile(
            key: Key('baseOption_${base.id}'),
            leading: Icon(
              base.isPrincipal ? Icons.star : Icons.warehouse_outlined,
              color: base.isPrincipal ? Colors.amber : null,
            ),
            title: Text(base.nome),
            subtitle: Text(base.local.enderecoTexto),
            onTap: () => Navigator.pop(context, base),
          );
        },
      ),
    );
  }
}
