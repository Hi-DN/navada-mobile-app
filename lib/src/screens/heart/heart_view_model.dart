import 'package:flutter/material.dart';

import '../../models/heart/heart_list_model.dart';
import '../../models/heart/heart_service.dart';
import '../../models/user/user_provider.dart';

class HeartViewModel with ChangeNotifier {
  bool isChecked = false; //교환가능만 보기 버튼

  int userId = UserProvider.userId;
  bool isInitial = true;

  HeartListModel? _heartListModel;
  List<HeartListContentModel>? _heartList = [];
  List<HeartListContentModel>? get heartList => _heartList;

  void setInitialFalse() {
    isInitial = false;
    notifyListeners();
  }

  void onButtonTapped() {
    isChecked = !isChecked;
    getHeartList();
    // heartListProvider.setShowAll();
    notifyListeners();
  }

  List<HeartListContentModel>? getHeartList() {
    fetchHeartList();
    notifyListeners();
    return _heartList;
  }

  fetchHeartList() async {
    _heartListModel = await getHeartsByUser(userId, !isChecked);
    _heartList = _heartListModel?.content;

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
