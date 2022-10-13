import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';

import '../models/exchange/exchange_model.dart';
import '../models/heart/heart_service.dart';
import '../models/product/product_model.dart';
import '../models/request/request_dto_model.dart';
import '../models/user/user_model.dart';
import '../models/user/user_provider.dart';

final int _userId = UserProvider.userId;
final HeartService _heartService = HeartService();
final RequestService _requestService = RequestService();
final ProductService _productService = ProductService();

class ProductDetailProvider extends ChangeNotifier {
  // 물품 정보
  ProductModel? _product;
  ProductModel? get product => _product;

  // 해당 물품의 유저
  User? _userOfProduct;
  User? get userOfProduct => _userOfProduct;

  // 해당 물품으로부터 내 물품에 온 요청 목록
  RequestDtoModel? _requestDtoModel;
  RequestDtoModel? get requestDtoModel => _requestDtoModel;

  List<RequestDtoContentModel> _requestDtoList = [];
  List<RequestDtoContentModel> get requestDtoList => _requestDtoList;

  bool _productFetched = false;
  bool get productFetched => _productFetched;

  bool _userFetched = false;
  bool get userFetched => _userFetched;

  bool _requestsFetched = false;
  bool get requestsFetched => _requestsFetched;

  ExchangeModel? _exchangeModel;
  ExchangeModel? get exchangeModel => _exchangeModel;

  void fetchProductDetailInfo(int productId) {
    _fetchProduct(productId);
    _fetchUser(productId);
    _fetchRequestDtoList(productId);
  }

  void _fetchProduct(int productId) async {
    _productFetched = false;

    ProductModel? model = await _productService.getProduct(productId);
    _product = model;

    _productFetched = true;
    notifyListeners();
  }

  void _fetchUser(int productId) async {
    _userFetched = false;

    UserModel userModel = await getUserByProductId(productId);
    _userOfProduct = userModel.user;

    _userFetched = true;
    notifyListeners();
  }

  void _fetchRequestDtoList(int productId) async {
    _requestsFetched = false;

    RequestDtoModel model =
        await _requestService.getRequestsByCertainProduct(productId, _userId);
    _requestDtoModel = model;
    _requestDtoList = _requestDtoModel!.dataList;

    _requestsFetched = true;
    notifyListeners();
  }

  void deleteHeart(int productId) async {
    await _heartService.deleteHeartByProductAndUser(productId, _userId);
  }

  void saveHeart(int productId) async {
    await _heartService.saveHeart(productId, _userId);
  }

  // 교환 수락
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
