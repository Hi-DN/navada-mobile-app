// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class MyExchangesRequestProvider extends ChangeNotifier {
  MyExchangesRequestProvider(this._userId);

  final int _userId;

  final RequestService _requestService = RequestService();

  int _currentPageNum = 0;
  DataState _dataState = DataState.UNINITIALIZED;
  List<RequestModel> _requestDataList = [];
  late int _totalPages;
  late int _totalElements = 0;

  bool get hasData => _isRefreshing || _requestDataList.isNotEmpty;
  DataState get dataState => _dataState;
  List<RequestModel> get requestDataList => _requestDataList;
  int get totalElements => _totalElements;
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
    _requestDataList.clear();
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
    RequestPageResponse? pageResponse = await _getPageResponse();
    List<RequestModel>? newRequests = pageResponse!.content;

    _requestDataList += newRequests!;
    _currentPageNum += 1;
    notifyListeners();
  }

  _getPageResponse() async {
    RequestPageResponse? pageResponse = await _requestService.getRequestsThatIApplied(_userId, _currentPageNum);

    await _resetTotalPagesAndTotalElements(pageResponse!.totalPages!, pageResponse.totalElements!);

    return pageResponse;
  }

  _resetTotalPagesAndTotalElements(int totalPages, int totalElements) {
    if(_shouldResetTotalPagesAndTotalElements) {
      _totalPages = totalPages;
      _totalElements = totalElements;
    }
  }

  _handleError() {
    _dataState = DataState.ERROR;
    notifyListeners();
  }

  cancelRequest(int requestId) async {
    await _requestService.deleteRequest(requestId);
    _requestDataList.removeWhere((request) => request.requestId == requestId);
    notifyListeners();
  }

  deleteDeniedRequest(int requestId) async {
    await _requestService.deleteDeniedRequestByRequester(requestId);
    _requestDataList.removeWhere((request) => request.requestId == requestId);
    notifyListeners();
  }
}