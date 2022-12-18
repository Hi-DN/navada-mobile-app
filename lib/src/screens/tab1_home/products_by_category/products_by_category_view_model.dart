import 'package:flutter/material.dart';

class ProductsByCategoryViewModel extends ChangeNotifier {
  bool _showOnlyExchangeable = false;
  bool get showOnlyExchangeable => _showOnlyExchangeable;

  final Map<String, String> _sortMap = {
    '최신순': 'product_id,DESC',
    '좋아요순': 'heart_num,DESC'
  };

  String _sort = '최신순';
  String? get sort => _sort;
  String? get sortMap => _sortMap[_sort];

  toggleCheckBox() {
    _showOnlyExchangeable = !_showOnlyExchangeable;
    notifyListeners();
  }
}
