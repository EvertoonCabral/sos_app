// Falhas tipadas retornadas via Either<Failure, T> nas camadas Domain e Presentation.
// Nunca lançar exceções — usar Failure para erros esperados.

abstract class Failure {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}
