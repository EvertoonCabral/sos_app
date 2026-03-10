import 'dart:convert';

import '../../../../core/entities/local_geo.dart';
import '../../domain/entities/atendimento.dart';
import '../../domain/entities/atendimento_enums.dart';

class AtendimentoModel {
  const AtendimentoModel({
    required this.id,
    required this.clienteId,
    required this.usuarioId,
    required this.pontoDeSaidaJson,
    required this.localDeColetaJson,
    required this.localDeEntregaJson,
    required this.localDeRetornoJson,
    required this.distanciaEstimadaKm,
    this.distanciaRealKm,
    required this.valorPorKm,
    this.valorCobrado,
    required this.tipoValor,
    required this.status,
    this.observacoes,
    required this.criadoEm,
    required this.atualizadoEm,
    this.iniciadoEm,
    this.chegadaColetaEm,
    this.chegadaEntregaEm,
    this.inicioRetornoEm,
    this.concluidoEm,
    this.sincronizadoEm,
  });

  factory AtendimentoModel.fromJson(Map<String, dynamic> json) {
    return AtendimentoModel(
      id: json['id'] as String,
      clienteId: json['cliente_id'] as String,
      usuarioId: json['usuario_id'] as String,
      pontoDeSaidaJson: json['ponto_de_saida'] is String
          ? json['ponto_de_saida'] as String
          : jsonEncode(json['ponto_de_saida']),
      localDeColetaJson: json['local_de_coleta'] is String
          ? json['local_de_coleta'] as String
          : jsonEncode(json['local_de_coleta']),
      localDeEntregaJson: json['local_de_entrega'] is String
          ? json['local_de_entrega'] as String
          : jsonEncode(json['local_de_entrega']),
      localDeRetornoJson: json['local_de_retorno'] is String
          ? json['local_de_retorno'] as String
          : jsonEncode(json['local_de_retorno']),
      distanciaEstimadaKm: (json['distancia_estimada_km'] as num).toDouble(),
      distanciaRealKm: (json['distancia_real_km'] as num?)?.toDouble(),
      valorPorKm: (json['valor_por_km'] as num).toDouble(),
      valorCobrado: (json['valor_cobrado'] as num?)?.toDouble(),
      tipoValor: json['tipo_valor'] as String,
      status: json['status'] as String,
      observacoes: json['observacoes'] as String?,
      criadoEm: json['criado_em'] as String,
      atualizadoEm: json['atualizado_em'] as String,
      iniciadoEm: json['iniciado_em'] as String?,
      chegadaColetaEm: json['chegada_coleta_em'] as String?,
      chegadaEntregaEm: json['chegada_entrega_em'] as String?,
      inicioRetornoEm: json['inicio_retorno_em'] as String?,
      concluidoEm: json['concluido_em'] as String?,
      sincronizadoEm: json['sincronizado_em'] as String?,
    );
  }

  factory AtendimentoModel.fromEntity(Atendimento entity) {
    return AtendimentoModel(
      id: entity.id,
      clienteId: entity.clienteId,
      usuarioId: entity.usuarioId,
      pontoDeSaidaJson: _encodeLocalGeo(entity.pontoDeSaida),
      localDeColetaJson: _encodeLocalGeo(entity.localDeColeta),
      localDeEntregaJson: _encodeLocalGeo(entity.localDeEntrega),
      localDeRetornoJson: _encodeLocalGeo(entity.localDeRetorno),
      distanciaEstimadaKm: entity.distanciaEstimadaKm,
      distanciaRealKm: entity.distanciaRealKm,
      valorPorKm: entity.valorPorKm,
      valorCobrado: entity.valorCobrado,
      tipoValor: entity.tipoValor.name,
      status: entity.status.name,
      observacoes: entity.observacoes,
      criadoEm: entity.criadoEm.toIso8601String(),
      atualizadoEm: entity.atualizadoEm.toIso8601String(),
      iniciadoEm: entity.iniciadoEm?.toIso8601String(),
      chegadaColetaEm: entity.chegadaColetaEm?.toIso8601String(),
      chegadaEntregaEm: entity.chegadaEntregaEm?.toIso8601String(),
      inicioRetornoEm: entity.inicioRetornoEm?.toIso8601String(),
      concluidoEm: entity.concluidoEm?.toIso8601String(),
      sincronizadoEm: entity.sincronizadoEm?.toIso8601String(),
    );
  }

