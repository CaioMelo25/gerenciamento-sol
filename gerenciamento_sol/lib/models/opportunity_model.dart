class OpportunityModel {
  final String nome;
  final String categoria;
  final int totalCompras;
  final int diasParado;
  final String status;
  final String dica;

  OpportunityModel({
    required this.nome,
    required this.categoria,
    required this.totalCompras,
    required this.diasParado,
    required this.status,
    required this.dica,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      nome: json['nome_natura'] ?? '',
      categoria: json['categoria'] ?? '',
      totalCompras: json['total_compras'] ?? 0,
      diasParado: json['dias_parado'] ?? 0,
      status: json['status_investimento'] ?? '',
      dica: json['dica_texto'] ?? '',
    );
  }
}