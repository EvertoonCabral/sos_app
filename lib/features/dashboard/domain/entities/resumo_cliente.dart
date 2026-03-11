import 'package:equatable/equatable.dart';

/// Resumo de KM e atendimentos agrupados por cliente.
/// RN-038: ranking de clientes por número de atendimentos e KM gerado.
class ResumoCliente extends Equatable {
  const ResumoCliente({
    required this.clienteId,
    required this.clienteNome,
    required this.totalAtendimentos,
    required this.totalKm,
    required this.totalReceita,
  });

  final String clienteId;
  final String clienteNome;
  final int totalAtendimentos;
  final double totalKm;
  final double totalReceita;

  @override
  List<Object?> get props => [
        clienteId,
        clienteNome,
        totalAtendimentos,
        totalKm,
        totalReceita,
      ];
}
