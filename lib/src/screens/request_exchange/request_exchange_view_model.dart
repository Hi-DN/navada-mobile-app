import 'package:flutter/material.dart';

class RequestExchangeViewModel extends ChangeNotifier {
  List<int> _requestProductIdList = [];
  List<int> get requestProductIdList => _requestProductIdList;

  bool _isListEmpty = true;
  bool get isListEmpty => _isListEmpty;

  void addProductId(int productId) {
    _requestProductIdList.add(productId);
    _isListEmpty = false;

    notifyListeners();
  }

  void removeProductId(int productId) {
    _requestProductIdList.remove(productId);
    if (_requestProductIdList.isEmpty) _isListEmpty = true;

    notifyListeners();
  }

  bool isSelectedId(int productId) {
    return _requestProductIdList.contains(productId);
  }
}
