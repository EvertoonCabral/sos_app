import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../features/rastreamento/domain/entities/ponto_rastreamento.dart';

/// Serviço de coleta GPS que abstrai o Geolocator.
/// Utilizado pelo background service para obter posições periódicas.
class GpsCollector {
  GpsCollector({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  StreamSubscription<Position>? _subscription;
  String? _atendimentoIdAtivo;
  final _controller = StreamController<PontoRastreamento>.broadcast();

  Stream<PontoRastreamento> get pontoStream => _controller.stream;
  bool get isTracking => _atendimentoIdAtivo != null;
  String? get atendimentoIdAtivo => _atendimentoIdAtivo;

  Future<void> iniciar(String atendimentoId) async {
    if (_atendimentoIdAtivo != null) return;
    _atendimentoIdAtivo = atendimentoId;

    final locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: AppConstants.gpsMinDistance.toInt(),
      intervalDuration: AppConstants.gpsInterval,
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationTitle: 'SOS App - Rastreamento',
        notificationText: 'Coletando GPS em background',
        enableWakeLock: true,
      ),
    );

    _subscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (position) {
        if (position.accuracy > AppConstants.gpsMinAccuracy) return;

        final ponto = PontoRastreamento(
          id: _uuid.v4(),
          atendimentoId: atendimentoId,
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          velocidade: position.speed >= 0 ? position.speed : null,
          timestamp: position.timestamp,
        );
        _controller.add(ponto);
      },
    );
  }

  Future<void> parar() async {
    await _subscription?.cancel();
    _subscription = null;
    _atendimentoIdAtivo = null;
  }

  Future<void> dispose() async {
    await parar();
    await _controller.close();
  }
}
