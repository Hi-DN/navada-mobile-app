import 'package:flutter/material.dart';

class SearchProductsViewModel extends ChangeNotifier {
  // 거래가능물품만보기
  bool _onlyExchangeable = false;
  bool get onlyExchangeable => _onlyExchangeable;

  TextEditingController _lowerCostController = TextEditingController();
  TextEditingController get lowerCostController => _lowerCostController;

  TextEditingController _upperCostController = TextEditingController();
  TextEditingController get upperCostController => _upperCostController;

  // 검색값
  String? _searchValue;
  String? get searchValue => _searchValue;

  // 카테고리 선택
  List<int> _categoryIds = [];
  List<int> get categoryIds => _categoryIds;

  // 희망 가격범위
  int? _lowerCostBound;
  int? get lowerCostBound => _lowerCostBound;

  int? _upperCostBound;
  int? get upperCostBound => _upperCostBound;

  // 최신순 / 좋아요순
  final Map<String, String> _sortMap = {
    '최신순': 'product_id,DESC',
    '좋아요순': 'heart_num,DESC'
  };

  String _sort = '최신순';
  String? get sort => _sort;
  String? get sortMap => _sortMap[_sort];

  void toggleCheckBox() {
    _onlyExchangeable = !_onlyExchangeable;
    notifyListeners();
  }

  void setSearchValue(String? searchValue) {
    _searchValue = searchValue;
    notifyListeners();
  }

  void setSortValue(String sortValue) {
    _sort = sortValue;
    notifyListeners();
  }

  void setCategoryIds(int categoryId) {
    if (_categoryIds.contains(categoryId)) {
      _categoryIds.remove(categoryId);
    } else {
      _categoryIds.add(categoryId);
    }
    notifyListeners();
  }

  void setLowerCostBound(int? lowerCostBound) {
    _lowerCostBound = lowerCostBound;
    notifyListeners();
  }

  void setUpperCostBound(int? upperCostBound) {
    _upperCostBound = upperCostBound;
    notifyListeners();
  }

  void resetCostBound() {
    _lowerCostController.clear();
    _upperCostController.clear();
  }

  void applyCostBound() {
    _lowerCostController.value.text.isNotEmpty
        ? setLowerCostBound(int.parse(_lowerCostController.value.text))
        : setLowerCostBound(null);

    _upperCostController.value.text.isNotEmpty
        ? setUpperCostBound(int.parse(_upperCostController.value.text))
        : setUpperCostBound(null);
  }
}
