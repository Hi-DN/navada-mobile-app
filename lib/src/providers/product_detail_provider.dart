import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/request/requtest_dto_model.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';

import '../models/exchange/exchange_single_response.dart';
import '../models/heart/heart_service.dart';
import '../models/product/product_model.dart';
import '../models/request/request_list_response.dart';
import '../models/user/user_model.dart';
import '../models/user/user_provider.dart';

final int _userId = UserProvider.user.userId!;
final UserService _userService = UserService();
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
  RequestListResponse? _requestListResponse;
  RequestListResponse? get requestListResponse => _requestListResponse;

  List<RequestDto> _requestDtoList = [];
  List<RequestDto> get requestDtoList => _requestDtoList;

  bool _productFetched = false;
  bool get productFetched => _productFetched;

  bool _userFetched = false;
  bool get userFetched => _userFetched;

  bool _requestsFetched = false;
  bool get requestsFetched => _requestsFetched;

  ExchangeSingleResponse? _exchangeModel;
  ExchangeSingleResponse? get exchangeModel => _exchangeModel;

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

    UserModel userModel = await _userService.getUserByProductId(productId);
    _userOfProduct = userModel.user;

    _userFetched = true;
    notifyListeners();
  }

  void _fetchRequestDtoList(int productId) async {
    _requestsFetched = false;

    RequestListResponse response =
        await _requestService.getRequestsByCertainProduct(productId, _userId);
    _requestListResponse = response;
    _requestDtoList = _requestListResponse!.dataList;

    _requestsFetched = true;
    notifyListeners();
  }

  void deleteHeart(int productId) async {
    await _heartService.deleteHeartByProductAndUser(productId, _userId);
  }

  void saveHeart(int productId) async {
    await _heartService.saveHeart(productId, _userId);
  }

  Future<bool> deleteProduct(int productId) async {
    bool success = await _productService.deleteProduct(productId);
    return success;
  }

  // 교환 수락
  Future<bool> acceptOneRequest(int requestId) async {
    bool result;

    ExchangeSingleResponse? model =
        await _requestService.acceptRequest(requestId);
    _exchangeModel = model;

    if (_exchangeModel!.success!) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }
}
