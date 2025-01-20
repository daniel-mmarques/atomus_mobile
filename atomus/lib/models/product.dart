class Product {
  final int id;
  final String name;
  final bool isCoveredFgc;

  Product({
    required this.id,
    required this.name,
    required this.isCoveredFgc,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      isCoveredFgc: json['coveredFgc'],
    );
  }
}
