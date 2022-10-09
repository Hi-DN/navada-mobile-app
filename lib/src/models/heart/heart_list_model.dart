import 'package:navada_mobile_app/src/models/product/product_model.dart';

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
    final data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    data['content'] = content.map((e) => e.toJson()).toList();
    data['pageable'] = pageable.toJson();
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['empty'] = empty;
    data['first'] = first;
    data['last'] = last;
    data['numberOfElements'] = numberOfElements;
    data['size'] = size;
    return data;
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
  late final ProductModel product;

  HeartListContentModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    heartId = json['heartId'];
    product = ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['heartId'] = heartId;
    data['product'] = product.toJson();
    return data;
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
    final data = <String, dynamic>{};
    data['sort'] = sort.toJson();
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['offset'] = offset;
    data['paged'] = paged;
    data['unpaged'] = unpaged;
    return data;
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
    final data = <String, dynamic>{};
    data['sorted'] = sorted;
    data['unsorted'] = unsorted;
    data['empty'] = empty;
    return data;
  }
}
