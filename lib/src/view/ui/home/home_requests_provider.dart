// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/request/request_model.dart';
import 'package:navada_mobile_app/src/business_logic/request/request_service.dart';
import 'package:navada_mobile_app/src/view/utils/enums.dart';

class RequestsForMeProvider extends ChangeNotifier {
  RequestsForMeProvider(this._userId);

  final int _userId;

  bool _isDeniedVisible = false;

  int _currentPageNum = 0;
  DataState _dataState = DataState.UNINITIALIZED;
  List<RequestModel> _requestDataList = [];
  late int _totalPages;
  
  bool get isDeniedVisible => _isDeniedVisible;
  DataState get dataState => _dataState;
  List<RequestModel> get requestDataList => _requestDataList;
  bool get _isInitialFetching => _dataState == DataState.INITIAL_FETCHING;
  bool get _shouldResetTotalPages => _isInitialFetching || _dataState == DataState.REFRESHING;

  void setDeniedVisible(bool newValue) {
    _isDeniedVisible = newValue;
    notifyListeners();
    
    fetchData(isRefresh: true);
  }

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
    if(_isInitialFetching) {
      return false;
    } else {
      return (_currentPageNum >= _totalPages);
    }
  }

  _fetchData() async {
    PageResponse? pageResponse = await _getPageResponse();
    List<RequestModel>? newRequestsForMe = pageResponse!.content;

    _requestDataList += newRequestsForMe!;
    _currentPageNum += 1;
    notifyListeners();
  }

  _getPageResponse() async {
    PageResponse? pageResponse = _isDeniedVisible
      ? await getRequestsForMeIncludingDenied(_userId, _currentPageNum)
      : await getRequestsForMe(_userId, _currentPageNum);

    await _resetTotalPages(pageResponse!.totalPages!);

    return pageResponse;
  }

  _resetTotalPages(int totalPages) {
    if(_shouldResetTotalPages) 
      _totalPages = totalPages;
  }

  _handleError() {
    _dataState = DataState.ERROR;
    notifyListeners();
  }
}
