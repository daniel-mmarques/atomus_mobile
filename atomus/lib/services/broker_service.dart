import 'package:atomus/models/broker.dart';
import 'package:atomus/repositories/broker_repository.dart';
import 'package:flutter/material.dart';

class BrokerService extends ChangeNotifier {
  final BrokerRepository _brokerRepository;

  BrokerService(this._brokerRepository);

  Future<List<Broker>> getAll() async {
    return _brokerRepository.getAll();
  }
}
