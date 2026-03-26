import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/features/base/data/models/base_model.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';

void main() {
  const tJson = {
    'id': 'base-001',
    'nome': 'Garagem SP',
    'local': {
      'enderecoTexto': 'Rua das Garagens, 100',
      'latitude': -23.5,
      'longitude': -46.6,
      'complemento': null,
    },
    'isPrincipal': true,
    'criadoEm': '2026-03-01T00:00:00.000',
    'sincronizadoEm': null,
  };

  group('BaseModel', () {
    test('fromJson deve criar model corretamente', () {
      final model = BaseModel.fromJson(tJson);

      expect(model.id, 'base-001');
      expect(model.nome, 'Garagem SP');
      expect(model.isPrincipal, true);
    });

    test('toJson deve produzir map correto', () {
      final model = BaseModel.fromJson(tJson);
      final json = model.toJson();

      expect(json['id'], 'base-001');
      expect(json['local'], isA<Map>());
      expect(json['local']['latitude'], -23.5);
      expect(json['isPrincipal'], true);
    });

    test('toEntity deve converter para Base com LocalGeo', () {
      final model = BaseModel.fromJson(tJson);
      final entity = model.toEntity();

      expect(entity.id, 'base-001');
      expect(entity.local.enderecoTexto, 'Rua das Garagens, 100');
      expect(entity.isPrincipal, true);
    });

    test('fromEntity deve converter de Base para Model', () {
      final entity = Base(
        id: 'base-001',
        nome: 'Garagem SP',
        local: const LocalGeo(
          enderecoTexto: 'Rua das Garagens, 100',
          latitude: -23.5,
          longitude: -46.6,
        ),
        isPrincipal: true,
        criadoEm: DateTime(2026, 3, 1),
      );

      final model = BaseModel.fromEntity(entity);

      expect(model.id, 'base-001');
      expect(model.isPrincipal, true);
    });

    test('roundtrip: entity → model → json → model → entity', () {
      final original = Base(
        id: 'base-rt',
        nome: 'Roundtrip',
        local: const LocalGeo(
          enderecoTexto: 'Teste',
          latitude: -10.0,
          longitude: -20.0,
          complemento: 'Galpão A',
        ),
        criadoEm: DateTime(2026, 1, 1),
      );

      final model1 = BaseModel.fromEntity(original);
      final json = model1.toJson();
      final model2 = BaseModel.fromJson(json);
      final restored = model2.toEntity();

      expect(restored.id, original.id);
      expect(restored.nome, original.nome);
      expect(restored.local.latitude, original.local.latitude);
      expect(restored.local.complemento, 'Galpão A');
    });
  });
}
