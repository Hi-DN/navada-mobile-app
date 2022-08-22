class HeartListModel {
  HeartListModel({
    required this.success,
    required this.code,
    required this.message,
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
    required this.empty,
    required this.first,
    required this.last,
    required this.numberOfElements,
    required this.size,
  });
  late final bool success;
  late final int code;
  late final String message;
  late final List<HeartListContentModel> content;
  late final Pageable pageable;
  late final int totalPages;
  late final int totalElements;
  late final bool empty;
  late final bool first;
  late final bool last;
  late final int numberOfElements;
  late final int size;

  HeartListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    content = List.from(json['content'])
        .map((e) => HeartListContentModel.fromJson(e))
        .toList();
    pageable = Pageable.fromJson(json['pageable']);
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    empty = json['empty'];
    first = json['first'];
    last = json['last'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['code'] = code;
    _data['message'] = message;
    _data['content'] = content.map((e) => e.toJson()).toList();
    _data['pageable'] = pageable.toJson();
    _data['totalPages'] = totalPages;
    _data['totalElements'] = totalElements;
    _data['empty'] = empty;
    _data['first'] = first;
    _data['last'] = last;
    _data['numberOfElements'] = numberOfElements;
    _data['size'] = size;
    return _data;
  }
}

class HeartListContentModel {
  HeartListContentModel({
    this.createdDate,
    this.modifiedDate,
    required this.heartId,
    required this.product,
  });
  late final dynamic createdDate;
  late final dynamic modifiedDate;
  late final int heartId;
  late final Product product;

  HeartListContentModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    heartId = json['heartId'];
    product = Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['createdDate'] = createdDate;
    _data['modifiedDate'] = modifiedDate;
    _data['heartId'] = heartId;
    _data['product'] = product.toJson();
    return _data;
  }
}

class Product {
  Product({
    this.createdDate,
    this.modifiedDate,
    required this.productId,
    required this.userNickname,
    required this.productName,
    required this.productExplanation,
    required this.category,
    required this.productStatusCd,
    required this.heartNum,
    required this.productCost,
    required this.exchangeCostRange,
  });
  late final dynamic createdDate;
  late final dynamic modifiedDate;
  late final int productId;
  late final String userNickname;
  late final String productName;
  late final String productExplanation;
  late final Category category;
  late final int productStatusCd;
  late final int heartNum;
  late final int productCost;
  late final int exchangeCostRange;

  Product.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    productId = json['productId'];
    userNickname = json['userNickname'];
    productName = json['productName'];
    productExplanation = json['productExplanation'];
    category = Category.fromJson(json['category']);
    productStatusCd = json['productStatusCd'];
    heartNum = json['heartNum'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['createdDate'] = createdDate;
    _data['modifiedDate'] = modifiedDate;
    _data['productId'] = productId;
    _data['userNickname'] = userNickname;
    _data['productName'] = productName;
    _data['productExplanation'] = productExplanation;
    _data['category'] = category.toJson();
    _data['productStatusCd'] = productStatusCd;
    _data['heartNum'] = heartNum;
    _data['productCost'] = productCost;
    _data['exchangeCostRange'] = exchangeCostRange;
    return _data;
  }
}

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
  });
  late final int categoryId;
  late final String categoryName;

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categoryId'] = categoryId;
    _data['categoryName'] = categoryName;
    return _data;
  }
}

class Pageable {
  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });
  late final Sort sort;
  late final int pageNumber;
  late final int pageSize;
  late final int offset;
  late final bool paged;
  late final bool unpaged;

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = Sort.fromJson(json['sort']);
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    offset = json['offset'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sort'] = sort.toJson();
    _data['pageNumber'] = pageNumber;
    _data['pageSize'] = pageSize;
    _data['offset'] = offset;
    _data['paged'] = paged;
    _data['unpaged'] = unpaged;
    return _data;
  }
}

class Sort {
  Sort({
    required this.sorted,
    required this.unsorted,
    required this.empty,
  });
  late final bool sorted;
  late final bool unsorted;
  late final bool empty;

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sorted'] = sorted;
    _data['unsorted'] = unsorted;
    _data['empty'] = empty;
    return _data;
  }
}
