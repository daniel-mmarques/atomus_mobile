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
          padding: EdgeInsets.all(8),
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
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF222531),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  widget.operacao.tradeType == 'COMPRA'
                      ? Icons.add_rounded
                      : Icons.remove_rounded,
                  color: widget.operacao.tradeType == 'COMPRA'
                      ? Color(0xFF16C784)
                      : Color(0xFFF23D4C),
                  size: 30,
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
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 30,
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
                    color: Color(0xFF363A4E),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
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
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Quantidade: ${widget.operacao.quantity}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Valor: R\$ ${(widget.operacao.unitPrice * widget.operacao.quantity).toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {},
                            iconSize: 25,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: widget.onDelete,
                            iconSize: 25,
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
