import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/ponto_rastreamento.dart';

/// Exibe o percurso rastreado em um mapa usando flutter_map.
class MapaPercursoWidget extends StatelessWidget {
  const MapaPercursoWidget({
    super.key,
    required this.pontos,
    this.height = 300,
  });

  final List<PontoRastreamento> pontos;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (pontos.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('Nenhum ponto de rastreamento registrado'),
        ),
      );
    }

    final latLngs = pontos.map((p) => LatLng(p.latitude, p.longitude)).toList();

    final bounds = LatLngBounds.fromPoints(latLngs);

    return SizedBox(
      height: height,
      child: FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(32),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.sosapp',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: latLngs,
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 4,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latLngs.first,
                child: const Icon(
                  Icons.play_circle_filled,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              Marker(
                point: latLngs.last,
                child: const Icon(
                  Icons.stop_circle,
                  color: Colors.red,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
