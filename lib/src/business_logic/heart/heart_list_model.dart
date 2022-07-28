class HeartListModel {
  bool? success;
  int? code;
  String? message;
  List<HeartListContentModel>? dataList;

  HeartListModel({this.success, this.code, this.message, this.dataList});

  HeartListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['dataList'] != null) {
      dataList = <HeartListContentModel>[];
      json['dataList'].forEach((v) {
        dataList!.add(new HeartListContentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.dataList != null) {
      data['dataList'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HeartListContentModel {
  dynamic createdDate;
  dynamic modifiedDate;
  int? heartId;
  Product? product;

  HeartListContentModel(
      {this.createdDate, this.modifiedDate, this.heartId, this.product});

  HeartListContentModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    heartId = json['heartId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['heartId'] = this.heartId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  dynamic createdDate;
  dynamic modifiedDate;
  int? productId;
  String? productName;
  String? productExplanation;
  Category? category;
  int? productStatusCd;
  int? heartNum;
  int? productCost;
  int? exchangeCostRange;

  Product(
      {this.createdDate,
      this.modifiedDate,
      this.productId,
      this.productName,
      this.productExplanation,
      this.category,
      this.productStatusCd,
      this.heartNum,
      this.productCost,
      this.exchangeCostRange});

  Product.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    productId = json['productId'];
    productName = json['productName'];
    productExplanation = json['productExplanation'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    productStatusCd = json['productStatusCd'];
    heartNum = json['heartNum'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productExplanation'] = this.productExplanation;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['productStatusCd'] = this.productStatusCd;
    data['heartNum'] = this.heartNum;
    data['productCost'] = this.productCost;
    data['exchangeCostRange'] = this.exchangeCostRange;
    return data;
  }
}

class Category {
  int? categoryId;
  String? categoryName;

  Category({this.categoryId, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
