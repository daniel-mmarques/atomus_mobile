import 'package:hive/hive.dart';

part '../adapters/ticker_data.g.dart';

@HiveType(typeId: 0)
class TickerData {
  @HiveField(0)
  String stock;

  @HiveField(1)
  String name;

  @HiveField(2)
  double close;

  @HiveField(3)
  double change;

  @HiveField(4)
  int volume;

  @HiveField(5)
  double marketCap;

  @HiveField(6)
  String logo;

  @HiveField(7)
  String sector;

  @HiveField(8)
  String type;

  TickerData({
    required this.stock,
    required this.name,
    required this.close,
    required this.change,
    required this.volume,
    required this.marketCap,
    required this.logo,
    required this.sector,
    required this.type,
  });
}
