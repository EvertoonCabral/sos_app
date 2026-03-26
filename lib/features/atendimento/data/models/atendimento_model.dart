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
      clienteId: json['clienteId'] as String,
      usuarioId: json['usuarioId'] as String,
      pontoDeSaidaJson:
          jsonEncode(json['pontoDeSaida'] as Map<String, dynamic>),
      localDeColetaJson:
          jsonEncode(json['localDeColeta'] as Map<String, dynamic>),
      localDeEntregaJson:
          jsonEncode(json['localDeEntrega'] as Map<String, dynamic>),
      localDeRetornoJson:
          jsonEncode(json['localDeRetorno'] as Map<String, dynamic>),
      distanciaEstimadaKm: (json['distanciaEstimadaKm'] as num).toDouble(),
      distanciaRealKm: (json['distanciaRealKm'] as num?)?.toDouble(),
      valorPorKm: (json['valorPorKm'] as num).toDouble(),
      valorCobrado: (json['valorCobrado'] as num?)?.toDouble(),
      tipoValor: (json['tipoValor'] as String).toTipoValor().name,
      status: (json['status'] as String).toAtendimentoStatus().name,
      observacoes: json['observacoes'] as String?,
      criadoEm: json['criadoEm'] as String,
      atualizadoEm: json['atualizadoEm'] as String,
      iniciadoEm: json['iniciadoEm'] as String?,
      chegadaColetaEm: json['chegadaColetaEm'] as String?,
      chegadaEntregaEm: json['chegadaEntregaEm'] as String?,
      inicioRetornoEm: json['inicioRetornoEm'] as String?,
      concluidoEm: json['concluidoEm'] as String?,
      sincronizadoEm: json['sincronizadoEm'] as String?,
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
        'clienteId': clienteId,
        'usuarioId': usuarioId,
        'pontoDeSaida': jsonDecode(pontoDeSaidaJson),
        'localDeColeta': jsonDecode(localDeColetaJson),
        'localDeEntrega': jsonDecode(localDeEntregaJson),
        'localDeRetorno': jsonDecode(localDeRetornoJson),
        'distanciaEstimadaKm': distanciaEstimadaKm,
        'distanciaRealKm': distanciaRealKm,
        'valorPorKm': valorPorKm,
        'valorCobrado': valorCobrado,
        'tipoValor': _toApiEnum(tipoValor),
        'status': _toApiEnum(status),
        'observacoes': observacoes,
        'criadoEm': criadoEm,
        'atualizadoEm': atualizadoEm,
        'iniciadoEm': iniciadoEm,
        'chegadaColetaEm': chegadaColetaEm,
        'chegadaEntregaEm': chegadaEntregaEm,
        'inicioRetornoEm': inicioRetornoEm,
        'concluidoEm': concluidoEm,
        'sincronizadoEm': sincronizadoEm,
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
        'enderecoTexto': local.enderecoTexto,
        'latitude': local.latitude,
        'longitude': local.longitude,
        'complemento': local.complemento,
      });

  static LocalGeo _decodeLocalGeo(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return LocalGeo(
      enderecoTexto: map['enderecoTexto'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      complemento: map['complemento'] as String?,
    );
  }

  /// Converte camelCase interno para PascalCase da API. Ex: emDeslocamento → EmDeslocamento
  static String _toApiEnum(String camelName) =>
      camelName[0].toUpperCase() + camelName.substring(1);
}
