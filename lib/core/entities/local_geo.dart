import 'package:equatable/equatable.dart';

/// Value Object reutilizável para coordenadas + endereço textual.
class LocalGeo extends Equatable {
  const LocalGeo({
    required this.enderecoTexto,
    required this.latitude,
    required this.longitude,
    this.complemento,
  });

  final String enderecoTexto;
  final double latitude;
  final double longitude;
  final String? complemento;

  @override
  List<Object?> get props => [enderecoTexto, latitude, longitude, complemento];
}
