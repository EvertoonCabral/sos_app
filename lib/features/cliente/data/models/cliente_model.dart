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
        enderecoDefaultJson: json['endereco_default'] != null
            ? jsonEncode(json['endereco_default'])
            : null,
        criadoEm: json['criado_em'] as String,
        atualizadoEm: json['atualizado_em'] as String,
        sincronizadoEm: json['sincronizado_em'] as String?,
      );

  factory ClienteModel.fromEntity(Cliente entity) => ClienteModel(
        id: entity.id,
        nome: entity.nome,
        telefone: entity.telefone,
        documento: entity.documento,
        enderecoDefaultJson: entity.enderecoDefault != null
            ? jsonEncode({
                'endereco_texto': entity.enderecoDefault!.enderecoTexto,
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
        'endereco_default': enderecoDefaultJson != null
            ? jsonDecode(enderecoDefaultJson!)
            : null,
        'criado_em': criadoEm,
        'atualizado_em': atualizadoEm,
        'sincronizado_em': sincronizadoEm,
      };

  Cliente toEntity() {
    LocalGeo? endereco;
    if (enderecoDefaultJson != null) {
      final map = jsonDecode(enderecoDefaultJson!) as Map<String, dynamic>;
      endereco = LocalGeo(
        enderecoTexto: map['endereco_texto'] as String,
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
