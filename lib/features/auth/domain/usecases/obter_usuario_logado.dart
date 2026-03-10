import '../entities/usuario.dart';
import '../repositories/auth_repository.dart';

class ObterUsuarioLogado {
  ObterUsuarioLogado(this._repository);

  final AuthRepository _repository;

  Future<Usuario?> call() async {
    return _repository.obterUsuarioLogado();
  }
}
