import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_model.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';

class CompleteExchangeProvider extends ChangeNotifier {

  final ExchangeService _exchangeService = ExchangeService();

  completeExchange(int? exchangeId, bool isAcceptor, bool hasConfirmedRating, double rating) async {
    if(hasConfirmedRating) {
      ExchangeModel? res = await _exchangeService.rateExchange(exchangeId!, isAcceptor, rating);
      if(res != null) _exchangeService.completeExchange(exchangeId, isAcceptor);
    } else {
      _exchangeService.completeExchange(exchangeId!, isAcceptor);
    }
  }
}