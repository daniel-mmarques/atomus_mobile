class Broker {
  final int id;
  final String name;
  final String cnpj;

  Broker({
    required this.id,
    required this.name,
    required this.cnpj,
  });

  factory Broker.fromJson(Map<String, dynamic> json) {
    return Broker(
      id: json['id'],
      name: json['name'],
      cnpj: json['cnpj'],
    );
  }
}
