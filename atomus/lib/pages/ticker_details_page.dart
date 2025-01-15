import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/ticker/ticker_details_data.dart';
import '../services/search_service.dart';

class TickerDetailsPage extends StatefulWidget {
  final String ticker;

  const TickerDetailsPage({super.key, required this.ticker});

  @override
  _TickerDetailsPageState createState() => _TickerDetailsPageState();
}

class _TickerDetailsPageState extends State<TickerDetailsPage> {
  late SearchService searchService;
  late TickerDetailsData tickerDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchService = Provider.of<SearchService>(context, listen: false);
    _fetchTickerDetails();
  }

  Future<void> _fetchTickerDetails() async {
    try {
      final details = await searchService.getTickerDetails(widget.ticker);
      if (!mounted) return;
      setState(() {
        tickerDetails = details;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os detalhes do ticker')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.network(
                  tickerDetails.logourl,
                  height: 70,
                  width: 70,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tickerDetails.symbol,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      tickerDetails.longName,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Espaçamento abaixo da logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preço Atual: R\$ ${tickerDetails.regularMarketPrice}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Row(children: [
                  Text(
                    'Variação: ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    '${tickerDetails.regularMarketChange > 0 ? '+' : ''}${tickerDetails.regularMarketChangePercent}%',
                    style: TextStyle(
                      fontSize: 18,
                      color: tickerDetails.regularMarketChange > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ]),
                Text(
                  'Market Cap: R\$ ${tickerDetails.marketCap}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'Volume de Mercado: ${tickerDetails.regularMarketVolume}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'High: ${tickerDetails.regularMarketDayHigh}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'Low: ${tickerDetails.regularMarketDayLow}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'EarningsPerShare: ${tickerDetails.earningsPerShare}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
