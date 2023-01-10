import 'package:flutter/material.dart';

class ProductsByCategoryViewModel extends ChangeNotifier {
  final TextEditingController _lowerCostBoundController =
      TextEditingController();
  TextEditingController get lowerCostBoundController =>
      _lowerCostBoundController;

  final TextEditingController _upperCostBoundController =
      TextEditingController();
  TextEditingController get upperCostBoundController =>
      _upperCostBoundController;

  bool _showOnlyExchangeable = false;
  bool get showOnlyExchangeable => _showOnlyExchangeable;

  final Map<String, String> _sortMap = {
    '최신순': 'product_id,DESC',
    '좋아요순': 'heart_num,DESC'
  };

  String _sort = '최신순';
  String? get sort => _sort;
  String? get sortMap => _sortMap[_sort];

  int? _lowerCostBound;
  int? get lowerCostBound => _lowerCostBound;

  int? _upperCostBound;
  int? get upperCostBound => _upperCostBound;

  toggleCheckBox() {
    _showOnlyExchangeable = !_showOnlyExchangeable;
    notifyListeners();
  }

  void setSortValue(String sortValue) {
    _sort = sortValue;
    notifyListeners();
  }

  void setCostBound() {
    _lowerCostBoundController.value.text.isNotEmpty
        ? setLowerCostBound(int.parse(_lowerCostBoundController.value.text))
        : setLowerCostBound(null);

    _upperCostBoundController.value.text.isNotEmpty
        ? setUpperCostBound(int.parse(_upperCostBoundController.value.text))
        : setUpperCostBound(null);

    notifyListeners();
  }

  void setLowerCostBound(int? lowerCostBound) {
    _lowerCostBound = lowerCostBound;
  }

  void setUpperCostBound(int? upperCostBound) {
    _upperCostBound = upperCostBound;
  }

  void refreshCostBound() {
    _lowerCostBoundController.clear();
    _upperCostBoundController.clear();
  }
}
