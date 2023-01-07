import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/heart/heart_service.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/providers/page_provider.dart';

import '../models/product/product_service.dart';
import '../models/user/user_provider.dart';
import '../screens/tab2_products/search_products/search_products_view_model.dart';

class SearchProductsProvider with ChangeNotifier, PageProvider {
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
    super.setCurrPage(0);

    ProductSearchPageModel? model = await _productService.searchProducts(
        UserProvider.userId,
        viewModel.searchValue,
        viewModel.categoryIds,
        viewModel.lowerCostBound,
        viewModel.upperCostBound,
        true,
        viewModel.onlyExchangeable ? [0] : [],
        viewModel.sortMap,
        super.currPage);

    _productSearchPageModel = model;
    _productSearchDtoList = _productSearchPageModel!.content!;
    _totalElements = model!.totalElements!;

    super.setLast(model.last!);

    notifyListeners();
  }

  void fetchMoreData(SearchProductsViewModel viewModel) async {
    if (!super.last) {
      super.setCurrPage(super.currPage! + 1);

      ProductSearchPageModel? model = await _productService.searchProducts(
          UserProvider.userId,
          viewModel.searchValue,
          viewModel.categoryIds,
          viewModel.lowerCostBound,
          viewModel.upperCostBound,
          true,
          viewModel.onlyExchangeable ? [0] : [],
          viewModel.sortMap,
          super.currPage);

      super.setLast(model!.last!);

      for (ProductSearchDtoModel product in model.content!) {
        _productSearchDtoList!.add(product);
      }
      notifyListeners();
    }
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
