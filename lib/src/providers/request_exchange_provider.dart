import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_list_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';

import '../models/product/product_model.dart';

class RequestExchangeProvider extends ChangeNotifier {
  bool _initialFetched = false;
  bool get initialFetched => _initialFetched;

  late ProductPageModel _productPageModel;
  ProductPageModel get productPageModel => _productPageModel;

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  fetchProductsList(acceptorProductId) async {
    ProductPageModel model =
        await getProductsForRequest(UserProvider.userId, acceptorProductId);

    _productPageModel = model;
    _productList = _productPageModel.content!;

    _initialFetched = true;

    notifyListeners();
  }
}
