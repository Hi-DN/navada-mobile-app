import 'package:flutter/material.dart';

class HeartViewModel with ChangeNotifier {
  bool isChecked = false; //교환가능만 보기 버튼
  late List<bool> iconList = [];

  void onCheckButtonTapped() {
    isChecked = !isChecked;
    notifyListeners();
  }

  void createIconList(int? length) {
    print('length=$length');
    iconList = List<bool>.generate(length!, (index) => true);
    notifyListeners();
  }

  void onHeartButtonTapped(int index) {
    iconList[index] = !iconList[index];
    print(
        'HeartButtonTapped!! index = $index, iconList[index]=${iconList[index]}');
    // if (iconList[index]) {
    //   saveSelectedHeart(2, 1);
    // } else {
    //   deleteSelectedHeart(1);
    // }
    notifyListeners();
  }
}
