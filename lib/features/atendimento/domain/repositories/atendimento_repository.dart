import '../entities/atendimento.dart';
import '../entities/atendimento_enums.dart';

abstract class AtendimentoRepository {
  Future<Atendimento> criar(Atendimento atendimento);
  Future<List<Atendimento>> listar({AtendimentoStatus? status});
  Future<Atendimento> obterPorId(String id);
  Future<Atendimento> atualizar(Atendimento atendimento);
  Future<Atendimento> atualizarStatus(Atendimento atendimento);
}
