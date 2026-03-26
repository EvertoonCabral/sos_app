import '../../domain/entities/resumo_cliente.dart';

class ResumoClienteModel {
  const ResumoClienteModel({
    required this.clienteId,
    required this.clienteNome,
    required this.totalAtendimentos,
    required this.totalKm,
    required this.totalReceita,
  });

  factory ResumoClienteModel.fromJson(Map<String, dynamic> json) {
    return ResumoClienteModel(
      clienteId: json['clienteId'] as String,
      clienteNome: json['clienteNome'] as String,
      totalAtendimentos: json['totalAtendimentos'] as int,
      totalKm: (json['totalKm'] as num).toDouble(),
      totalReceita: (json['totalReceita'] as num).toDouble(),
    );
  }

  final String clienteId;
  final String clienteNome;
  final int totalAtendimentos;
  final double totalKm;
  final double totalReceita;

  ResumoCliente toEntity() => ResumoCliente(
        clienteId: clienteId,
        clienteNome: clienteNome,
        totalAtendimentos: totalAtendimentos,
        totalKm: totalKm,
        totalReceita: totalReceita,
      );
}
