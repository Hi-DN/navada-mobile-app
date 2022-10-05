import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class CreateProductProvider extends ChangeNotifier {

  final ProductService _productService = ProductService();
  String _productName="";
  Category? _productCategory;
  int _productPrice=0;
  int _productExchangeCost=0;
  String _productExplanation="";  

  setProductName(String productName) {_productName = productName;}
  setProductCategory(Category productCategory) {_productCategory = productCategory;}
  setProductPrice(int productPrice) {_productPrice = productPrice;}
  setProductExchangeCost(int productExchangeCost) {_productExchangeCost = productExchangeCost;}
  setProductExplanation(String productExplanation) {_productExplanation = productExplanation;}
}