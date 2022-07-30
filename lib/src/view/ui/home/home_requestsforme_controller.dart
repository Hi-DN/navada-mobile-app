import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/request/request_model.dart';
import 'package:navada_mobile_app/src/business_logic/request/request_service.dart';
import 'package:navada_mobile_app/src/view/utils/enums.dart';

class RequestsForMeController extends ChangeNotifier {
  int _currentPageNum = 0;
  // final int _totalPages = 2;
  late int _totalPages;
  DataState _dataState = DataState.UNINITIALIZED;
  List<RequestModel> _requestsForMe = [];
  
  bool get _isInitialFetching => _dataState == DataState.INITIAL_FETCHING;
  bool get _didLastLoad {
    if(_isInitialFetching) {
      return false;
    } else {
      return (_currentPageNum >= _totalPages);
    }
  }
  DataState get dataState => _dataState;
  
  List<RequestModel> get dataList => _requestsForMe;

  fetchData({bool isRefresh = false}) async {
    if(isRefresh) {
      _refresh();
    } else {
      _dataState = (_dataState == DataState.UNINITIALIZED)
        ? DataState.INITIAL_FETCHING
        : DataState.MORE_FETCHING;
    }

    notifyListeners();

    try {
      if(_didLastLoad) {
        _dataState = DataState.NO_MORE_DATA;
      } else {
        PageResponse? pageResponse = await getRequestsForMe(1, _currentPageNum);

        if(_isInitialFetching) {
          _totalPages = pageResponse!.totalPages!;
        }

        List<RequestModel>? newRequestsForMe = pageResponse!.content;
        
        
        _requestsForMe += newRequestsForMe!;
        _dataState = DataState.FETCHED;
        _currentPageNum += 1;
      }
    } catch (e) {
      _dataState = DataState.ERROR;

    }
    notifyListeners();
  }

  _refresh() {
    _requestsForMe.clear();
    _currentPageNum = 0;
    _dataState = DataState.REFRESHING;
  }
}
