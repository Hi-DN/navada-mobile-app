import 'package:navada_mobile_app/src/models/product/category/category_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class ProductModel {
  String? createdDate;
  String? modifiedDate;
  int? productId;
  String? productName;
  String? productExplanation;
  String? userNickname;
  Category? category;
  ProductExchangeStatusCd? productExchangeStatusCd;
  int? heartNum;
  int? productCost;
  int? exchangeCostRange;

  ProductModel(
      {this.createdDate,
      this.modifiedDate,
      this.productId,
      this.productName,
      this.productExplanation,
      this.userNickname,
      this.category,
      this.productExchangeStatusCd,
      this.heartNum,
      this.productCost,
      this.exchangeCostRange});

  ProductModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    productId = json['productId'];
    productName = json['productName'];
    productExplanation = json['productExplanation'];
    userNickname = json['userNickname'];
    category = Category.objToEnum(CategoryModel.fromJson(json['category']));
    productExchangeStatusCd =
        ProductExchangeStatusCd.codeToEnum(json['productExchangeStatusCd']);
    heartNum = json['heartNum'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productExplanation'] = productExplanation;
    data['userNickname'] = userNickname;
    if (category != null) {
      data['category'] = Category.enumToObj(category!).toJson();
    }
    data['productExchangeStatusCd'] = productExchangeStatusCd?.code;
    data['heartNum'] = heartNum;
    data['productCost'] = productCost;
    data['exchangeCostRange'] = exchangeCostRange;
    return data;
  }

  int getLowerBound() {
    return productCost! - exchangeCostRange!;
  }

  int getUpperBound() {
    return productCost! + exchangeCostRange!;
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

class ProductDetailDto {
  String? createdDate;
  int? productId;
  String? userNickname;
  String? productName;
  String? productExplanation;
  Category? category;
  ProductExchangeStatusCd? productExchangeStatusCd;
  int? heartNum;
  int? productCost;
  int? exchangeCostRange;
  bool? like;

  ProductDetailDto(
      {this.createdDate,
      this.productId,
      this.userNickname,
      this.productName,
      this.productExplanation,
      this.category,
      this.productExchangeStatusCd,
      this.heartNum,
      this.productCost,
      this.exchangeCostRange,
      this.like});

  ProductDetailDto.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    productId = json['productId'];
    userNickname = json['userNickname'];
    productName = json['productName'];
    productExplanation = json['productExplanation'];
    category = Category.objToEnum(CategoryModel.fromJson(json['category']));
    productExchangeStatusCd =
        ProductExchangeStatusCd.codeToEnum(json['productExchangeStatusCd']);
    heartNum = json['heartNum'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['productId'] = productId;
    data['userNickname'] = userNickname;
    data['productName'] = productName;
    data['productExplanation'] = productExplanation;
    if (category != null) {
      data['category'] = Category.enumToObj(category!).toJson();
    }
    data['productExchangeStatusCd'] = productExchangeStatusCd?.code;
    data['heartNum'] = heartNum;
    data['productCost'] = productCost;
    data['exchangeCostRange'] = exchangeCostRange;
    data['like'] = like;
    return data;
  }

  ProductModel convertToProductModel() {
    return ProductModel(
        createdDate: createdDate,
        productId: productId,
        productName: productName,
        productExplanation: productExplanation,
        userNickname: userNickname,
        category: category,
        productExchangeStatusCd: productExchangeStatusCd,
        heartNum: heartNum,
        productCost: productCost,
        exchangeCostRange: exchangeCostRange);
  }

  int getLowerBound() {
    return productCost! - exchangeCostRange!;
  }

  int getUpperBound() {
    return productCost! + exchangeCostRange!;
  }
}
