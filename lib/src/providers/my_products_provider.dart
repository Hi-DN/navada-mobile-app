import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_list_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';

class MyProductsProvider extends ChangeNotifier {
  final _userId = UserProvider.userId;

  final ProductService _productService = ProductService();

  List<ProductModel> _products=[];
  int _pageNum=0;
  bool _isLastLoaded=false;
  MyProductsFilter _curFilter = MyProductsFilter.showAll;

  List<ProductModel> get products => _products;
  bool get isLastLoaded => _isLastLoaded;
  MyProductsFilter get curFilter => _curFilter;

  setCurFilter(MyProductsFilter newFilter) {
    _curFilter = newFilter;
    loadMore(true);
    notifyListeners();
  }
  
  loadMore(bool isRefresh) async {
    ProductPageModel? pageResponse;
    if(isRefresh) {
      _products = [];
      _isLastLoaded = false;
      _pageNum=0;
    }
    if(!_isLastLoaded) {
      if(_curFilter == MyProductsFilter.showAll){
        pageResponse = await _productService.getProductsByUser(_userId, _pageNum);
      } else {
        pageResponse = await _productService.getProductsByUserWithStatusCd(_userId, _curFilter.index, _pageNum);
      }
      
      if(pageResponse.last!) {
        _isLastLoaded = true;
      } else {
        _pageNum++;
      }
      List<ProductModel> newDataList = pageResponse.content!;
      _products.addAll(newDataList);
      notifyListeners();
    }
  }
}

enum MyProductsFilter {
  showWait, showTrading, showCompleted, showAll
}
