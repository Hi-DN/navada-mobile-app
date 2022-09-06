import 'package:flutter/material.dart';

class MyExchangesViewModel extends ChangeNotifier {
  MyExchangesFilterItem _curFilter = MyExchangesFilterItem.viewAll;

  MyExchangesFilterItem get curFilter => _curFilter;

  setFilter(MyExchangesFilterItem newFilter) {
    _curFilter = newFilter;
    notifyListeners();
  }
}

enum MyExchangesFilterItem { 
  viewAll('전체보기'), 
  viewOnlyIApplied('내가 신청한것만 보기'), 
  viewOnlyIGot('신청받은것만 보기');

  const MyExchangesFilterItem(this.label);

  final String label;
}