class ProductModel {
  int? productId;
  String? productName;
  String? productExplanation;
  Category? category;
  int? productStatusCd;
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
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    productStatusCd = json['productStatusCd'];
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
      data['category'] = category!.toJson();
    }
    data['productStatusCd'] = productStatusCd;
    data['heartNum'] = heartNum;
    data['productCost'] = productCost;
    data['exchangeCostRange'] = exchangeCostRange;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    return data;
  }
}
