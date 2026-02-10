class CategoryTrendModel {
  final String categoria;
  final String mes;
  final int quantidade;

  CategoryTrendModel({
    required this.categoria,
    required this.mes,
    required this.quantidade,
  });

  factory CategoryTrendModel.fromJson(Map<String, dynamic> json) {
    return CategoryTrendModel(
      categoria: json['categoria'] ?? 'Outros',
      mes: json['mes'] ?? '',
      quantidade: (json['qtd_comprada'] as num?)?.toInt() ?? 0,
    );
  }
}