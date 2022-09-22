import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';

import '../models/exchange/exchange_model.dart';
import '../models/heart/heart_service.dart';
import '../models/request/request_dto_model.dart';
import '../models/user/user_model.dart';
import '../models/user/user_provider.dart';

final HeartService _heartService = HeartService();
final int _userId = UserProvider.userId;
final RequestService _requestService = RequestService();

// 상품 상세 : 메인 화면
class ProductDetailProvider extends ChangeNotifier {
  User? _userOfProduct;
  User? get userOfProduct => _userOfProduct;

  void fetchUserInfo(int productId) async {
    UserModel userModel = await getUserByProductId(productId);
    _userOfProduct = userModel.user;

    notifyListeners();
  }

  void deleteHeart(int productId) async {
    await _heartService.deleteHeartByProductAndUser(productId, _userId);
  }

  void saveHeart(int productId) async {
    await _heartService.saveHeart(productId, _userId);
  }
}

// 상품 상세 : 교환 수락하기 모달 화면
class ProductDetailAcceptanceProvider extends ChangeNotifier {
  bool _fetchCompleted = false;
  bool get fetchCompleted => _fetchCompleted;

  late RequestDtoModel _requestDtoModel;
  RequestDtoModel get requestDtoModel => _requestDtoModel;

  List<RequestDtoContentModel> _requestDtoList = [];
  List<RequestDtoContentModel> get requestDtoList => _requestDtoList;

  void fetchRequestDtoList(int productId) async {
    RequestDtoModel model =
        await _requestService.getRequestsByCertainProduct(productId, _userId);
    _requestDtoModel = model;
    _requestDtoList = _requestDtoModel.dataList;
    _fetchCompleted = true;

    notifyListeners();
  }

  ExchangeModel? _exchangeModel;
  ExchangeModel? get exchangeModel => _exchangeModel;

  Future<bool> acceptOneRequest(int requestId) async {
    bool result;

    ExchangeModel? model = await _requestService.acceptRequest(requestId);
    _exchangeModel = model;

    if (_exchangeModel!.success!) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }
}
