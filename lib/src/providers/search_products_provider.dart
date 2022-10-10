import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/screens/search_products/search_products_view_model.dart';

import '../models/product/product_service.dart';

class SearchProductsProvider extends ChangeNotifier {
  ProductSearchPageModel? _productSearchPageModel;
  ProductSearchPageModel? get productSearchPageModel => _productSearchPageModel;

  List<ProductSearchDtoModel>? _productSearchDtoList;
  List<ProductSearchDtoModel>? get productSearchDtoList =>
      _productSearchDtoList;

  int _totalElements = 0;
  int get totalElements => _totalElements;

  getSearchedProducts(userId, SearchProductsViewModel viewModel) async {
    _productSearchPageModel = null;

    ProductSearchPageModel? model = await searchProducts(
        userId,
        viewModel.searchValue,
        viewModel.categoryIds,
        viewModel.lowerCostBound,
        viewModel.upperCostBound,
        viewModel.sortMap);

    _productSearchPageModel = model;
    _productSearchDtoList = _productSearchPageModel!.content!;
    _totalElements = _productSearchPageModel!.totalElements!;

    notifyListeners();
  }
}
