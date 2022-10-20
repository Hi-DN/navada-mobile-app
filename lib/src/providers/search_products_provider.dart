import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/heart/heart_service.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/screens/search_products/search_products_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

import '../models/product/product_service.dart';
import '../models/user/user_provider.dart';

class SearchProductsProvider extends ChangeNotifier {
  ProductSearchPageModel? _productSearchPageModel;
  ProductSearchPageModel? get productSearchPageModel => _productSearchPageModel;

  List<ProductSearchDtoModel>? _productSearchDtoList;
  List<ProductSearchDtoModel>? get productSearchDtoList =>
      _productSearchDtoList;

  int _totalElements = 0;
  int get totalElements => _totalElements;

  final ProductService _productService = ProductService();
  final HeartService _heartService = HeartService();

  getSearchedProducts(SearchProductsViewModel viewModel) async {
    _productSearchPageModel = null;

    ProductSearchPageModel? model = await _productService.searchProducts(
        UserProvider.userId,
        viewModel.searchValue,
        viewModel.categoryIds,
        viewModel.lowerCostBound,
        viewModel.upperCostBound,
        viewModel.sortMap,
        0);

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

  onHeartButtonTapped(ProductSearchDtoModel product) {
    if (product.like!) {
      product.like = false;
      deleteHeart(product.productId!, UserProvider.userId);
    } else {
      product.like = true;
      saveHeart(product.productId!, UserProvider.userId);
    }
    notifyListeners();
  }

  deleteHeart(int productId, int userId) async {
    await _heartService.deleteHeartByProductAndUser(productId, userId);
  }

  saveHeart(int productId, userId) async {
    await _heartService.saveHeart(productId, userId);
  }
}
