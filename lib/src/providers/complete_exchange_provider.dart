import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';

class CompleteExchangeProvider extends ChangeNotifier {

  final ExchangeService _exchangeService = ExchangeService();

  rateExchange(int? exchangeId, bool isAcceptor, double rating) {
    _exchangeService.rateExchange(exchangeId!, isAcceptor, rating);
  }

  completeExchange(int? exchangeId, bool isAcceptor) {
    _exchangeService.completeExchange(exchangeId!, isAcceptor);
  }
}