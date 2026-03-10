import '../entities/atendimento.dart';
import '../entities/atendimento_enums.dart';
import '../repositories/atendimento_repository.dart';

/// RN: listar atendimentos com filtro opcional por status.
class ListarAtendimentos {
  ListarAtendimentos(this._repository);

  final AtendimentoRepository _repository;

  Future<List<Atendimento>> call({AtendimentoStatus? status}) async {
    return _repository.listar(status: status);
  }
}
