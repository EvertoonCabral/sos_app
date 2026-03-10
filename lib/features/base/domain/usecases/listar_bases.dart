import '../entities/base.dart';
import '../repositories/base_repository.dart';

class ListarBases {
  ListarBases(this._repository);

  final BaseRepository _repository;

  Future<List<Base>> call() async {
    return _repository.listarTodas();
  }
}
