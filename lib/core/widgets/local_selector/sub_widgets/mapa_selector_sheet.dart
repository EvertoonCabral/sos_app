import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../entities/local_geo.dart';
import '../../../geo/geo_service.dart';

/// Bottom sheet com flutter_map para seleção via tap no mapa.
class MapaSelectorSheet extends StatefulWidget {
  const MapaSelectorSheet({
    super.key,
    required this.geoService,
    this.posicaoInicial,
  });

  final GeoService geoService;
  final LocalGeo? posicaoInicial;

  @override
  State<MapaSelectorSheet> createState() => _MapaSelectorSheetState();
}

class _MapaSelectorSheetState extends State<MapaSelectorSheet> {
  LatLng? _pontoSelecionado;
  String? _enderecoTexto;
  bool _carregando = false;

  LatLng get _centroInicial => widget.posicaoInicial != null
      ? LatLng(
          widget.posicaoInicial!.latitude, widget.posicaoInicial!.longitude)
      : const LatLng(-23.5505, -46.6333); // São Paulo default

  Future<void> _onTap(TapPosition tapPosition, LatLng ponto) async {
    setState(() {
      _pontoSelecionado = ponto;
      _carregando = true;
    });

    try {
      final local = await widget.geoService.reverseGeocodificar(
        ponto.latitude,
        ponto.longitude,
      );
      if (mounted) {
        setState(() {
          _enderecoTexto = local?.enderecoTexto ?? 'Endereço não encontrado';
        });
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _confirmar() {
    if (_pontoSelecionado == null) return;
    final local = LocalGeo(
      enderecoTexto: _enderecoTexto ?? 'Ponto selecionado',
      latitude: _pontoSelecionado!.latitude,
      longitude: _pontoSelecionado!.longitude,
    );
    Navigator.of(context).pop(local);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _centroInicial,
                initialZoom: 14,
                onTap: _onTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (_pontoSelecionado != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _pontoSelecionado!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (_carregando)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          if (_enderecoTexto != null && !_carregando)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _enderecoTexto!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('confirmarMapaButton'),
                onPressed: _pontoSelecionado != null ? _confirmar : null,
                child: const Text('Confirmar Local'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
