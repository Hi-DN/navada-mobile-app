// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_model.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class MyExchangesExchangeProvider extends ChangeNotifier {
  MyExchangesExchangeProvider(this._userId);

  final int _userId;

  final ExchangeService _exchangeService = ExchangeService();

  int _currentPageNum = 0;
  DataState _dataState = DataState.UNINITIALIZED;
  List<ExchangeDtoModel> _exchangeDataList = [];
  late int _totalPages;
  late int _totalElements = 0;
  
  bool get hasData => _isRefreshing || _exchangeDataList.isNotEmpty;
  DataState get dataState => _dataState;
  int get totalElements => _totalElements;
  List<ExchangeDtoModel> get exchangeDataList => _exchangeDataList;
  bool get _isInitialFetching => _dataState == DataState.INITIAL_FETCHING;
  bool get _isRefreshing => _dataState == DataState.REFRESHING;
  bool get _shouldResetTotalPagesAndTotalElements => _isInitialFetching || _dataState == DataState.REFRESHING;

  fetchData({bool isRefresh = false}) async {
    if(isRefresh)
      _refresh();
    else 
      _setDataStateIfUninitialized();

    notifyListeners();

    try {
      _fetchIfNotLastLoad();
    } catch (e) {
      _handleError();
    }
  }

  _refresh() {
    _exchangeDataList.clear();
    _currentPageNum = 0;
    _dataState = DataState.REFRESHING;
  }

  _setDataStateIfUninitialized() {
    _dataState = (_dataState == DataState.UNINITIALIZED)
        ? DataState.INITIAL_FETCHING
        : DataState.MORE_FETCHING;
  }

  _fetchIfNotLastLoad() async {
    if(_didLastLoad) {
      _dataState = DataState.NO_MORE_DATA;
    } else {
      await _fetchData();
      _dataState = DataState.FETCHED;
    }
  }

  bool get _didLastLoad {
    if(_isInitialFetching || _isRefreshing) {
      return false;
    } else {
      return (_currentPageNum >= _totalPages);
    }
  }

  _fetchData() async {
    ExchangeDtoPageResponse? pageResponse = await _getPageResponse();
    List<ExchangeDtoModel>? newExchanges = pageResponse!.content;

    _exchangeDataList += newExchanges!;
    _currentPageNum += 1;
    notifyListeners();
  }

  _getPageResponse() async {
    ExchangeDtoPageResponse? pageResponse = await _exchangeService.getExchangeList(_userId, _currentPageNum);

    await _resetTotalPagesAndTotalElements(pageResponse!.totalPages!, pageResponse.totalElements!);

    return pageResponse;
  }

  _resetTotalPagesAndTotalElements(int totalPages, int totalElements) {
    if(_shouldResetTotalPagesAndTotalElements) 
      _totalPages = totalPages;
      _totalElements = totalElements;
  }

  _handleError() {
    _dataState = DataState.ERROR;
    notifyListeners();
  }

  deleteCompletedExchange(int? exchangeId, int? acceptorId) async {
    bool isAcceptor = (_userId == acceptorId);
    await _exchangeService.deleteCompletedExchange(exchangeId!, isAcceptor);
    _exchangeDataList.removeWhere((exchange) => exchange.exchangeId == exchangeId);
  }
}