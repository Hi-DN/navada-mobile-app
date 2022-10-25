import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class CreateProductProvider extends ChangeNotifier {
  final int _userId = UserProvider.userId;
  
  final ProductService _productService = ProductService();
  final RequestService _requestService = RequestService();
  
  String? _productName;
  Category? _productCategory;
  int? _productPrice;
  int? _productExchangeCost;
  String? _productExplanation;  
  final List<ProductSearchDtoModel> _otherProducts = [];

  List<ProductSearchDtoModel> get otherProducts => _otherProducts;
  bool get isOtherProductsEmpty => _otherProducts.isEmpty;

  setProductName(String productName) {_productName = productName;}
  setProductCategory(Category productCategory) {_productCategory = productCategory;}
  setProductPrice(int productPrice) {_productPrice = productPrice;}
  setProductExchangeCost(int productExchangeCost) {_productExchangeCost = productExchangeCost;}
  setProductExplanation(String productExplanation) {_productExplanation = productExplanation;}

  addOtherProducts(ProductSearchDtoModel product) {
    _otherProducts.add(product); 
    notifyListeners();
  }

  removeFromOtherProducts(int productId) {
    _otherProducts.removeWhere((element) => element.productId == productId);
    notifyListeners();
  }

  bool checkValidProductName() {
    if(_productName == null || _productName == "") return false;
    return true;
  }

  bool checkValidProductCategory() {
    if(_productCategory == null) return false;
    return true;
  }

  bool checkValidProductPrice() {
    if(_productPrice == null || _productPrice! < 0) return false;
    return true;
  }

  bool checkValidProductExchangeCost() {
    if(_productExchangeCost == null || _productExchangeCost! < 0 || _productExchangeCost! > _productPrice!) return false;
    return true;
  }

  bool checkValidProductExplanation() {
    if(_productExplanation == null || _productExplanation == "") return false;
    return true;
  }

  Future<ProductModel?> createProduct() async {
    ProductParams params = ProductParams(
      productName: _productName,
      categoryId: _productCategory?.id,
      productCost: _productPrice,
      exchangeCostRange: _productExchangeCost,
      productExplanation: _productExplanation
    );

    ProductModel? product = await _productService.createProduct(_userId, params);
    if(product == null) return null;
    return product;
  }

  Future<ProductSearchPageModel> getProductsBySearchWord(String? searchWord, int pageNum) async {
    ProductSearchPageModel? pageResponse = await _productService.searchProducts(_userId, searchWord, [], null, null, null, pageNum);

    return pageResponse!;
  }

  Future<void> requestToOtherProducts(int productId) async {
    for(int i=0; i<_otherProducts.length; i++) {
      _requestService.createRequest(productId, _otherProducts[i].productId!);
    }
  }
}