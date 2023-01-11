// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_model.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_page_response.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

import '../screens/tab4_exchange/my_exchange/my_exchanges_view_model.dart';

class MyExchangesExchangeProvider extends ChangeNotifier {
  MyExchangesExchangeProvider();

  // final int _userId = UserProvider.user.userId!;

  final ExchangeService _exchangeService = ExchangeService();

  int _currentPageNum = 0;
  MyExchangesFilterItem _curFilter = MyExchangesFilterItem.viewAll;
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
  bool get _shouldResetTotalPagesAndTotalElements =>
      _isInitialFetching || _dataState == DataState.REFRESHING;

  setFilter(userId, MyExchangesFilterItem newFilter) {
    _curFilter = newFilter;
    notifyListeners();
    fetchData(userId, isRefresh: true);
  }

  fetchData(int userId, {bool isRefresh = false}) async {
    if (isRefresh)
      _refresh();
    else
      _setDataStateIfUninitialized();

    notifyListeners();

    try {
      _fetchIfNotLastLoad(userId);
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

  _fetchIfNotLastLoad(int userId) async {
    if (_didLastLoad) {
      _dataState = DataState.NO_MORE_DATA;
    } else {
      await _fetchData(userId);
      _dataState = DataState.FETCHED;
    }
  }

  bool get _didLastLoad {
    if (_isInitialFetching || _isRefreshing) {
      return false;
    } else {
      return (_currentPageNum >= _totalPages);
    }
  }

  _fetchData(int userId) async {
    ExchangeDtoPageResponse? pageResponse = await _getPageResponse(userId);
    List<ExchangeDtoModel>? newExchanges = pageResponse!.content;

    _exchangeDataList += newExchanges!;
    _currentPageNum += 1;
    notifyListeners();
  }

  _getPageResponse(int userId) async {
    String exchangeStatus = "1";
    ExchangeDtoPageResponse? pageResponse;
    if (_curFilter == MyExchangesFilterItem.viewAll) {
      pageResponse = await _exchangeService.getExchangeList(userId, exchangeStatus, _currentPageNum);
    } else if (_curFilter == MyExchangesFilterItem.viewOnlyISent) {
      pageResponse = await _exchangeService.getExchangeListViewOnlySent(userId, _currentPageNum);
    } else {
      pageResponse = await _exchangeService.getExchangeListViewOnlyGot(userId, _currentPageNum);
    }
    await _resetTotalPagesAndTotalElements(
        pageResponse!.totalPages!, pageResponse.totalElements!);

    return pageResponse;
  }

  _resetTotalPagesAndTotalElements(int totalPages, int totalElements) {
    if (_shouldResetTotalPagesAndTotalElements) _totalPages = totalPages;
    _totalElements = totalElements;
  }

  _handleError() {
    _dataState = DataState.ERROR;
    notifyListeners();
  }

  deleteCompletedExchange(int userId, int exchangeId, int acceptorId) async {
    bool isAcceptor = (userId == acceptorId);
    await _exchangeService.deleteCompletedExchange(exchangeId, isAcceptor);
    _exchangeDataList
        .removeWhere((exchange) => exchange.exchangeId == exchangeId);
  }
}
