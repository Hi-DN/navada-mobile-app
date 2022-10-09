import 'dart:math';

import 'package:flutter/cupertino.dart';

// 상품 상세 : 메인 화면
class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel(bool initialLike, int initialLikeNum) {
    _like = initialLike;
    _likeNum = initialLikeNum;
  }

  late bool _like;
  bool get like => _like;

  late int _likeNum;
  int get likeNum => _likeNum;

  void setLikeValue() {
    _like = !_like;
    if (_like) {
      _likeNum += 1;
    } else {
      _likeNum = max(0, _likeNum - 1);
    }
    notifyListeners();
  }
}

// 상품 상세 : 교환 수락하기 모달 화면
class ProductDetailAcceptanceViewModel extends ChangeNotifier {
  int _selectedRequestId = -1;
  int get selectedRequestId => _selectedRequestId;

  void setSelectedRequestId(int id) {
    _selectedRequestId = id;
    print("_selectedRequestId=$_selectedRequestId");
    notifyListeners();
  }
}
