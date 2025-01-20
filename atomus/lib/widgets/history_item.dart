import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trade.dart';
import '../services/trade_service.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TradeService>(
      builder: (context, tradeService, child) {
        if (tradeService.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (tradeService.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar histórico: ${tradeService.errorMessage}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (tradeService.trades.isEmpty) {
          return Center(
            child: Text(
              'Nenhum histórico encontrado.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final date = DateFormat('dd/MM/yyyy');

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: tradeService.trades.length,
          itemBuilder: (context, index) {
            final operacao = tradeService.trades[index];
            return TradeItem(
              operacao: operacao,
              date: date,
              onDelete: () => tradeService.deleteTrade(operacao.id!),
            );
          },
        );
      },
    );
  }
}

class TradeItem extends StatefulWidget {
  final Trade operacao;
  final DateFormat date;
  final VoidCallback onDelete;

  const TradeItem({
    required this.operacao,
    required this.date,
    required this.onDelete,
    super.key,
  });

  @override
  _TradeItemState createState() => _TradeItemState();
}

class _TradeItemState extends State<TradeItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ListTile(
                tileColor: Colors.black26,
                leading: Icon(
                  widget.operacao.tradeType == 'COMPRA'
                      ? Icons.add
                      : Icons.remove,
                  color: widget.operacao.tradeType == 'COMPRA'
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(
                  '${widget.operacao.quantity}x ${widget.operacao.title}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  widget.date.format(widget.operacao.tradeDate),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ),
              if (isExpanded) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preço: R\$ ${widget.operacao.unitPrice.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Quantidade: ${widget.operacao.quantity}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Valor: R\$ ${(widget.operacao.unitPrice * widget.operacao.quantity).toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: widget.onDelete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
