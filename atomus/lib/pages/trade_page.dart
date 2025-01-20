import 'package:atomus/models/broker.dart';
import 'package:atomus/models/product.dart';
import 'package:atomus/pages/portfolio_page.dart';
import 'package:atomus/services/broker_service.dart';
import 'package:atomus/services/product_service.dart';
import 'package:atomus/services/trade_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();

  String _tradeType = '';
  DateTime _tradeDate = DateTime.now();
  int? _brokerId;
  int? _productId;

  late Future<List<Broker>> _brokers;
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    final brokerService = Provider.of<BrokerService>(context, listen: false);
    final productService = Provider.of<ProductService>(context, listen: false);
    _brokers = brokerService.getAll();
    _products = productService.getAll();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _feesController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Informe $fieldName.";
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return "$fieldName deve ser um número válido e maior que zero.";
    }
    return null;
  }

  void _saveTrade() async {
    if (_tradeType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione o tipo de negociação.")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final tradeService = Provider.of<TradeService>(context, listen: false);

      try {
        await tradeService.saveTrade(
          tradeType: _tradeType,
          tradeDate: _tradeDate,
          brokerId: _brokerId!,
          productId: _productId!,
          title: _titleController.text,
          quantity: int.parse(_quantityController.text),
          unitPrice: double.parse(_unitPriceController.text),
          fees: double.parse(_feesController.text),
        );

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.black,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'lib/animations/checkAnimation.json',
                    backgroundLoading: true,
                    width: 150,
                    height: 150,
                    repeat: false,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Negociação salva com sucesso!",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            );
          },
        );

        // Aguarda 2 segundos e redireciona para PortfolioPage
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context); // Fecha o diálogo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PortfolioPage()),
        );
      } catch (e) {
        // Mostra mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar: $e")),
        );
      }
    }
  }

  Widget _buildDatePicker() {
    return TextFormField(
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Data da Negociação",
        labelStyle: const TextStyle(color: Colors.white),
        hintText: DateFormat.yMd().format(_tradeDate),
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _tradeDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    dialogBackgroundColor: Colors.black,
                    textTheme: const TextTheme(
                      bodyMedium: TextStyle(color: Colors.white),
                    ),
                    colorScheme: ColorScheme.dark(
                      primary: Colors.teal,
                      onPrimary: Colors.black,
                      surface: Colors.grey[900]!,
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selectedDate != null) {
              setState(() => _tradeDate = selectedDate);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBrokerDropdown() {
    return FutureBuilder<List<Broker>>(
      future: _brokers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        final brokers = snapshot.data ?? [];

        return DropdownButtonFormField<int>(
          value: _brokerId,
          decoration: InputDecoration(
            labelText: 'Corretora',
            labelStyle: const TextStyle(color: Colors.white),
          ),
          items: brokers.map((broker) {
            return DropdownMenuItem<int>(
              value: broker.id,
              child: Text(broker.name),
            );
          }).toList(),
          onChanged: (value) => setState(() => _brokerId = value),
          validator: (value) =>
              value == null ? 'Selecione uma corretora' : null,
        );
      },
    );
  }

  Widget _buildProductDropdown() {
    return FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        final products = snapshot.data ?? [];

        return DropdownButtonFormField<int>(
          value: _productId,
          decoration: InputDecoration(
            labelText: 'Produto',
            labelStyle: const TextStyle(color: Colors.white),
          ),
          items: products.map((product) {
            return DropdownMenuItem<int>(
              value: product.id,
              child: Text(product.name),
            );
          }).toList(),
          onChanged: (value) => setState(() => _productId = value),
          validator: (value) => value == null ? 'Selecione um produto' : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Negociação"),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      width: _tradeType == "COMPRA" ? 200 : 150,
                      height: 55,
                      decoration: BoxDecoration(
                        color: _tradeType == "COMPRA"
                            ? Colors.green
                            : Colors.grey[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _tradeType = "COMPRA");
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add_rounded,
                                  color: Colors.white, size: 30),
                              SizedBox(width: 6),
                              Text("COMPRA",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      width: _tradeType == "VENDA" ? 200 : 150,
                      height: 55,
                      decoration: BoxDecoration(
                        color: _tradeType == "VENDA"
                            ? Colors.red
                            : Colors.grey[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _tradeType = "VENDA");
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.remove_rounded,
                                  color: Colors.white, size: 30),
                              SizedBox(width: 6),
                              Text("VENDA",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProductDropdown(),
                const SizedBox(height: 16),
                _buildBrokerDropdown(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Título"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Informe o título"
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: "Quantidade"),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateField(value, "a quantidade"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitPriceController,
                  decoration:
                      const InputDecoration(labelText: "Preço Unitário"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      _validateField(value, "o preço unitário"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _feesController,
                  decoration: const InputDecoration(labelText: "Taxas"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveTrade,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
