class PortfolioTickerData {
  final String title;
  final double totalAmount;
  final int quantity;
  final double averagePrice;
  final double regularMarketPrice;
  final double profitability;

  PortfolioTickerData({
    required this.title,
    required this.totalAmount,
    required this.quantity,
    required this.averagePrice,
    required this.regularMarketPrice,
    required this.profitability,
  });

  factory PortfolioTickerData.fromJson(Map<String, dynamic> json) {
    return PortfolioTickerData(
      title: json['title'],
      totalAmount: json['totalAmount'],
      quantity: json['quantity'],
      averagePrice: json['averagePrice'],
      regularMarketPrice: json['regularMarketPrice'],
      profitability: json['profitability'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'totalAmount': totalAmount,
      'quantity': quantity,
      'averagePrice': averagePrice,
      'regularMarketPrice': regularMarketPrice,
      'profitability': profitability,
    };
  }
}
