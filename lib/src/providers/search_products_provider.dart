import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';

import '../models/product/product_service.dart';

class SearchProductsProvider extends ChangeNotifier {
  ProductSearchPageModel? _productSearchPageModel;
  ProductSearchPageModel? get productSearchPageModel => _productSearchPageModel;

  late List<ProductSearchDtoModel> _productSearchDtoList;
  List<ProductSearchDtoModel> get productSearchDtoList => _productSearchDtoList;

  int _totalElements = 0;
  int get totalElements => _totalElements;

  getSearchedProducts(userId, categoryIds, productName, lowerCostBound,
      upperCostBound, sort) async {
    ProductSearchPageModel? model = await searchProducts(
        userId, categoryIds, productName, lowerCostBound, upperCostBound, sort);

    _productSearchPageModel = model;
    _productSearchDtoList = _productSearchPageModel!.content!;
    _totalElements = _productSearchPageModel!.totalElements!;

    notifyListeners();
  }
}
