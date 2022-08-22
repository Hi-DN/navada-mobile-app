import 'package:flutter/cupertino.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel(bool initialLike) {
    _like = initialLike;
  }

  late bool _like;
  bool get like => _like;

  int _selectedRequestId = -1;
  int get selectedRequestId => _selectedRequestId;

  void setLikeValue() {
    _like = !_like;
    notifyListeners();
  }

  void setSelectedRequestId(int id) {
    _selectedRequestId = id;
    print("_selectedRequestId=$_selectedRequestId");
    notifyListeners();
  }
}
