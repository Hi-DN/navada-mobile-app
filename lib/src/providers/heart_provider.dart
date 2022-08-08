import 'package:flutter/material.dart';

import '../models/heart/heart_list_model.dart';
import '../models/heart/heart_service.dart';
import '../models/user/user_provider.dart';

class HeartProvider with ChangeNotifier {
  int userId = UserProvider.userId;
  bool isInitial = true;
  bool showAll = true;

  HeartListModel? _heartListModel;
  List<HeartListContentModel>? _heartList = [];
  List<HeartListContentModel>? get heartList => _heartList;

  void setInitialFalse() {
    isInitial = false;
    notifyListeners();
  }

  void setShowAll() {
    showAll = !showAll;
    getHeartList();
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
