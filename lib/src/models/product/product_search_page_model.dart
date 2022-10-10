import '../../utilities/enums.dart';

class ProductSearchPageModel {
  bool? success;
  int? code;
  String? message;
  List<ProductSearchDtoModel>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? empty;
  bool? first;
  bool? last;
  int? numberOfElements;
  int? size;

  ProductSearchPageModel(
      {this.success,
      this.code,
      this.message,
      this.content,
      this.pageable,
      this.totalPages,
      this.totalElements,
      this.empty,
      this.first,
      this.last,
      this.numberOfElements,
      this.size});

  ProductSearchPageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['content'] != null) {
      content = <ProductSearchDtoModel>[];
      json['content'].forEach((v) {
        content!.add(ProductSearchDtoModel.fromJson(v));
      });
    }
    pageable =
        json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    empty = json['empty'];
    first = json['first'];
    last = json['last'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    if (pageable != null) {
      data['pageable'] = pageable!.toJson();
    }
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

class ProductSearchDtoModel {
  int? productId;
  String? productName;
  String? userNickname;
  int? productCost;
  int? exchangeCostRange;
  ProductExchangeStatusCd? productExchangeStatusCd;
  bool? like;

  ProductSearchDtoModel(
      {this.productId,
      this.productName,
      this.userNickname,
      this.productCost,
      this.exchangeCostRange,
      this.productExchangeStatusCd,
      this.like});

  ProductSearchDtoModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    userNickname = json['userNickname'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
    productExchangeStatusCd =
        ProductExchangeStatusCd.codeToEnum(json['productExchangeStatusCd']);
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = productId;
    data['productName'] = productName;
    data['userNickname'] = userNickname;
    data['productCost'] = productCost;
    data['exchangeCostRange'] = exchangeCostRange;
    data['productExchangeStatusCd'] = productExchangeStatusCd?.code;
    data['like'] = like;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? pageNumber;
  int? pageSize;
  int? offset;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
      this.pageNumber,
      this.pageSize,
      this.offset,
      this.paged,
      this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    offset = json['offset'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (sort != null) {
      data['sort'] = sort!.toJson();
    }
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['offset'] = offset;
    data['paged'] = paged;
    data['unpaged'] = unpaged;
    return data;
  }
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorted'] = sorted;
    data['unsorted'] = unsorted;
    data['empty'] = empty;
    return data;
  }
}
