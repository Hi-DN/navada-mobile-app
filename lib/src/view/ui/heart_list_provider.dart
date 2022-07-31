import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/heart/heart_list_model.dart';
import 'package:navada_mobile_app/src/business_logic/heart/heart_service.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_provider.dart';

import '../utils/colors.dart';

//교환 가능 상품만 보기 버튼
class HeartListCheckButton with ChangeNotifier {
  HeartListProvider heartListProvider = HeartListProvider();
  bool isChecked = false;

  void onTapped() {
    isChecked = !isChecked;
    heartListProvider.setShowAll();
    notifyListeners();
  }

  Icon setIcon() {
    return isChecked
        ? const Icon(Icons.check_circle, color: navy)
        : const Icon(Icons.check_circle_outline);
  }

  Text setText() {
    return Text('교환 가능 상품만 보기',
        style: TextStyle(
          color: isChecked ? navy : grey153,
        ));
  }
}

//리스트뷰
class HeartListProvider with ChangeNotifier {
  int userId = UserProvider.userId;
  bool showAll = true;

  HeartListModel? _heartListModel;
  List<HeartListContentModel>? _heartList = [];
  List<HeartListContentModel>? get dataList => _heartList;

  void setShowAll() {
    showAll = !showAll;
    print('showAll = $showAll');
    notifyListeners();
  }

  List<HeartListContentModel>? getHeartList() {
    fetchHeartList();
    return _heartList;
  }

  fetchHeartList() async {
    _heartListModel = await getHeartsByUser(userId, showAll);
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
