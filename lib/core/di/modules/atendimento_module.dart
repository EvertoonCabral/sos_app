import 'package:injectable/injectable.dart';

import '../../../features/atendimento/data/datasources/atendimento_local_datasource.dart';
import '../../../features/atendimento/data/repositories/atendimento_repository_impl.dart';
import '../../../features/atendimento/domain/repositories/atendimento_repository.dart';
import '../../../features/atendimento/domain/usecases/atualizar_status_atendimento.dart';
import '../../../features/atendimento/domain/usecases/calcular_valor_estimado.dart';
import '../../../features/atendimento/domain/usecases/criar_atendimento.dart';
import '../../../features/atendimento/domain/usecases/listar_atendimentos.dart';
import '../../../features/rastreamento/domain/usecases/calcular_valor_real.dart';
import '../../database/app_database.dart';
import '../../sync/sync_queue_datasource.dart';
import '../../utils/distance_calculator.dart';

@module
abstract class AtendimentoModule {
  @lazySingleton
  AtendimentoLocalDatasource atendimentoLocalDatasource(AppDatabase db) =>
      AtendimentoLocalDatasourceImpl(db);

  @lazySingleton
  AtendimentoRepository atendimentoRepository(
    AtendimentoLocalDatasource localDatasource,
    SyncQueueDatasource syncQueue,
  ) =>
      AtendimentoRepositoryImpl(
        localDatasource: localDatasource,
        syncQueue: syncQueue,
      );

  @lazySingleton
  CriarAtendimento criarAtendimento(
    AtendimentoRepository repository,
    DistanceCalculator calculator,
  ) =>
      CriarAtendimento(repository, calculator);

  @lazySingleton
  ListarAtendimentos listarAtendimentos(AtendimentoRepository repository) =>
      ListarAtendimentos(repository);

  @lazySingleton
  AtualizarStatusAtendimento atualizarStatusAtendimento(
    AtendimentoRepository repository,
    CalcularValorReal calcularValorReal,
  ) =>
      AtualizarStatusAtendimento(repository, calcularValorReal);

  @lazySingleton
  CalcularValorEstimado calcularValorEstimado(
    DistanceCalculator calculator,
  ) =>
      CalcularValorEstimado(calculator);
}
