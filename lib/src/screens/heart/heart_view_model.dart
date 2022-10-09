import 'package:flutter/material.dart';

class HeartViewModel with ChangeNotifier {
  bool _isChecked = false; //교환가능만 보기 버튼
  bool get isChecked => _isChecked;

  List<bool> _iconBoolList = [];
  List<bool> get iconBoolList => _iconBoolList;

  void onCheckButtonTapped() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  void createIconList(int? length) {
    _iconBoolList = List<bool>.generate(length!, (index) => true);
  }

  void onHeartButtonTapped(int index) {
    _iconBoolList[index] = !_iconBoolList[index];
    notifyListeners();
  }
}
