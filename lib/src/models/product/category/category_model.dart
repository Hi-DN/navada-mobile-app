class CategoryModel {
  int? categoryId;
  String? categoryName;

  CategoryModel({this.categoryId, this.categoryName});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
