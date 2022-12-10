import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_single_response.dart';
import 'package:navada_mobile_app/src/models/request/request_page_response.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/request/requtest_dto_model.dart';

class AcceptRequestProvider extends ChangeNotifier {
  AcceptRequestProvider(this._request);

  final RequestDto _request;

  List<RequestDto> _otherRequests=[];
  int _pageNum=0;
  bool _isLastLoaded=false;

  List<RequestDto> get otherRequests => _otherRequests;
  bool get isLastLoaded => _isLastLoaded;

  final RequestService _requestService = RequestService();

  loadMore(bool isRefresh) async {
    if(isRefresh) {
      _otherRequests = [];
      _isLastLoaded = false;
      _pageNum=0;
    }
    if(!_isLastLoaded) {
      RequestPageResponse? pageResponse = await _requestService.getRequestsforCertainProduct(_request.acceptorProduct!.productId!, _pageNum);
      if(pageResponse.last!) {
        _isLastLoaded = true;
      } else {
        _pageNum++;
      }
      List<RequestDto> newDataList = pageResponse.content!;
      newDataList.removeWhere((request) => request.requesterProduct!.productId == _request.requesterProduct!.productId);
      _otherRequests.addAll(newDataList);
      notifyListeners();
    }
  }

  Future<ExchangeSingleResponse?> acceptRequest(int requestId) {
    return _requestService.acceptRequest(requestId);
  }

  Future<bool> rejectRequest(int requestId) {
    return _requestService.rejectRequest(requestId);
  }
}