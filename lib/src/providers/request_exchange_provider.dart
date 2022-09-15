import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_list_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';

import '../models/product/product_model.dart';
import '../models/request/request_model.dart';

class RequestExchangeProvider extends ChangeNotifier {
  final RequestService _requestService = RequestService();

  bool _initialFetched = false;
  bool get initialFetched => _initialFetched;

  late ProductPageModel _productPageModel;
  ProductPageModel get productPageModel => _productPageModel;

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  setInitialFetched(bool fetched) {
    _initialFetched = !_initialFetched;
    notifyListeners();
  }

  fetchProductsList(acceptorProductId) async {
    ProductPageModel model =
        await getProductsForRequest(UserProvider.userId, acceptorProductId);

    _productPageModel = model;
    _productList = _productPageModel.content!;

    _initialFetched = true;

    notifyListeners();
  }

  Future<bool> createRequests(
      List<int> requestProductIdList, int acceptorProductId) async {
    bool success = true;

    for (int productId in requestProductIdList) {
      RequestModel? requestModel =
          await _requestService.createRequest(productId, acceptorProductId);
      if (requestModel == null) success = false;
    }

    return success;
  }
}
