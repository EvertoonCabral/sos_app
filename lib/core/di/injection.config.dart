// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/autenticar_usuario.dart' as _i446;
import '../../features/auth/domain/usecases/obter_usuario_logado.dart' as _i209;
import '../database/app_database.dart' as _i982;
import '../network/http_client.dart' as _i1069;
import '../network/network_info.dart' as _i932;
import '../network/network_info_impl.dart' as _i865;
import 'modules/auth_module.dart' as _i4;
import 'modules/database_module.dart' as _i664;
import 'modules/network_module.dart' as _i851;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final databaseModule = _$DatabaseModule();
    final networkModule = _$NetworkModule();
    final authModule = _$AuthModule();
    gh.singleton<_i982.AppDatabase>(() => databaseModule.appDatabase);
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.singleton<_i895.Connectivity>(() => networkModule.connectivity);
    gh.singleton<_i558.FlutterSecureStorage>(() => networkModule.secureStorage);
    gh.lazySingleton<_i161.AuthRemoteDatasource>(
        () => authModule.authRemoteDatasource(gh<_i361.Dio>()));
    gh.lazySingleton<_i992.AuthLocalDatasource>(
        () => authModule.authLocalDatasource(gh<_i558.FlutterSecureStorage>()));
    gh.singleton<_i932.NetworkInfo>(
        () => _i865.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i787.AuthRepository>(() => authModule.authRepository(
          gh<_i161.AuthRemoteDatasource>(),
          gh<_i992.AuthLocalDatasource>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i446.AutenticarUsuario>(
        () => authModule.autenticarUsuario(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i209.ObterUsuarioLogado>(
        () => authModule.obterUsuarioLogado(gh<_i787.AuthRepository>()));
    gh.singleton<_i1069.HttpClient>(() => _i1069.HttpClient(
          gh<_i361.Dio>(),
          gh<_i558.FlutterSecureStorage>(),
          gh<_i932.NetworkInfo>(),
        ));
    return this;
  }
}

class _$DatabaseModule extends _i664.DatabaseModule {}

class _$NetworkModule extends _i851.NetworkModule {}

class _$AuthModule extends _i4.AuthModule {}
