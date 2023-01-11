import 'package:flutter/cupertino.dart';

class ProductDetailViewModel extends ChangeNotifier {
  // 수락할 교환신청 id
  int _selectedRequestId = -1;
  int get selectedRequestId => _selectedRequestId;

  void setSelectedRequestId(int id) {
    _selectedRequestId = id;
    notifyListeners();
  }
}
