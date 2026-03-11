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

import '../../features/atendimento/data/datasources/atendimento_local_datasource.dart'
    as _i802;
import '../../features/atendimento/domain/repositories/atendimento_repository.dart'
    as _i846;
import '../../features/atendimento/domain/usecases/atualizar_status_atendimento.dart'
    as _i824;
import '../../features/atendimento/domain/usecases/calcular_valor_estimado.dart'
    as _i343;
import '../../features/atendimento/domain/usecases/criar_atendimento.dart'
    as _i354;
import '../../features/atendimento/domain/usecases/listar_atendimentos.dart'
    as _i760;
import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/autenticar_usuario.dart' as _i446;
import '../../features/auth/domain/usecases/obter_usuario_logado.dart' as _i209;
import '../../features/base/data/datasources/base_local_datasource.dart'
    as _i221;
import '../../features/base/domain/repositories/base_repository.dart' as _i789;
import '../../features/base/domain/usecases/criar_base.dart' as _i28;
import '../../features/base/domain/usecases/definir_base_principal.dart'
    as _i437;
import '../../features/base/domain/usecases/listar_bases.dart' as _i307;
import '../../features/cliente/data/datasources/cliente_local_datasource.dart'
    as _i661;
import '../../features/cliente/domain/repositories/cliente_repository.dart'
    as _i37;
import '../../features/cliente/domain/usecases/atualizar_cliente.dart' as _i427;
import '../../features/cliente/domain/usecases/buscar_clientes.dart' as _i294;
import '../../features/cliente/domain/usecases/criar_cliente.dart' as _i829;
import '../../features/rastreamento/data/datasources/rastreamento_local_datasource.dart'
    as _i556;
import '../../features/rastreamento/domain/repositories/rastreamento_repository.dart'
    as _i22;
import '../../features/rastreamento/domain/usecases/calcular_valor_real.dart'
    as _i228;
import '../../features/rastreamento/domain/usecases/obter_percurso.dart'
    as _i906;
import '../../features/rastreamento/domain/usecases/registrar_ponto.dart'
    as _i844;
