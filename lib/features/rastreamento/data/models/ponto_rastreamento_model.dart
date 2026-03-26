import '../../domain/entities/ponto_rastreamento.dart';

class PontoRastreamentoModel {
  const PontoRastreamentoModel({
    required this.id,
    required this.atendimentoId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.velocidade,
    required this.timestamp,
    this.synced = false,
  });

  factory PontoRastreamentoModel.fromJson(Map<String, dynamic> json) {
    return PontoRastreamentoModel(
      id: json['id'] as String,
      atendimentoId: json['atendimentoId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      velocidade: (json['velocidade'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as String,
      synced: json['synced'] as bool? ?? false,
    );
  }

  factory PontoRastreamentoModel.fromEntity(PontoRastreamento entity) {
    return PontoRastreamentoModel(
      id: entity.id,
      atendimentoId: entity.atendimentoId,
      latitude: entity.latitude,
      longitude: entity.longitude,
      accuracy: entity.accuracy,
      velocidade: entity.velocidade,
      timestamp: entity.timestamp.toIso8601String(),
      synced: entity.synced,
    );
  }

  final String id;
  final String atendimentoId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double? velocidade;
  final String timestamp;
  final bool synced;

  Map<String, dynamic> toJson() => {
        'id': id,
        'atendimentoId': atendimentoId,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'velocidade': velocidade,
        'timestamp': timestamp,
      };

  Map<String, dynamic> toApiJson() => toJson();

  PontoRastreamento toEntity() {
    return PontoRastreamento(
      id: id,
      atendimentoId: atendimentoId,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      velocidade: velocidade,
      timestamp: DateTime.parse(timestamp),
      synced: synced,
    );
  }
}
