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

  /// GET /auth/me
  /// Retorna o [UsuarioModel] do usuário autenticado.
  Future<UsuarioModel> getUsuarioAtual();
}

class AuthLoginResponse {
  const AuthLoginResponse({required this.token, required this.usuario});

  final String token;
  final UsuarioModel usuario;
}
