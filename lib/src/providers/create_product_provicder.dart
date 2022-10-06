import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class CreateProductProvider extends ChangeNotifier {
  CreateProductProvider(this._userId);
  final int _userId;
  
  final ProductService _productService = ProductService();
  
  String? _productName;
  Category? _productCategory;
  int? _productPrice;
  int? _productExchangeCost;
  String? _productExplanation;  

  setProductName(String productName) {_productName = productName;}
  setProductCategory(Category productCategory) {_productCategory = productCategory;}
  setProductPrice(int productPrice) {_productPrice = productPrice;}
  setProductExchangeCost(int productExchangeCost) {_productExchangeCost = productExchangeCost;}
  setProductExplanation(String productExplanation) {_productExplanation = productExplanation;}

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
    bool success = true;

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
}