  final String id;
  final String clienteId;
  final String usuarioId;
  final String pontoDeSaidaJson;
  final String localDeColetaJson;
  final String localDeEntregaJson;
  final String localDeRetornoJson;
  final double distanciaEstimadaKm;
  final double? distanciaRealKm;
  final double valorPorKm;
  final double? valorCobrado;
  final String tipoValor; // 'fixo' | 'porKm'
  final String status;
  final String? observacoes;
  final String criadoEm;
  final String atualizadoEm;
  final String? iniciadoEm;
  final String? chegadaColetaEm;
  final String? chegadaEntregaEm;
  final String? inicioRetornoEm;
  final String? concluidoEm;
  final String? sincronizadoEm;

  Map<String, dynamic> toJson() => {
        'id': id,
        'cliente_id': clienteId,
        'usuario_id': usuarioId,
        'ponto_de_saida': jsonDecode(pontoDeSaidaJson),
        'local_de_coleta': jsonDecode(localDeColetaJson),
        'local_de_entrega': jsonDecode(localDeEntregaJson),
        'local_de_retorno': jsonDecode(localDeRetornoJson),
        'distancia_estimada_km': distanciaEstimadaKm,
        'distancia_real_km': distanciaRealKm,
        'valor_por_km': valorPorKm,
        'valor_cobrado': valorCobrado,
        'tipo_valor': tipoValor,
        'status': status,
        'observacoes': observacoes,
        'criado_em': criadoEm,
        'atualizado_em': atualizadoEm,
        'iniciado_em': iniciadoEm,
        'chegada_coleta_em': chegadaColetaEm,
        'chegada_entrega_em': chegadaEntregaEm,
        'inicio_retorno_em': inicioRetornoEm,
        'concluido_em': concluidoEm,
        'sincronizado_em': sincronizadoEm,
      };

  Atendimento toEntity() {
    return Atendimento(
      id: id,
      clienteId: clienteId,
      usuarioId: usuarioId,
      pontoDeSaida: _decodeLocalGeo(pontoDeSaidaJson),
      localDeColeta: _decodeLocalGeo(localDeColetaJson),
      localDeEntrega: _decodeLocalGeo(localDeEntregaJson),
      localDeRetorno: _decodeLocalGeo(localDeRetornoJson),
      distanciaEstimadaKm: distanciaEstimadaKm,
      distanciaRealKm: distanciaRealKm,
      valorPorKm: valorPorKm,
      valorCobrado: valorCobrado,
      tipoValor: TipoValor.values.byName(tipoValor),
      status: AtendimentoStatus.values.byName(status),
      observacoes: observacoes,
      criadoEm: DateTime.parse(criadoEm),
      atualizadoEm: DateTime.parse(atualizadoEm),
      iniciadoEm: iniciadoEm != null ? DateTime.parse(iniciadoEm!) : null,
      chegadaColetaEm:
          chegadaColetaEm != null ? DateTime.parse(chegadaColetaEm!) : null,
      chegadaEntregaEm:
          chegadaEntregaEm != null ? DateTime.parse(chegadaEntregaEm!) : null,
      inicioRetornoEm:
          inicioRetornoEm != null ? DateTime.parse(inicioRetornoEm!) : null,
      concluidoEm: concluidoEm != null ? DateTime.parse(concluidoEm!) : null,
      sincronizadoEm:
          sincronizadoEm != null ? DateTime.parse(sincronizadoEm!) : null,
    );
  }

  static String _encodeLocalGeo(LocalGeo local) => jsonEncode({
        'endereco_texto': local.enderecoTexto,
        'latitude': local.latitude,
        'longitude': local.longitude,
        'complemento': local.complemento,
      });

  static LocalGeo _decodeLocalGeo(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return LocalGeo(
      enderecoTexto: map['endereco_texto'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      complemento: map['complemento'] as String?,
    );
  }
}