import '../database/app_database.dart' as _i982;
import '../geo/geo_service.dart' as _i643;
import '../geo/gps_collector.dart' as _i513;
import '../network/http_client.dart' as _i1069;
import '../network/network_info.dart' as _i932;
import '../network/network_info_impl.dart' as _i865;
import '../sync/sync_queue_datasource.dart' as _i145;
import '../utils/distance_calculator.dart' as _i11;
import 'modules/atendimento_module.dart' as _i460;
import 'modules/auth_module.dart' as _i4;
import 'modules/base_module.dart' as _i878;
import 'modules/cliente_module.dart' as _i763;
import 'modules/core_module.dart' as _i134;
import 'modules/database_module.dart' as _i664;
import 'modules/network_module.dart' as _i851;
import 'modules/rastreamento_module.dart' as _i237;

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
    final coreModule = _$CoreModule();
    final rastreamentoModule = _$RastreamentoModule();
    final authModule = _$AuthModule();
    final atendimentoModule = _$AtendimentoModule();
    final baseModule = _$BaseModule();
    final clienteModule = _$ClienteModule();
    gh.singleton<_i982.AppDatabase>(() => databaseModule.appDatabase);
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.singleton<_i895.Connectivity>(() => networkModule.connectivity);
    gh.singleton<_i558.FlutterSecureStorage>(() => networkModule.secureStorage);
    gh.lazySingleton<_i11.DistanceCalculator>(
        () => coreModule.distanceCalculator);
    gh.lazySingleton<_i643.GeoService>(() => coreModule.geoService);
    gh.lazySingleton<_i513.GpsCollector>(
        () => rastreamentoModule.gpsCollector());
    gh.lazySingleton<_i161.AuthRemoteDatasource>(
        () => authModule.authRemoteDatasource(gh<_i361.Dio>()));
    gh.lazySingleton<_i992.AuthLocalDatasource>(
        () => authModule.authLocalDatasource(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i343.CalcularValorEstimado>(() =>
        atendimentoModule.calcularValorEstimado(gh<_i11.DistanceCalculator>()));
    gh.lazySingleton<_i802.AtendimentoLocalDatasource>(() =>
        atendimentoModule.atendimentoLocalDatasource(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i221.BaseLocalDatasource>(
        () => baseModule.baseLocalDatasource(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i661.ClienteLocalDatasource>(
        () => clienteModule.clienteLocalDatasource(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i145.SyncQueueDatasource>(
        () => coreModule.syncQueueDatasource(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i556.RastreamentoLocalDatasource>(() => rastreamentoModule
        .rastreamentoLocalDatasource(gh<_i982.AppDatabase>()));
    gh.singleton<_i932.NetworkInfo>(
        () => _i865.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i787.AuthRepository>(() => authModule.authRepository(
          gh<_i161.AuthRemoteDatasource>(),
          gh<_i992.AuthLocalDatasource>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i846.AtendimentoRepository>(
        () => atendimentoModule.atendimentoRepository(
              gh<_i802.AtendimentoLocalDatasource>(),
              gh<_i145.SyncQueueDatasource>(),
            ));
    gh.lazySingleton<_i446.AutenticarUsuario>(
        () => authModule.autenticarUsuario(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i209.ObterUsuarioLogado>(
        () => authModule.obterUsuarioLogado(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i22.RastreamentoRepository>(
        () => rastreamentoModule.rastreamentoRepository(
              gh<_i556.RastreamentoLocalDatasource>(),
              gh<_i145.SyncQueueDatasource>(),
            ));
    gh.singleton<_i1069.HttpClient>(() => _i1069.HttpClient(
          gh<_i361.Dio>(),
          gh<_i558.FlutterSecureStorage>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i354.CriarAtendimento>(
        () => atendimentoModule.criarAtendimento(
              gh<_i846.AtendimentoRepository>(),
              gh<_i11.DistanceCalculator>(),
            ));
    gh.lazySingleton<_i37.ClienteRepository>(
        () => clienteModule.clienteRepository(
              gh<_i661.ClienteLocalDatasource>(),
              gh<_i145.SyncQueueDatasource>(),
            ));
    gh.lazySingleton<_i789.BaseRepository>(() => baseModule.baseRepository(
          gh<_i221.BaseLocalDatasource>(),
          gh<_i145.SyncQueueDatasource>(),
        ));
    gh.lazySingleton<_i228.CalcularValorReal>(
        () => rastreamentoModule.calcularValorReal(
              gh<_i22.RastreamentoRepository>(),
              gh<_i11.DistanceCalculator>(),
            ));
    gh.lazySingleton<_i760.ListarAtendimentos>(() => atendimentoModule
        .listarAtendimentos(gh<_i846.AtendimentoRepository>()));
    gh.lazySingleton<_i824.AtualizarStatusAtendimento>(() => atendimentoModule
        .atualizarStatusAtendimento(gh<_i846.AtendimentoRepository>()));
    gh.lazySingleton<_i844.RegistrarPonto>(() =>
        rastreamentoModule.registrarPonto(gh<_i22.RastreamentoRepository>()));
    gh.lazySingleton<_i906.ObterPercurso>(() =>
        rastreamentoModule.obterPercurso(gh<_i22.RastreamentoRepository>()));
    gh.lazySingleton<_i829.CriarCliente>(
        () => clienteModule.criarCliente(gh<_i37.ClienteRepository>()));
    gh.lazySingleton<_i294.BuscarClientes>(
        () => clienteModule.buscarClientes(gh<_i37.ClienteRepository>()));
    gh.lazySingleton<_i427.AtualizarCliente>(
        () => clienteModule.atualizarCliente(gh<_i37.ClienteRepository>()));
    gh.lazySingleton<_i28.CriarBase>(
        () => baseModule.criarBase(gh<_i789.BaseRepository>()));
    gh.lazySingleton<_i307.ListarBases>(
        () => baseModule.listarBases(gh<_i789.BaseRepository>()));
    gh.lazySingleton<_i437.DefinirBasePrincipal>(
        () => baseModule.definirBasePrincipal(gh<_i789.BaseRepository>()));
    return this;
  }
}

class _$DatabaseModule extends _i664.DatabaseModule {}

class _$NetworkModule extends _i851.NetworkModule {}

class _$CoreModule extends _i134.CoreModule {}

class _$RastreamentoModule extends _i237.RastreamentoModule {}

class _$AuthModule extends _i4.AuthModule {}

class _$AtendimentoModule extends _i460.AtendimentoModule {}

class _$BaseModule extends _i878.BaseModule {}

class _$ClienteModule extends _i763.ClienteModule {}
