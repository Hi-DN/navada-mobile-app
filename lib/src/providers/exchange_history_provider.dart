import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_page_response.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';

import '../models/exchange/exchange_dto_model.dart';

class ExchangeHistoryProvider extends ChangeNotifier {
  final ExchangeService _exchangeService = ExchangeService();

  ExchangeDtoPageResponse? _exchangeDtoPageResponse;
  ExchangeDtoPageResponse? get exchangeDtoPageResponse =>
      _exchangeDtoPageResponse;

  List<ExchangeDtoModel>? _exchangeHistoryList = [];
  List<ExchangeDtoModel>? get exchangeHistoryList => _exchangeHistoryList;

  int? _totalElements;
  int? get totalElements => _totalElements;

  fetchExchangeHistory(userId) async {
    String exchangeStatus = "2";
    ExchangeDtoPageResponse? response =
        await _exchangeService.getExchangeList(userId, exchangeStatus, 0);

    _exchangeDtoPageResponse = response;
    _exchangeHistoryList = _exchangeDtoPageResponse?.content;
    _totalElements = _exchangeDtoPageResponse?.totalElements;

    notifyListeners();
  }
}
