import 'package:equatable/equatable.dart';

enum UsuarioRole { operador, administrador }

class Usuario extends Equatable {
  const Usuario({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.role,
    required this.valorPorKmDefault,
    required this.criadoEm,
    this.sincronizadoEm,
  });

  final String id;
  final String nome;
  final String telefone;
  final String email;
  final UsuarioRole role;
  final double valorPorKmDefault;
  final DateTime criadoEm;
  final DateTime? sincronizadoEm;

  @override
  List<Object?> get props => [
        id,
        nome,
        telefone,
        email,
        role,
        valorPorKmDefault,
        criadoEm,
        sincronizadoEm,
      ];
}
