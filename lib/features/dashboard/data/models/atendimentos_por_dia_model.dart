class AtendimentosPorDiaModel {
  const AtendimentosPorDiaModel({
    required this.data,
    required this.quantidade,
  });

  factory AtendimentosPorDiaModel.fromJson(Map<String, dynamic> json) {
    return AtendimentosPorDiaModel(
      data: DateTime.parse(json['data'] as String),
      quantidade: json['quantidade'] as int,
    );
  }

  final DateTime data;
  final int quantidade;
}
