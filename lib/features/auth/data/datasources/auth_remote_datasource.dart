import '../models/usuario_model.dart';

/// Contrato para autenticação via API REST.
/// O backend ainda será construído — este contrato define o que se espera.
///
/// Endpoints esperados:
///   POST /auth/login   → { email, senha } → { token, usuario }
///   GET  /auth/me      → (Bearer token)   → { usuario }
abstract class AuthRemoteDatasource {
  /// POST /auth/login
  /// Retorna `Map` com `token` (String) e `usuario` (UsuarioModel).
  Future<AuthLoginResponse> login({
    required String email,
    required String senha,
  });

  /// POST /auth/refresh
  /// Retorna novo token JWT e metadados da sessão.
  Future<AuthLoginResponse> refresh();

  /// GET /auth/me
  /// Retorna o [UsuarioModel] do usuário autenticado.
  Future<UsuarioModel> getUsuarioAtual();
}

class AuthLoginResponse {
  const AuthLoginResponse({
    required this.token,
    required this.usuarioId,
    required this.nome,
    required this.email,
    required this.role,
    required this.expiresAt,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    return AuthLoginResponse(
      token: json['token'] as String,
      usuarioId: json['usuarioId'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  final String token;
  final String usuarioId;
  final String nome;
  final String email;
  final String role;
  final DateTime expiresAt;

  UsuarioModel toUsuarioModel() => UsuarioModel(
        id: usuarioId,
        nome: nome,
        telefone: '',
        email: email,
        role: role,
        valorPorKmDefault: 0,
        criadoEm: DateTime.now().toIso8601String(),
      );
}
