import 'dart:convert';

import '../../../../core/entities/local_geo.dart';
import '../../domain/entities/cliente.dart';

class ClienteModel {
  const ClienteModel({
    required this.id,
    required this.nome,
    required this.telefone,
    this.documento,
    this.enderecoDefaultJson,
    required this.criadoEm,
    required this.atualizadoEm,
    this.sincronizadoEm,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
        id: json['id'] as String,
        nome: json['nome'] as String,
        telefone: json['telefone'] as String,
        documento: json['documento'] as String?,
        enderecoDefaultJson: json['enderecoDefault'] != null
            ? jsonEncode(json['enderecoDefault'])
            : null,
        criadoEm: json['criadoEm'] as String,
        atualizadoEm: json['atualizadoEm'] as String,
        sincronizadoEm: json['sincronizadoEm'] as String?,
      );

  factory ClienteModel.fromEntity(Cliente entity) => ClienteModel(
        id: entity.id,
        nome: entity.nome,
        telefone: entity.telefone,
        documento: entity.documento,
        enderecoDefaultJson: entity.enderecoDefault != null
            ? jsonEncode({
                'enderecoTexto': entity.enderecoDefault!.enderecoTexto,
                'latitude': entity.enderecoDefault!.latitude,
                'longitude': entity.enderecoDefault!.longitude,
                'complemento': entity.enderecoDefault!.complemento,
              })
            : null,
        criadoEm: entity.criadoEm.toIso8601String(),
        atualizadoEm: entity.atualizadoEm.toIso8601String(),
        sincronizadoEm: entity.sincronizadoEm?.toIso8601String(),
      );

  final String id;
  final String nome;
  final String telefone;
  final String? documento;
  final String? enderecoDefaultJson;
  final String criadoEm;
  final String atualizadoEm;
  final String? sincronizadoEm;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'documento': documento,
        'enderecoDefault': enderecoDefaultJson != null
            ? jsonDecode(enderecoDefaultJson!)
            : null,
        'criadoEm': criadoEm,
        'atualizadoEm': atualizadoEm,
        'sincronizadoEm': sincronizadoEm,
      };

  Cliente toEntity() {
    LocalGeo? endereco;
    if (enderecoDefaultJson != null) {
      final map = jsonDecode(enderecoDefaultJson!) as Map<String, dynamic>;
      endereco = LocalGeo(
        enderecoTexto: map['enderecoTexto'] as String,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        complemento: map['complemento'] as String?,
      );
    }

    return Cliente(
      id: id,
      nome: nome,
      telefone: telefone,
      documento: documento,
      enderecoDefault: endereco,
      criadoEm: DateTime.parse(criadoEm),
      atualizadoEm: DateTime.parse(atualizadoEm),
      sincronizadoEm:
          sincronizadoEm != null ? DateTime.parse(sincronizadoEm!) : null,
    );
  }
}
