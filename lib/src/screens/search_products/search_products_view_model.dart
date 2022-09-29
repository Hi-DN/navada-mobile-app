import 'package:flutter/material.dart';

class SearchProductsViewModel extends ChangeNotifier {
  // 거래가능물품만보기
  bool _onlyExchangeable = false;
  bool get onlyExchangeable => _onlyExchangeable;

  // 검색값
  String _searchValue = '';
  String get searchValue => _searchValue;

  // 카테고리 선택
  List<int>? _categoryIds;
  List<int>? get categoryIds => _categoryIds;

  // 희망 가격범위
  int? _lowerCostBound;
  int? get lowerCostBound => _lowerCostBound;

  int? _upperCostBound;
  int? get upperCostBound => _upperCostBound;

  // 최신순 / 좋아요순
  final Map<String, String> _sortMap = {
    '최신순': 'productId, DESC',
    '좋아요순': 'heartNum,DESC'
  };
  String _sort = '최신순';
  String get sort => _sort;

  void toggleCheckBox() {
    _onlyExchangeable = !_onlyExchangeable;
    notifyListeners();
  }
}
