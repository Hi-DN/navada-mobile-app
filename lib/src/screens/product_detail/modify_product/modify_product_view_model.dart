import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class ModifyProductViewModel extends ChangeNotifier {
  ModifyProductViewModel(
      this._productId,
      this._productName,
      this._productCategory,
      this._productPrice,
      this._productExchangeCost,
      this._productExplanation,
      this._productImageUrl);

  final int _productId;
  String? _productName;
  Category? _productCategory;
  int? _productPrice;
  int? _productExchangeCost;
  String? _productExplanation;
  String? _productImageUrl;
  XFile? _productImageFile;

  int? get productId => _productId;
  String? get productName => _productName;
  Category? get productCategory => _productCategory;
  int? get productPrice => _productPrice;
  int? get productExchangeCost => _productExchangeCost;
  String? get productExplanation => _productExplanation;
  String? get productImageUrl => _productImageUrl;
  XFile? get productImageFile => _productImageFile;

  setProductName(String productName) {
    _productName = productNameController.value.text;
  }

  setProductCategory(Category productCategory) {
    _productCategory = productCategory;
    notifyListeners();
  }

  setProductPrice(int productPrice) {
    _productPrice = int.parse(productPriceController.value.text);
  }

  setProductExchangeCost(int productExchangeCost) {
    _productExchangeCost = int.parse(productExchangeCostController.value.text);
  }

  setProductExplanation(String productExplanation) {
    _productExplanation = productExplanationController.value.text;
  }

  setProductImageFile(XFile? productImageFile) {
    _productImageUrl = null;
    _productImageFile = productImageFile;
    notifyListeners();
  }

  late TextEditingController productNameController =
      TextEditingController(text: _productName);
  late TextEditingController productPriceController =
      TextEditingController(text: _productPrice.toString());
  late TextEditingController productExchangeCostController =
      TextEditingController(text: _productExchangeCost.toString());
  late TextEditingController productExplanationController =
      TextEditingController(text: _productExplanation);

  final FocusNode productNameFNode = FocusNode();
  final FocusNode productCategoryFNode = FocusNode();
  final FocusNode productPriceFNode = FocusNode();
  final FocusNode productExchangeCostFNode = FocusNode();
  final FocusNode productExplanationFNode = FocusNode();

  bool checkValidProductName() {
    if (_productName == null ||
        _productName == "" ||
        productNameController.value.text.isEmpty) return false;
    return true;
  }

  bool checkValidProductCategory() {
    if (_productCategory == null) return false;
    return true;
  }

  bool checkValidProductPrice() {
    if (_productPrice == null ||
        _productPrice! < 0 ||
        productPriceController.value.text.isEmpty) return false;
    return true;
  }

  bool checkValidProductExchangeCost() {
    debugPrint(_productPrice.toString());
    if (_productExchangeCost == null ||
        productExchangeCostController.value.text.isEmpty ||
        _productExchangeCost! < 0 ||
        _productExchangeCost! > _productPrice!) return false;
    return true;
  }

  bool checkValidProductExplanation() {
    if (_productExplanation == null ||
        _productExplanation == "" ||
        productExplanationController.value.text.isEmpty) return false;
    return true;
  }
}
