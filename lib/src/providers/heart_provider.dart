import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/page_provider.dart';

import '../models/heart/heart_list_model.dart';
import '../models/heart/heart_service.dart';
import '../models/user/user_provider.dart';

class HeartProvider with ChangeNotifier, PageProvider {
  final HeartService _heartService = HeartService();
  int userId = UserProvider.user.userId!;

  bool _showAll = true;

  HeartListModel? _heartListModel;
  HeartListModel? get heartListModel => _heartListModel;

  List<HeartListContentModel> _heartList = [];
  List<HeartListContentModel> get heartList => _heartList;

  void setShowAll() {
    _showAll = !_showAll;
    super.setCurrPage(0);

    fetchHeartList();
    notifyListeners();
  }

  fetchHeartList() async {
    HeartListModel model =
        await _heartService.getHeartsByUser(userId, _showAll, super.currPage!);

    _heartListModel = model;
    _heartList = _heartListModel!.content!;

    super.setLast(_heartListModel!.last!);
    notifyListeners();
  }

  void fetchMoreData() async {
    if (!super.last) {
      super.setCurrPage(super.currPage! + 1);

      HeartListModel model = await _heartService.getHeartsByUser(
          userId, _showAll, super.currPage!);
      super.setLast(model.last!);

      for (HeartListContentModel heart in model.content!) {
        _heartList.add(heart);
      }
      notifyListeners();
    }
  }

  refresh() {
    super.setCurrPage(0);
    fetchHeartList();
  }

  deleteSelectedHeart(int heartId) async {
    await _heartService.deleteHeartByHeartId(heartId);
  }

  saveSelectedHeart(int productId) async {
    await _heartService.saveHeart(productId, userId);
  }
}
