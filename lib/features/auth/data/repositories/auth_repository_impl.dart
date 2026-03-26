import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  @override
  Future<Usuario> autenticar({
    required String email,
    required String senha,
  }) async {
    final connected = await networkInfo.isConnected;
    if (!connected) {
      throw const NetworkFailure(message: 'Sem conexão com a internet');
    }

    try {
      final response = await remoteDatasource.login(
        email: email,
        senha: senha,
      );
      await localDatasource.salvarToken(response.token);

      try {
        final usuarioAtual = await remoteDatasource.getUsuarioAtual();
        await localDatasource.salvarUsuario(usuarioAtual);
        return usuarioAtual.toEntity();
      } on ServerException {
        final usuarioParcial = response.toUsuarioModel();
        await localDatasource.salvarUsuario(usuarioParcial);
        return usuarioParcial.toEntity();
      }
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  @override
  Future<Usuario?> obterUsuarioLogado() async {
    final token = await localDatasource.obterToken();
    if (token == null) return null;

    final connected = await networkInfo.isConnected;
    if (connected) {
      try {
        final model = await remoteDatasource.getUsuarioAtual();
        await localDatasource.salvarUsuario(model);
        return model.toEntity();
      } on ServerException {
        // Token inválido/expirado — limpar sessão
        await localDatasource.limparDados();
        return null;
      }
    }

    // Offline — retorna cache local
    final cachedUser = await localDatasource.obterUsuario();
    return cachedUser?.toEntity();
  }

  @override
  Future<void> logout() async {
    await localDatasource.limparDados();
  }

  @override
  Future<void> salvarToken(String token) async {
    await localDatasource.salvarToken(token);
  }

  @override
  Future<String?> obterToken() async {
    return localDatasource.obterToken();
  }
}
