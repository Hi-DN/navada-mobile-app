import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';

class ModifyProductProvider extends ChangeNotifier {
  final int _userId = UserProvider.userId;
  
  final ProductService _productService = ProductService();

  Future<ProductModel?> modifyProduct(ProductParams params) async {
    ProductModel? product = await _productService.modifyProduct(_userId, params);
    if(product == null) return null;
    return product;
  }
}