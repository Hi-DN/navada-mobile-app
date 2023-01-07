import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/heart/heart_service.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/providers/page_provider.dart';
import 'package:navada_mobile_app/src/screens/tab1_home/products_by_category/products_by_category_view_model.dart';

import '../models/user/user_provider.dart';

class ProductsByCategoryProvider with ChangeNotifier, PageProvider {
  final ProductService _productService = ProductService();
  final HeartService _heartService = HeartService();

  List<ProductSearchDtoModel>? _productsByCategory;
  List<ProductSearchDtoModel>? get productsByCategory => _productsByCategory;

  int? _totalElements;
  int? get totalElements => _totalElements;

  fetchProducts(int categoryId, ProductsByCategoryViewModel viewModel) async {
    super.setCurrPage(0);

    ProductSearchPageModel? model = await _productService.searchProducts(
        UserProvider.userId,
        null,
        [categoryId],
        viewModel.lowerCostBound,
        viewModel.upperCostBound,
        true,
        viewModel.showOnlyExchangeable ? [0] : [],
        viewModel.sortMap,
        super.currPage);

    _productsByCategory = model!.content!;
    _totalElements = model.totalElements!;
    super.setLast(model.last!);

    notifyListeners();
  }

  void fetchMoreData(
      int categoryId, ProductsByCategoryViewModel viewModel) async {
    if (!super.last) {
      super.setCurrPage(super.currPage! + 1);
      print('currpage=$currPage');

      ProductSearchPageModel? model = await _productService.searchProducts(
          UserProvider.userId,
          null,
          [categoryId],
          viewModel.lowerCostBound,
          viewModel.upperCostBound,
          true,
          viewModel.showOnlyExchangeable ? [0] : [],
          viewModel.sortMap,
          super.currPage);

      super.setLast(model!.last!);
      print('last=$last');

      for (ProductSearchDtoModel product in model.content!) {
        _productsByCategory!.add(product);
      }
      notifyListeners();
    }
  }

  refresh(int categoryId, ProductsByCategoryViewModel viewModel) {
    super.setCurrPage(0);
    fetchProducts(categoryId, viewModel);
  }
}
