import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/auth/data/models/usuario_model.dart';
import 'package:sos_app/features/auth/domain/entities/usuario.dart';

void main() {
  const tUsuarioJson = {
    'id': 'user-123',
    'nome': 'João Operador',
    'telefone': '+5511999990000',
    'email': 'joao@guincho.com',
    'role': 'operador',
    'valor_por_km_default': 5.0,
    'criado_em': '2026-03-01T00:00:00.000',
    'sincronizado_em': null,
  };

  const tModel = UsuarioModel(
    id: 'user-123',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@guincho.com',
    role: 'operador',
    valorPorKmDefault: 5.0,
    criadoEm: '2026-03-01T00:00:00.000',
  );

  final tEntity = Usuario(
    id: 'user-123',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@guincho.com',
    role: UsuarioRole.operador,
    valorPorKmDefault: 5.0,
    criadoEm: DateTime(2026, 3, 1),
  );

  group('UsuarioModel', () {
    test('fromJson deve criar model correto a partir do JSON', () {
      final result = UsuarioModel.fromJson(tUsuarioJson);

      expect(result.id, tModel.id);
      expect(result.nome, tModel.nome);
      expect(result.email, tModel.email);
      expect(result.role, tModel.role);
      expect(result.valorPorKmDefault, tModel.valorPorKmDefault);
    });

    test('toJson deve produzir map correto', () {
      final result = tModel.toJson();

      expect(result['id'], 'user-123');
      expect(result['nome'], 'João Operador');
      expect(result['email'], 'joao@guincho.com');
      expect(result['role'], 'operador');
      expect(result['valor_por_km_default'], 5.0);
      expect(result['criado_em'], '2026-03-01T00:00:00.000');
      expect(result['sincronizado_em'], isNull);
    });

    test('toEntity deve converter para Usuario correto', () {
      final result = tModel.toEntity();

      expect(result.id, tEntity.id);
      expect(result.nome, tEntity.nome);
      expect(result.email, tEntity.email);
      expect(result.role, UsuarioRole.operador);
      expect(result.valorPorKmDefault, 5.0);
      expect(result.criadoEm, DateTime(2026, 3, 1));
    });

    test('fromEntity deve converter de Usuario para Model', () {
      final result = UsuarioModel.fromEntity(tEntity);

      expect(result.id, tEntity.id);
      expect(result.nome, tEntity.nome);
      expect(result.email, tEntity.email);
      expect(result.role, 'operador');
      expect(result.valorPorKmDefault, 5.0);
    });

    test('fromJson deve tratar role administrador corretamente', () {
      final adminJson = Map<String, dynamic>.from(tUsuarioJson)
        ..['role'] = 'administrador';

      final result = UsuarioModel.fromJson(adminJson);
      final entity = result.toEntity();

      expect(entity.role, UsuarioRole.administrador);
    });
  });
}
