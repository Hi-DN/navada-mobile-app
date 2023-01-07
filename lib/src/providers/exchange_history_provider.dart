import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_page_response.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';
import 'package:navada_mobile_app/src/providers/page_provider.dart';

import '../models/exchange/exchange_dto_model.dart';

class ExchangeHistoryProvider with ChangeNotifier, PageProvider {
  final ExchangeService _exchangeService = ExchangeService();
  static const String exchangeStatus = "2";

  ExchangeDtoPageResponse? _exchangeDtoPageResponse;
  ExchangeDtoPageResponse? get exchangeDtoPageResponse =>
      _exchangeDtoPageResponse;

  List<ExchangeDtoModel>? _exchangeHistoryList = [];
  List<ExchangeDtoModel>? get exchangeHistoryList => _exchangeHistoryList;

  int? _totalElements;
  int? get totalElements => _totalElements;

  fetchExchangeHistory(userId) async {
    ExchangeDtoPageResponse? response = await _exchangeService.getExchangeList(
        userId, exchangeStatus, super.currPage!);

    _exchangeDtoPageResponse = response;
    _exchangeHistoryList = _exchangeDtoPageResponse?.content;
    _totalElements = _exchangeDtoPageResponse?.totalElements;
    super.setLast(response!.last!);

    notifyListeners();
  }

  void fetchMoreData(userId) async {
    if (!super.last) {
      super.setCurrPage(super.currPage! + 1);

      ExchangeDtoPageResponse? response = await _exchangeService
          .getExchangeList(userId, exchangeStatus, super.currPage!);

      super.setLast(response!.last!);

      for (ExchangeDtoModel exchange in response.content!) {
        _exchangeHistoryList!.add(exchange);
      }

      notifyListeners();
    }
  }

  refresh(int userId) {
    super.setCurrPage(0);
    fetchExchangeHistory(userId);
  }
}
