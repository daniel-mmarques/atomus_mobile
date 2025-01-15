import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();

  String _tradeType = '';
  DateTime _tradeDate = DateTime.now();
  int? _brokerId;
  int? _productId;

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _feesController.dispose();
    super.dispose();
  }

  void saveTrade() {
    if (_form.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Negociação salva com sucesso!")),
      );
      _form.currentState!.reset();
      _titleController.clear();
      _quantityController.clear();
      _unitPriceController.clear();
      _feesController.clear();
      setState(() {
        _tradeType = '';
        _tradeDate = DateTime.now();
      });
    }
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Informe $fieldName";
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return "$fieldName deve ser um número válido e maior que zero";
    }
    return null;
  }

  Widget _buildDatePicker() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Data da Negociação",
        hintText: DateFormat.yMd().format(_tradeDate),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _tradeDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              setState(() => _tradeDate = selectedDate);
            }
          },
        ),
      ),
      validator: (value) {
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                value: _brokerId,
                decoration: const InputDecoration(labelText: "Corretora"),
                items: [
                  DropdownMenuItem(value: 1, child: Text("Corretora A")),
                  DropdownMenuItem(value: 2, child: Text("Corretora B")),
                ],
                onChanged: (value) {
                  setState(() {
                    _brokerId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Selecione uma corretora";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _productId,
                decoration: const InputDecoration(labelText: "Produto"),
                items: [
                  DropdownMenuItem(value: 1, child: Text("Produto X")),
                  DropdownMenuItem(value: 2, child: Text("Produto Y")),
                ],
                onChanged: (value) {
                  setState(() {
                    _productId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Selecione um produto";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _tradeType = "BUY");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _tradeType == "BUY" ? Colors.green : Colors.grey,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add_shopping_cart, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Buy",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _tradeType = "SELL");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _tradeType == "SELL" ? Colors.red : Colors.grey,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.remove_shopping_cart, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Sell",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o título";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                    labelText: "Quantidade", hintText: "Ex.: 100"),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, "a quantidade"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitPriceController,
                decoration: const InputDecoration(
                    labelText: "Preço Unitário", hintText: "Ex.: 25.50"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    _validateNumber(value, "o preço unitário"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feesController,
                decoration: const InputDecoration(
                    labelText: "Taxas", hintText: "Ex.: 5.00"),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, "as taxas"),
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveTrade,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
