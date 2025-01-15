class Trade {
  int id;
  int userId;
  String tradeType;
  DateTime tradeDate;
  int brokerId;
  int productId;
  String title;
  int quantity;
  double unitPrice;
  double fees;

  Trade({
    required this.id,
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
