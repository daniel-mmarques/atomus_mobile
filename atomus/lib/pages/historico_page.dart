import 'package:atomus/services/trade_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/history_item.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  @override
  void initState() {
    super.initState();
    context.read<TradeService>().loadTradesAfterBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              'Lista de Transações',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          // Usando ListView diretamente sem SingleChildScrollView
          Expanded(
            child: HistoryItem(),
          ),
        ],
      ),
    );
  }
}
