import 'package:equatable/equatable.dart';

import '../../../../core/entities/local_geo.dart';

class Cliente extends Equatable {
  const Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    this.documento,
    this.enderecoDefault,
    required this.criadoEm,
    required this.atualizadoEm,
    this.sincronizadoEm,
  });

  final String id;
  final String nome;
  final String telefone;
  final String? documento;
  final LocalGeo? enderecoDefault;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? sincronizadoEm;

  Cliente copyWith({
    String? nome,
    String? telefone,
    String? documento,
    LocalGeo? enderecoDefault,
    DateTime? atualizadoEm,
    DateTime? sincronizadoEm,
  }) {
    return Cliente(
      id: id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      documento: documento ?? this.documento,
      enderecoDefault: enderecoDefault ?? this.enderecoDefault,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nome,
        telefone,
        documento,
        enderecoDefault,
        criadoEm,
        atualizadoEm,
        sincronizadoEm,
      ];
}
