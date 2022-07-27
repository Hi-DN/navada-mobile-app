import 'package:navada_mobile_app/src/business_logic/product/category/category_model.dart';
import 'package:navada_mobile_app/src/view/utils/enums.dart';

class ProductModel {
  int? productId;
  String? productName;
  String? productExplanation;
  Category? category;
  ProductStatusCd? productStatusCd;
  int? heartNum;
  int? productCost;
  int? exchangeCostRange;

  ProductModel(
      {this.productId,
      this.productName,
      this.productExplanation,
      this.category,
      this.productStatusCd,
      this.heartNum,
      this.productCost,
      this.exchangeCostRange});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productExplanation = json['productExplanation'];
    category = Category.objToEnum(CategoryModel.fromJson(json['category']));
    productStatusCd = 
        ProductStatusCd.intToEnum(json['productStatusCd']);
    heartNum = json['heartNum'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['productExplanation'] = productExplanation;
    if (category != null) {
      data['category'] = Category.enumToObj(category!).toJson();
    }
    data['productStatusCd'] = productStatusCd?.code;
    data['heartNum'] = heartNum;
    data['productCost'] = productCost;
    data['exchangeCostRange'] = exchangeCostRange;
    return data;
  }
}

class ProductParams {
  String? productName;
  String? productExplanation;
  int? categoryId;
  int? productCost;
  int? exchangeCostRange;

  ProductParams(
      {this.productName,
      this.productExplanation,
      this.categoryId,
      this.productCost,
      this.exchangeCostRange});

  ProductParams.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    productExplanation = json['productExplanation'];
    categoryId = json['categoryId'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productName'] = productName;
    data['productExplanation'] = productExplanation;
    data['categoryId'] = categoryId.toString();
    data['productCost'] = productCost.toString();
    data['exchangeCostRange'] = exchangeCostRange.toString();
    return data;
  }
}
