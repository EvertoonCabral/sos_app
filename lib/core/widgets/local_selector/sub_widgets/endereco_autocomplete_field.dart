import 'dart:async';

import 'package:flutter/material.dart';

import '../../../entities/local_geo.dart';
import '../../../geo/geo_service.dart';

/// Bottom sheet com campo de autocomplete para endereço.
class EnderecoAutocompleteField extends StatefulWidget {
  const EnderecoAutocompleteField({
    super.key,
    required this.geoService,
  });

  final GeoService geoService;

  @override
  State<EnderecoAutocompleteField> createState() =>
      _EnderecoAutocompleteFieldState();
}

class _EnderecoAutocompleteFieldState extends State<EnderecoAutocompleteField> {
  final _controller = TextEditingController();
  List<LocalGeo> _sugestoes = [];
  bool _carregando = false;
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().length < 3) {
      setState(() => _sugestoes = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _buscar(query.trim());
    });
  }

  Future<void> _buscar(String query) async {
    setState(() => _carregando = true);
    try {
      final results = await widget.geoService.autocompletar(query);
      if (mounted) setState(() => _sugestoes = results);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _selecionarSugestao(LocalGeo local) async {
    Navigator.of(context).pop(local);
  }

  Future<void> _confirmarTexto() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _carregando = true);
    try {
      final local = await widget.geoService.geocodificar(text);
      if (local != null && mounted) {
        Navigator.of(context).pop(local);
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('enderecoAutocompleteField'),
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Digite o endereço...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: _carregando
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      key: const Key('confirmarEnderecoButton'),
                      icon: const Icon(Icons.check),
                      onPressed: _confirmarTexto,
                    ),
            ),
            onChanged: _onQueryChanged,
          ),
          if (_sugestoes.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _sugestoes.length,
                itemBuilder: (context, index) {
                  final s = _sugestoes[index];
                  return ListTile(
                    key: Key('sugestao_$index'),
                    leading: const Icon(Icons.place),
                    title: Text(s.enderecoTexto),
                    onTap: () => _selecionarSugestao(s),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
