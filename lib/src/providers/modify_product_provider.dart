import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_service.dart';

class ModifyProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  Future<ProductModel?> modifyProduct(
      int productId, ProductParams params, XFile? productImageFile) async {
    ProductModel? product = await _productService.modifyProduct(
        productId, params, productImageFile);
    if (product == null) return null;
    return product;
  }
}
