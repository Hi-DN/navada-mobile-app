import 'package:flutter/material.dart';

class AcceptRequestViewModel extends ChangeNotifier {
  AcceptRequestViewModel(this._isDenied);

  bool _isDenied;
  bool get isDenied => _isDenied;

  setDenied() {
    _isDenied = false;
    notifyListeners();
  }
}
