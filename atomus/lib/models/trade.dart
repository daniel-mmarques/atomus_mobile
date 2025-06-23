class Trade {
  final int? id;
  final int userId;
  final String tradeType;
  final DateTime tradeDate;
  final int brokerId;
  final int productId;
  final String title;
  final int quantity;
  final double unitPrice;
  final double fees;

  Trade({
    this.id,
    required this.userId,
    required this.tradeType,
    required this.tradeDate,
    required this.brokerId,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.fees,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id'],
      userId: json['userId'],
      tradeType: json['tradeType'],
      tradeDate: DateTime.parse(json['tradeDate']),
      brokerId: json['brokerId'],
      productId: json['productId'],
      title: json['title'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      fees: json['fees'].toDouble(),
    );
  }
}
