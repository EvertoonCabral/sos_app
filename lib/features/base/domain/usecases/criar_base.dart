import '../../../../core/error/failures.dart';
import '../entities/base.dart';
import '../repositories/base_repository.dart';

class CriarBase {
  CriarBase(this._repository);

  final BaseRepository _repository;

  Future<Base> call(Base base) async {
    if (base.nome.trim().isEmpty) {
      throw const ValidationFailure(message: 'Nome da base é obrigatório');
    }
    return _repository.criar(base);
  }
}
