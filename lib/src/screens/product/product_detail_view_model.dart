import 'package:flutter/cupertino.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel(bool initialLike) {
    _like = initialLike;
  }

  late bool _like;
  bool get like => _like;

  // void setInitialLikeValue(bool value) {
  //   _like = value;
  //   notifyListeners();
  // }

  void setLikeValue() {
    _like = !_like;
    notifyListeners();
  }
}
