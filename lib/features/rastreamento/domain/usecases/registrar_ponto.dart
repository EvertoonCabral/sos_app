import '../entities/ponto_rastreamento.dart';
import '../repositories/rastreamento_repository.dart';

/// Salva um ponto GPS no repositório local.
class RegistrarPonto {
  RegistrarPonto(this._repository);

  final RastreamentoRepository _repository;

  Future<void> call(PontoRastreamento ponto) async {
    await _repository.salvarPonto(ponto);
  }
}
