import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/screens/search_products/search_products_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

import '../models/product/product_service.dart';
import '../models/user/user_provider.dart';

class SearchProductsProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  ProductSearchPageModel? _productSearchPageModel;
  ProductSearchPageModel? get productSearchPageModel => _productSearchPageModel;

  List<ProductSearchDtoModel>? _productSearchDtoList;
  List<ProductSearchDtoModel>? get productSearchDtoList =>
      _productSearchDtoList;

  int _totalElements = 0;
  int get totalElements => _totalElements;

  getSearchedProducts(SearchProductsViewModel viewModel) async {
    _productSearchPageModel = null;

    ProductSearchPageModel? model = await _productService.searchProducts(
        UserProvider.userId,
        viewModel.searchValue,
        viewModel.categoryIds,
        viewModel.lowerCostBound,
        viewModel.upperCostBound,
        viewModel.sortMap,
        null);

    _productSearchPageModel = model;
    _productSearchDtoList = _productSearchPageModel!.content!;

    if (viewModel.onlyExchangeable) {
      _productSearchDtoList = _productSearchDtoList
          ?.where((p) =>
              p.productExchangeStatusCd == ProductExchangeStatusCd.REGISTERED)
          .toList();
    }

    _totalElements = _productSearchDtoList!.length;

    notifyListeners();
  }
}
