import 'dart:convert';

import '../../../../core/entities/local_geo.dart';
import '../../domain/entities/base.dart';

class BaseModel {
  const BaseModel({
    required this.id,
    required this.nome,
    required this.localJson,
    this.isPrincipal = false,
    required this.criadoEm,
    this.sincronizadoEm,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        id: json['id'] as String,
        nome: json['nome'] as String,
        localJson: json['local'] is String
            ? json['local'] as String
            : jsonEncode(json['local']),
        isPrincipal: json['isPrincipal'] as bool? ?? false,
        criadoEm: json['criadoEm'] as String,
        sincronizadoEm: json['sincronizadoEm'] as String?,
      );

  factory BaseModel.fromEntity(Base entity) => BaseModel(
        id: entity.id,
        nome: entity.nome,
        localJson: jsonEncode({
          'enderecoTexto': entity.local.enderecoTexto,
          'latitude': entity.local.latitude,
          'longitude': entity.local.longitude,
          'complemento': entity.local.complemento,
        }),
        isPrincipal: entity.isPrincipal,
        criadoEm: entity.criadoEm.toIso8601String(),
        sincronizadoEm: entity.sincronizadoEm?.toIso8601String(),
      );

  final String id;
  final String nome;
  final String localJson;
  final bool isPrincipal;
  final String criadoEm;
  final String? sincronizadoEm;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'local': jsonDecode(localJson),
        'isPrincipal': isPrincipal,
        'criadoEm': criadoEm,
        'sincronizadoEm': sincronizadoEm,
      };

  Base toEntity() {
    final map = jsonDecode(localJson) as Map<String, dynamic>;
    final local = LocalGeo(
      enderecoTexto: map['enderecoTexto'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      complemento: map['complemento'] as String?,
    );

    return Base(
      id: id,
      nome: nome,
      local: local,
      isPrincipal: isPrincipal,
      criadoEm: DateTime.parse(criadoEm),
      sincronizadoEm:
          sincronizadoEm != null ? DateTime.parse(sincronizadoEm!) : null,
    );
  }
}
