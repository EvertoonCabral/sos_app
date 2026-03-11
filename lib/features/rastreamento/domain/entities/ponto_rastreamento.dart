import 'package:equatable/equatable.dart';

/// Ponto de rastreamento GPS coletado durante o deslocamento de um atendimento.
class PontoRastreamento extends Equatable {
  const PontoRastreamento({
    required this.id,
    required this.atendimentoId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.velocidade,
    required this.timestamp,
    this.synced = false,
  });

  final String id;
  final String atendimentoId;
  final double latitude;
  final double longitude;
  final double accuracy; // precisão em metros
  final double? velocidade; // m/s
  final DateTime timestamp;
  final bool synced;

  @override
  List<Object?> get props => [
        id,
        atendimentoId,
        latitude,
        longitude,
        accuracy,
        velocidade,
        timestamp,
        synced,
      ];
}
