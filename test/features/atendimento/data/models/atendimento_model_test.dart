import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/features/atendimento/data/models/atendimento_model.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';

void main() {
  const local = LocalGeo(
    enderecoTexto: 'Rua A, 100',
    latitude: -23.55,
    longitude: -46.63,
  );

  final entity = Atendimento(
    id: 'at-1',
    clienteId: 'c1',
    usuarioId: 'u1',
    pontoDeSaida: local,
    localDeColeta: local,
    localDeEntrega: local,
    localDeRetorno: local,
    distanciaEstimadaKm: 25.0,
    valorPorKm: 5.0,
    valorCobrado: 125.0,
    tipoValor: TipoValor.fixo,
    status: AtendimentoStatus.rascunho,
    observacoes: 'Teste',
    criadoEm: DateTime(2024, 1, 1),
    atualizadoEm: DateTime(2024, 1, 1),
  );

  group('AtendimentoModel', () {
    test('fromEntity → toEntity deve preservar todos os campos', () {
      final model = AtendimentoModel.fromEntity(entity);
      final result = model.toEntity();

      expect(result.id, entity.id);
      expect(result.clienteId, entity.clienteId);
      expect(result.usuarioId, entity.usuarioId);
      expect(result.pontoDeSaida, entity.pontoDeSaida);
      expect(result.localDeColeta, entity.localDeColeta);
      expect(result.localDeEntrega, entity.localDeEntrega);
      expect(result.localDeRetorno, entity.localDeRetorno);
      expect(result.distanciaEstimadaKm, entity.distanciaEstimadaKm);
      expect(result.valorPorKm, entity.valorPorKm);
      expect(result.valorCobrado, entity.valorCobrado);
      expect(result.tipoValor, entity.tipoValor);
      expect(result.status, entity.status);
      expect(result.observacoes, entity.observacoes);
    });

    test('toJson deve serializar LocalGeo como objetos', () {
      final model = AtendimentoModel.fromEntity(entity);
      final json = model.toJson();

      expect(json['pontoDeSaida'], isA<Map>());
      expect(json['pontoDeSaida']['enderecoTexto'], 'Rua A, 100');
      expect(json['tipoValor'], 'Fixo');
      expect(json['status'], 'Rascunho');
    });

    test('fromJson deve deserializar corretamente', () {
      final model = AtendimentoModel.fromEntity(entity);
      final json = model.toJson();
      final restored = AtendimentoModel.fromJson(json);

      expect(restored.id, model.id);
      expect(restored.clienteId, model.clienteId);
      expect(restored.tipoValor, model.tipoValor);
      expect(restored.status, model.status);
    });

    test('fromJson com payload camelCase deve funcionar', () {
      final local = {
        'enderecoTexto': 'Rua A, 100',
        'latitude': -23.55,
        'longitude': -46.63,
        'complemento': null,
      };

      final json = {
        'id': 'at-1',
        'clienteId': 'c1',
        'usuarioId': 'u1',
        'pontoDeSaida': local,
        'localDeColeta': local,
        'localDeEntrega': local,
        'localDeRetorno': local,
        'distanciaEstimadaKm': 25.0,
        'valorPorKm': 5.0,
        'valorCobrado': 125.0,
        'tipoValor': 'Fixo',
        'status': 'Rascunho',
        'observacoes': 'Teste',
        'criadoEm': '2024-01-01T00:00:00.000',
        'atualizadoEm': '2024-01-01T00:00:00.000',
      };

      final model = AtendimentoModel.fromJson(json);
      expect(model.id, 'at-1');
      expect(model.pontoDeSaidaJson, jsonEncode(local));
    });

    test('fromJson falha quando LocalGeo nao vem como objeto', () {
      final json = {
        'id': 'at-1',
        'clienteId': 'c1',
        'usuarioId': 'u1',
        'pontoDeSaida': '{"enderecoTexto":"Rua A, 100"}',
        'localDeColeta': {
          'enderecoTexto': 'Rua A, 100',
          'latitude': -23.55,
          'longitude': -46.63,
          'complemento': null
        },
        'localDeEntrega': {
          'enderecoTexto': 'Rua A, 100',
          'latitude': -23.55,
          'longitude': -46.63,
          'complemento': null
        },
        'localDeRetorno': {
          'enderecoTexto': 'Rua A, 100',
          'latitude': -23.55,
          'longitude': -46.63,
          'complemento': null
        },
        'distanciaEstimadaKm': 25.0,
        'valorPorKm': 5.0,
        'tipoValor': 'Fixo',
        'status': 'Rascunho',
        'criadoEm': '2024-01-01T00:00:00.000',
        'atualizadoEm': '2024-01-01T00:00:00.000',
      };

      expect(
        () => AtendimentoModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('fromEntity preserva timestamps opcionais quando não null', () {
      final comTimestamps = entity.copyWith(
        status: AtendimentoStatus.emDeslocamento,
        iniciadoEm: DateTime(2024, 1, 1, 10),
      );
      final model = AtendimentoModel.fromEntity(comTimestamps);

      expect(model.iniciadoEm, isNotNull);
      expect(model.chegadaColetaEm, isNull);
    });

    test('toEntity converte enums corretamente', () {
      final model = AtendimentoModel.fromEntity(entity.copyWith(
        tipoValor: TipoValor.porKm,
        status: AtendimentoStatus.retornando,
      ));
      final result = model.toEntity();

      expect(result.tipoValor, TipoValor.porKm);
      expect(result.status, AtendimentoStatus.retornando);
    });
  });
}
