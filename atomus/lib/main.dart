import 'package:atomus/repositories/portfolio_repository.dart';
import 'package:atomus/repositories/search_repository.dart';
import 'package:atomus/repositories/trade_repository.dart';
import 'package:atomus/services/search_service.dart';
import 'package:atomus/services/trade_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'meu_aplicativo.dart';
import 'models/ticker/ticker_data.dart';
import 'services/portfolio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TickerDataAdapter());

  final dio = _initializeDio();
  final int userId = 7;

  runApp(
    MultiProvider(
      providers: [
        Provider<SearchRepository>(create: (_) => SearchRepository(dio)),
        ChangeNotifierProvider<SearchService>(
          create: (context) => SearchService(context.read<SearchRepository>()),
        ),
        Provider(create: (_) => PortfolioRepository(userId, dio)),
        ChangeNotifierProvider(
          create: (context) =>
              PortfolioService(context.read<PortfolioRepository>()),
        ),
        Provider(create: (_) => TradeRepository(userId, dio)),
        ChangeNotifierProvider(
          create: (context) => TradeService(context.read<TradeRepository>()),
        ),
      ],
      child: MeuAplicativo(),
    ),
  );
}

Dio _initializeDio() {
  return Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080',
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUEkgQXRvbXVzIiwic3ViIjoicmFmYWVsQGdtYWlsLmNvbSIsImV4cCI6MTczNzA1Nzg0OX0.Z303K47ZWtFzICqdpjQfgmntMCsMRP5d_qhyAkClt5U'
    },
  ));
}
