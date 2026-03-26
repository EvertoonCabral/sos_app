import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../../features/auth/data/datasources/usuario_local_datasource.dart';
import '../../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/usecases/autenticar_usuario.dart';
import '../../../features/auth/domain/usecases/obter_usuario_logado.dart';
import '../../database/app_database.dart';
import '../../network/network_info.dart';

@module
abstract class AuthModule {
  @lazySingleton
  AuthLocalDatasource authLocalDatasource(
    FlutterSecureStorage secureStorage,
  ) =>
      AuthLocalDatasourceImpl(secureStorage);

  @lazySingleton
  UsuarioLocalDatasource usuarioLocalDatasource(AppDatabase db) =>
      UsuarioLocalDatasourceImpl(db);

  @lazySingleton
  AuthRemoteDatasource authRemoteDatasource(Dio dio) =>
      AuthRemoteDatasourceImpl(dio);

  @lazySingleton
  AuthRepository authRepository(
    AuthRemoteDatasource remoteDatasource,
    AuthLocalDatasource localDatasource,
    NetworkInfo networkInfo,
  ) =>
      AuthRepositoryImpl(
        remoteDatasource: remoteDatasource,
        localDatasource: localDatasource,
        networkInfo: networkInfo,
      );

  @lazySingleton
  AutenticarUsuario autenticarUsuario(AuthRepository repository) =>
      AutenticarUsuario(repository);

  @lazySingleton
  ObterUsuarioLogado obterUsuarioLogado(AuthRepository repository) =>
      ObterUsuarioLogado(repository);
}
