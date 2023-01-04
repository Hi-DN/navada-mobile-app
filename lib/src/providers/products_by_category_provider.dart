import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/heart/heart_service.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/screens/tab1_home/products_by_category/products_by_category_view_model.dart';

import '../models/user/user_provider.dart';

class ProductsByCategoryProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final HeartService _heartService = HeartService();

  List<ProductSearchDtoModel>? _productsByCategory;
  List<ProductSearchDtoModel>? get productsByCategory => _productsByCategory;

  int? _totalElements;
  int? get totalElements => _totalElements;

  fetchProducts(int categoryId, ProductsByCategoryViewModel viewModel) async {
    ProductSearchPageModel? model = await _productService.searchProducts(
        UserProvider.userId,
        null,
        [categoryId],
        viewModel.lowerCostBound,
        viewModel.upperCostBound,
        true,
        viewModel.showOnlyExchangeable ? [0] : [],
        viewModel.sortMap,
        0);

    _productsByCategory = model!.content!;
    _totalElements = model.totalElements!;

    notifyListeners();
  }
}
