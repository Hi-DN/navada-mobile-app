import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';

class CompleteExchangeProvider extends ChangeNotifier {
  CompleteExchangeProvider(this._userId);

  final int _userId;

  final ExchangeService _exchangeService = ExchangeService();
}