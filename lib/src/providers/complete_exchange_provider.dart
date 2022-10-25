import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_page_model.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';

class CompleteExchangeProvider extends ChangeNotifier {
  final ExchangeService _exchangeService = ExchangeService();

  Future<Exchange?> completeExchange(int? exchangeId, bool isAcceptor, bool hasConfirmedRating,
      double rating) async {
    if (hasConfirmedRating) {
      Exchange? res =
          await _exchangeService.rateExchange(exchangeId!, isAcceptor, rating);
      if (res != null) {
        return _exchangeService.completeExchange(exchangeId, isAcceptor);
      }
    } else {
      return _exchangeService.completeExchange(exchangeId!, isAcceptor);
    }
    return null;
  }
}
