import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/rastreamento/data/models/ponto_rastreamento_model.dart';
import 'package:sos_app/features/rastreamento/domain/entities/ponto_rastreamento.dart';

void main() {
  final now = DateTime(2024, 1, 1, 10, 0);

  group('PontoRastreamentoModel', () {
    test('fromEntity converte corretamente', () {
      final entity = PontoRastreamento(
        id: 'p-1',
        atendimentoId: 'at-1',
        latitude: -23.55,
        longitude: -46.63,
        accuracy: 10.0,
        velocidade: 5.0,
        timestamp: now,
      );

      final model = PontoRastreamentoModel.fromEntity(entity);

      expect(model.id, 'p-1');
      expect(model.atendimentoId, 'at-1');
      expect(model.latitude, -23.55);
      expect(model.longitude, -46.63);
      expect(model.accuracy, 10.0);
      expect(model.velocidade, 5.0);
      expect(model.timestamp, now.toIso8601String());
      expect(model.synced, false);
    });

    test('toEntity converte corretamente', () {
      final model = PontoRastreamentoModel(
        id: 'p-1',
        atendimentoId: 'at-1',
        latitude: -23.55,
        longitude: -46.63,
        accuracy: 10.0,
        velocidade: 5.0,
        timestamp: now.toIso8601String(),
        synced: true,
      );

      final entity = model.toEntity();

      expect(entity.id, 'p-1');
      expect(entity.atendimentoId, 'at-1');
      expect(entity.latitude, -23.55);
      expect(entity.longitude, -46.63);
      expect(entity.accuracy, 10.0);
      expect(entity.velocidade, 5.0);
      expect(entity.timestamp, now);
      expect(entity.synced, true);
    });

    test('fromJson converte corretamente', () {
      final json = {
        'id': 'p-1',
        'atendimentoId': 'at-1',
        'latitude': -23.55,
        'longitude': -46.63,
        'accuracy': 10.0,
        'velocidade': 5.0,
        'timestamp': now.toIso8601String(),
      };

      final model = PontoRastreamentoModel.fromJson(json);

      expect(model.id, 'p-1');
      expect(model.atendimentoId, 'at-1');
      expect(model.latitude, -23.55);
      expect(model.velocidade, 5.0);
    });

    test('toJson converte corretamente', () {
      final model = PontoRastreamentoModel(
        id: 'p-1',
        atendimentoId: 'at-1',
        latitude: -23.55,
        longitude: -46.63,
        accuracy: 10.0,
        timestamp: now.toIso8601String(),
      );

      final json = model.toJson();

      expect(json['id'], 'p-1');
      expect(json['atendimentoId'], 'at-1');
      expect(json['latitude'], -23.55);
      expect(json['velocidade'], isNull);
      expect(json.containsKey('synced'), isFalse);
    });

    test('fromJson lida com velocidade null', () {
      final json = {
        'id': 'p-1',
        'atendimentoId': 'at-1',
        'latitude': -23.55,
        'longitude': -46.63,
        'accuracy': 10.0,
        'velocidade': null,
        'timestamp': now.toIso8601String(),
      };

      final model = PontoRastreamentoModel.fromJson(json);

      expect(model.velocidade, isNull);
    });
  });
}
