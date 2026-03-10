import '../entities/base.dart';

abstract class BaseRepository {
  Future<Base> criar(Base base);
  Future<List<Base>> listarTodas();
  Future<Base> definirPrincipal(String baseId);
}
