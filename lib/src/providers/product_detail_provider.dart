import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';

import '../models/heart/heart_service.dart';
import '../models/request/request_dto_model.dart';

class ProductDetailProvider extends ChangeNotifier {
  final HeartService _heartService = HeartService();
  final int _userId = UserProvider.userId;

  bool _fetchCompleted = false;
  bool get fetchCompleted => _fetchCompleted;

  late RequestDtoModel _requestDtoModel;
  RequestDtoModel get requestDtoModel => _requestDtoModel;

  List<RequestDtoContentModel> _requestDtoList = [];
  List<RequestDtoContentModel> get requestDtoList => _requestDtoList;

  void fetchRequestDtoList(int productId) async {
    RequestDtoModel model =
        await getRequestsByCertainProduct(productId, _userId);
    _requestDtoModel = model;
    _requestDtoList = _requestDtoModel.dataList;
    _fetchCompleted = true;

    notifyListeners();
  }

  void deleteHeart(int productId) async {
    await _heartService.deleteHeartByProductAndUser(productId, _userId);
  }

  void saveHeart(int productId) async {
    await _heartService.saveHeart(productId, _userId);
  }
}