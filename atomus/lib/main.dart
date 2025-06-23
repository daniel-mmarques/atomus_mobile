import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

import 'meu_aplicativo.dart';
import 'models/ticker/ticker_data.dart';
import 'package:atomus/models/local_storage.dart';
import 'package:atomus/repositories/broker_repository.dart';
import 'package:atomus/repositories/portfolio_repository.dart';
import 'package:atomus/repositories/product_repository.dart';
import 'package:atomus/repositories/search_repository.dart';
import 'package:atomus/repositories/trade_repository.dart';
import 'package:atomus/repositories/user_repository.dart';
import 'package:atomus/services/broker_service.dart';
import 'package:atomus/services/portfolio_service.dart';
import 'package:atomus/services/product_service.dart';
import 'package:atomus/services/search_service.dart';
import 'package:atomus/services/trade_service.dart';
import 'package:atomus/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TickerDataAdapter());

  final dio = await _initializeDio();
  final userId = await LocalStorage.getUserId();

  runApp(MyApp(dio: dio, userId: userId));
}

Future<Dio> _initializeDio() async {
  final token = await LocalStorage.getToken();
  return Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    ),
  );
}

class MyApp extends StatelessWidget {
  final Dio dio;
  final int? userId;

  const MyApp({super.key, required this.dio, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                SearchService(context.read<SearchRepository>())),
        Provider(create: (_) => PortfolioRepository(userId!, dio)),
        ChangeNotifierProvider(
            create: (context) =>
                PortfolioService(context.read<PortfolioRepository>())),
        Provider(create: (_) => TradeRepository(userId!, dio)),
        ChangeNotifierProvider(
            create: (context) => TradeService(context.read<TradeRepository>())),
        Provider(create: (_) => ProductRepository(dio)),
        ChangeNotifierProvider(
            create: (context) =>
                ProductService(context.read<ProductRepository>())),
        Provider(create: (_) => BrokerRepository(dio)),
        ChangeNotifierProvider(
            create: (context) =>
                BrokerService(context.read<BrokerRepository>())),
        Provider(create: (_) => UserRepository(dio)),
        ChangeNotifierProvider(
            create: (context) => UserService(context.read<UserRepository>())),
      ],
      child: MeuAplicativo(),
    );
  }
}
