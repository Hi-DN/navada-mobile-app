import 'package:flutter/material.dart';

class HeartViewModel with ChangeNotifier {
  bool isChecked = false; //교환가능만 보기 버튼

  void onButtonTapped() {
    isChecked = !isChecked;
    notifyListeners();
  }
}

//하트 아이콘 리스트
class HeartListIcon with ChangeNotifier {
  var iconList;

  void createIconList(int length) {
    iconList = List<bool>.generate(length, (index) => true);
  }

  void onTapped(int index) {
    iconList[index] = !iconList[index];
    notifyListeners();
  }
}
