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

      expect(json['ponto_de_saida'], isA<Map>());
      expect(json['ponto_de_saida']['endereco_texto'], 'Rua A, 100');
      expect(json['tipo_valor'], 'fixo');
      expect(json['status'], 'rascunho');
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

    test('fromJson com LocalGeo como string JSON deve funcionar', () {
      final localJson = jsonEncode({
        'endereco_texto': 'Rua A, 100',
        'latitude': -23.55,
        'longitude': -46.63,
        'complemento': null,
      });

      final json = {
        'id': 'at-1',
        'cliente_id': 'c1',
        'usuario_id': 'u1',
        'ponto_de_saida': localJson,
        'local_de_coleta': localJson,
        'local_de_entrega': localJson,
        'local_de_retorno': localJson,
        'distancia_estimada_km': 25.0,
        'valor_por_km': 5.0,
        'valor_cobrado': 125.0,
        'tipo_valor': 'fixo',
        'status': 'rascunho',
        'observacoes': 'Teste',
        'criado_em': '2024-01-01T00:00:00.000',
        'atualizado_em': '2024-01-01T00:00:00.000',
      };

      final model = AtendimentoModel.fromJson(json);
      expect(model.id, 'at-1');
      expect(model.pontoDeSaidaJson, localJson);
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
