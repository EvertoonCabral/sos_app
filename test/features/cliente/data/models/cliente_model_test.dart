import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/features/cliente/data/models/cliente_model.dart';
import 'package:sos_app/features/cliente/domain/entities/cliente.dart';

void main() {
  const tJson = {
    'id': 'cli-001',
    'nome': 'Maria Silva',
    'telefone': '+5511988880000',
    'documento': '123.456.789-00',
    'endereco_default': {
      'endereco_texto': 'Rua das Flores, 123',
      'latitude': -23.5,
      'longitude': -46.6,
      'complemento': 'Apto 42',
    },
    'criado_em': '2026-03-01T00:00:00.000',
    'atualizado_em': '2026-03-01T00:00:00.000',
    'sincronizado_em': null,
  };

  const tJsonSemEndereco = {
    'id': 'cli-002',
    'nome': 'João Santos',
    'telefone': '+5511977770000',
    'documento': null,
    'endereco_default': null,
    'criado_em': '2026-03-02T00:00:00.000',
    'atualizado_em': '2026-03-02T00:00:00.000',
    'sincronizado_em': null,
  };

  group('ClienteModel', () {
    test('fromJson deve criar model com endereço', () {
      final model = ClienteModel.fromJson(tJson);

      expect(model.id, 'cli-001');
      expect(model.nome, 'Maria Silva');
      expect(model.documento, '123.456.789-00');
      expect(model.enderecoDefaultJson, isNotNull);
    });

    test('fromJson deve criar model sem endereço', () {
      final model = ClienteModel.fromJson(tJsonSemEndereco);

      expect(model.id, 'cli-002');
      expect(model.enderecoDefaultJson, isNull);
      expect(model.documento, isNull);
    });

    test('toJson deve produzir map correto', () {
      final model = ClienteModel.fromJson(tJson);
      final json = model.toJson();

      expect(json['id'], 'cli-001');
      expect(json['nome'], 'Maria Silva');
      expect(json['endereco_default'], isA<Map>());
      expect(json['endereco_default']['latitude'], -23.5);
    });

    test('toEntity deve converter para Cliente com LocalGeo', () {
      final model = ClienteModel.fromJson(tJson);
      final entity = model.toEntity();

      expect(entity.id, 'cli-001');
      expect(entity.nome, 'Maria Silva');
      expect(entity.enderecoDefault, isNotNull);
      expect(entity.enderecoDefault!.latitude, -23.5);
      expect(entity.enderecoDefault!.enderecoTexto, 'Rua das Flores, 123');
      expect(entity.enderecoDefault!.complemento, 'Apto 42');
    });

    test('toEntity sem endereço deve ter enderecoDefault null', () {
      final model = ClienteModel.fromJson(tJsonSemEndereco);
      final entity = model.toEntity();

      expect(entity.enderecoDefault, isNull);
    });

    test('fromEntity deve converter de Cliente para Model', () {
      final entity = Cliente(
        id: 'cli-001',
        nome: 'Maria Silva',
        telefone: '+5511988880000',
        documento: '123.456.789-00',
        enderecoDefault: const LocalGeo(
          enderecoTexto: 'Rua das Flores, 123',
          latitude: -23.5,
          longitude: -46.6,
          complemento: 'Apto 42',
        ),
        criadoEm: DateTime(2026, 3, 1),
        atualizadoEm: DateTime(2026, 3, 1),
      );

      final model = ClienteModel.fromEntity(entity);

      expect(model.id, 'cli-001');
      expect(model.nome, 'Maria Silva');
      expect(model.enderecoDefaultJson, isNotNull);
    });

    test('roundtrip: entity → model → json → model → entity', () {
      final original = Cliente(
        id: 'cli-rt',
        nome: 'Roundtrip',
        telefone: '000',
        enderecoDefault: const LocalGeo(
          enderecoTexto: 'Teste',
          latitude: -10.0,
          longitude: -20.0,
        ),
        criadoEm: DateTime(2026, 1, 1),
        atualizadoEm: DateTime(2026, 1, 1),
      );

      final model1 = ClienteModel.fromEntity(original);
      final json = model1.toJson();
      final model2 = ClienteModel.fromJson(json);
      final restored = model2.toEntity();

      expect(restored.id, original.id);
      expect(restored.nome, original.nome);
      expect(restored.enderecoDefault?.latitude,
          original.enderecoDefault?.latitude);
    });
  });
}
