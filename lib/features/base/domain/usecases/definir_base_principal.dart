import '../../../../core/error/failures.dart';
import '../entities/base.dart';
import '../repositories/base_repository.dart';

class DefinirBasePrincipal {
  DefinirBasePrincipal(this._repository);

  final BaseRepository _repository;

  Future<Base> call(String baseId) async {
    if (baseId.trim().isEmpty) {
      throw const ValidationFailure(message: 'ID da base é obrigatório');
    }
    return _repository.definirPrincipal(baseId);
  }
}
