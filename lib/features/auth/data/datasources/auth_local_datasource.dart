import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/usuario_model.dart';

/// Datasource local para dados de autenticação.
/// Usa [FlutterSecureStorage] para persistir token e dados do usuário.
abstract class AuthLocalDatasource {
  Future<void> salvarToken(String token);
  Future<String?> obterToken();
  Future<void> salvarUsuario(UsuarioModel usuario);
  Future<UsuarioModel?> obterUsuario();
  Future<void> limparDados();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  AuthLocalDatasourceImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _tokenKey = 'auth_token';
  static const _usuarioKey = 'auth_usuario';

  @override
  Future<void> salvarToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> obterToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> salvarUsuario(UsuarioModel usuario) async {
    final json = jsonEncode(usuario.toJson());
    await _secureStorage.write(key: _usuarioKey, value: json);
  }

  @override
  Future<UsuarioModel?> obterUsuario() async {
    final json = await _secureStorage.read(key: _usuarioKey);
    if (json == null) return null;
    return UsuarioModel.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> limparDados() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _usuarioKey);
  }
}
