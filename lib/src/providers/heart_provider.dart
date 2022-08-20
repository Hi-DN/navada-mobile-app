import 'package:flutter/material.dart';

import '../models/heart/heart_list_model.dart';
import '../models/heart/heart_service.dart';
import '../models/user/user_provider.dart';

class HeartProvider with ChangeNotifier {
  int userId = UserProvider.userId;

  bool _isInitial = true;
  bool get isInitial => _isInitial;

  bool _showAll = true;

  late HeartListModel _heartListModel;
  HeartListModel get heartListModel => _heartListModel;

  List<HeartListContentModel> _heartList = [];
  List<HeartListContentModel> get heartList => _heartList;

  bool _last = false;
  bool get last => _last;

  void setInitialFalse() {
    _isInitial = false;
    notifyListeners();
  }

  void setShowAll() {
    _showAll = !_showAll;
    fetchHeartList();
    notifyListeners();
  }

  fetchHeartList() async {
    HeartListModel model = await getHeartsByUser(userId, _showAll);

    _heartListModel = model;
    _heartList = _heartListModel.content;
    _last = _heartListModel.last;

    notifyListeners();
  }

  deleteSelectedHeart(int heartId) async {
    await deleteHeart(heartId);
  }

  saveSelectedHeart(int productId) async {
    await saveHeart(productId, userId);
  }
}
