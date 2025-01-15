class TickerDetailsData {
  final String symbol;
  final String longName;
  final int marketCap;
  final double regularMarketPrice;
  final double regularMarketChange;
  final double regularMarketChangePercent;
  final double twoHundredDayAverage;
  final double twoHundredDayAverageChange;
  final double twoHundredDayAverageChangePercent;
  final double regularMarketDayHigh;
  final double regularMarketDayLow;
  final int regularMarketVolume;
  final double earningsPerShare;
  final String logourl;
  final String regularMarketTime;

  TickerDetailsData({
    required this.symbol,
    required this.longName,
    required this.marketCap,
    required this.regularMarketPrice,
    required this.regularMarketChange,
    required this.regularMarketChangePercent,
    required this.twoHundredDayAverage,
    required this.twoHundredDayAverageChange,
    required this.twoHundredDayAverageChangePercent,
    required this.regularMarketDayHigh,
    required this.regularMarketDayLow,
    required this.regularMarketVolume,
    required this.earningsPerShare,
    required this.logourl,
    required this.regularMarketTime,
  });

  factory TickerDetailsData.fromJson(Map<String, dynamic> json) {
    return TickerDetailsData(
      symbol: json['symbol'] as String,
      longName: json['longName'] as String,
      marketCap: json['marketCap'] as int,
      regularMarketPrice: (json['regularMarketPrice'] as num).toDouble(),
      regularMarketChange: (json['regularMarketChange'] as num).toDouble(),
      regularMarketChangePercent:
          (json['regularMarketChangePercent'] as num).toDouble(),
      twoHundredDayAverage: (json['twoHundredDayAverage'] as num).toDouble(),
      twoHundredDayAverageChange:
          (json['twoHundredDayAverageChange'] as num).toDouble(),
      twoHundredDayAverageChangePercent:
          (json['twoHundredDayAverageChangePercent'] as num).toDouble(),
      regularMarketDayHigh: (json['regularMarketDayHigh'] as num).toDouble(),
      regularMarketDayLow: (json['regularMarketDayLow'] as num).toDouble(),
      regularMarketVolume: json['regularMarketVolume'] as int,
      earningsPerShare: (json['earningsPerShare'] as num).toDouble(),
      logourl: json['logourl'] as String,
      regularMarketTime: json['regularMarketTime'] as String,
    );
  }
}
