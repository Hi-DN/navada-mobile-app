import 'dart:math';

import 'package:flutter/cupertino.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel(bool initialLike) {
    _like = initialLike;
  }

  // 좋아요 여부
  late bool _like;
  bool get like => _like;

  // 좋아요 갯수
  int _likeNum = -1;
  int get likeNum => _likeNum;

  bool _likeNumFetched = false;
  bool get likeNumFetched => _likeNumFetched;

  // 수락할 교환신청 id
  int _selectedRequestId = -1;
  int get selectedRequestId => _selectedRequestId;

  void setLikeNum(int likeNum) {
    _likeNumFetched = false;
    _likeNum = likeNum;
    _likeNumFetched = true;

    notifyListeners();
  }

  void setLikeValue() {
    _like = !_like;
    if (_like) {
      _likeNum += 1;
    } else {
      _likeNum = max(0, _likeNum - 1);
    }
    notifyListeners();
  }

  void setSelectedRequestId(int id) {
    _selectedRequestId = id;
    notifyListeners();
  }
}
