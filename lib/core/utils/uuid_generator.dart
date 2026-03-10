import 'package:uuid/uuid.dart';

/// Gera UUIDs v4 para IDs locais.
class UuidGenerator {
  static const _uuid = Uuid();

  /// Gera um novo UUID v4.
  static String generate() => _uuid.v4();
}
