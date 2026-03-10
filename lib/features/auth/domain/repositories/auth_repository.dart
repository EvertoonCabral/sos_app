import '../entities/usuario.dart';

/// Contrato do repositório de autenticação.
/// Dart puro — sem dependências de Flutter ou pacotes externos.
abstract class AuthRepository {
  /// Autentica o usuário com email e senha.
  /// Retorna o [Usuario] autenticado em caso de sucesso.
  /// Lança exceção na camada Data; aqui o contrato é limpo.
  Future<Usuario> autenticar({
    required String email,
    required String senha,
  });

  /// Retorna o usuário logado a partir do token persistido.
  /// Retorna `null` se não houver sessão ativa.
  Future<Usuario?> obterUsuarioLogado();

  /// Encerra a sessão: limpa token e dados locais do usuário.
  Future<void> logout();

  /// Persiste o token de autenticação de forma segura.
  Future<void> salvarToken(String token);

  /// Retorna o token salvo, ou `null` se não houver.
  Future<String?> obterToken();
}
