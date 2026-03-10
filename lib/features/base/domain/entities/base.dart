import 'package:equatable/equatable.dart';

import '../../../../core/entities/local_geo.dart';

class Base extends Equatable {
  const Base({
    required this.id,
    required this.nome,
    required this.local,
    this.isPrincipal = false,
    required this.criadoEm,
    this.sincronizadoEm,
  });

  final String id;
  final String nome;
  final LocalGeo local;
  final bool isPrincipal;
  final DateTime criadoEm;
  final DateTime? sincronizadoEm;

  Base copyWith({
    String? nome,
    LocalGeo? local,
    bool? isPrincipal,
    DateTime? sincronizadoEm,
  }) {
    return Base(
      id: id,
      nome: nome ?? this.nome,
      local: local ?? this.local,
      isPrincipal: isPrincipal ?? this.isPrincipal,
      criadoEm: criadoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nome,
        local,
        isPrincipal,
        criadoEm,
        sincronizadoEm,
      ];
}
