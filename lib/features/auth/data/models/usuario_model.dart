import '../../domain/entities/usuario.dart';

class UsuarioModel {
  const UsuarioModel({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.role,
    required this.valorPorKmDefault,
    required this.criadoEm,
    this.sincronizadoEm,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: (json['id'] ?? json['usuarioId']) as String,
        nome: json['nome'] as String,
        telefone: (json['telefone'] as String?) ?? '',
        email: json['email'] as String,
        role: json['role'] as String,
        valorPorKmDefault:
            ((json['valorPorKmDefault'] as num?) ?? 0).toDouble(),
        criadoEm:
            (json['criadoEm'] as String?) ?? DateTime.now().toIso8601String(),
        sincronizadoEm: json['sincronizadoEm'] as String?,
      );

  factory UsuarioModel.fromCurrentUserJson(Map<String, dynamic> json) =>
      UsuarioModel(
        id: json['usuarioId'] as String,
        nome: json['nome'] as String,
        telefone: '',
        email: json['email'] as String,
        role: json['role'] as String,
        valorPorKmDefault: (json['valorPorKmDefault'] as num).toDouble(),
        criadoEm: DateTime.now().toIso8601String(),
      );

  factory UsuarioModel.fromEntity(Usuario entity) => UsuarioModel(
        id: entity.id,
        nome: entity.nome,
        telefone: entity.telefone,
        email: entity.email,
        role: entity.role.name,
        valorPorKmDefault: entity.valorPorKmDefault,
        criadoEm: entity.criadoEm.toIso8601String(),
        sincronizadoEm: entity.sincronizadoEm?.toIso8601String(),
      );

  final String id;
  final String nome;
  final String telefone;
  final String email;
  final String role;
  final double valorPorKmDefault;
  final String criadoEm;
  final String? sincronizadoEm;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'telefone': telefone,
        'email': email,
        'role': role,
        'valorPorKmDefault': valorPorKmDefault,
        'criadoEm': criadoEm,
        'sincronizadoEm': sincronizadoEm,
      };

  Usuario toEntity() => Usuario(
        id: id,
        nome: nome,
        telefone: telefone,
        email: email,
        role: role == 'administrador'
            ? UsuarioRole.administrador
            : UsuarioRole.operador,
        valorPorKmDefault: valorPorKmDefault,
        criadoEm: DateTime.parse(criadoEm),
        sincronizadoEm:
            sincronizadoEm != null ? DateTime.parse(sincronizadoEm!) : null,
      );
}
