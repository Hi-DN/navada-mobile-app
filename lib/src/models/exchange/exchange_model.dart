import 'package:navada_mobile_app/src/models/product/product_model.dart';

class ExchangePageResponse {
  bool? success;
  int? code;
  String? message;
  List<ExchangeModel>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? empty;
  bool? first;
  bool? last;
  int? numberOfElements;
  int? size;

  ExchangePageResponse(
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

  ExchangePageResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['content'] != null) {
      content = <ExchangeModel>[];
      json['content'].forEach((v) {
        content!.add(ExchangeModel.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? Pageable.fromJson(json['pageable'])
        : null;
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    empty = json['empty'];
    first = json['first'];
    last = json['last'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class ExchangeModel {
  String? createdDate;
  String? modifiedDate;
  int? exchangeId;
  ProductModel? acceptorProduct;
  ProductModel? requesterProduct;
  bool? acceptorConfirmYn;
  bool? requesterConfirmYn;
  bool? exchangeCompleteYn;
  String? exchangeCompleteDt;
  double? acceptorRating;
  double? requesterRating;
  bool? acceptorHistoryDeleteYn;
  bool? requesterHistoryDeleteYn;

  ExchangeModel(
      {this.createdDate,
      this.modifiedDate,
      this.exchangeId,
      this.acceptorProduct,
      this.requesterProduct,
      this.acceptorConfirmYn,
      this.requesterConfirmYn,
      this.exchangeCompleteYn,
      this.exchangeCompleteDt,
      this.acceptorRating,
      this.requesterRating,
      this.acceptorHistoryDeleteYn,
      this.requesterHistoryDeleteYn});

  ExchangeModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    exchangeId = json['exchangeId'];
    acceptorProduct = json['acceptorProduct'] != null
        ? ProductModel.fromJson(json['acceptorProduct'])
        : null;
    requesterProduct = json['requesterProduct'] != null
        ? ProductModel.fromJson(json['requesterProduct'])
        : null;
    acceptorConfirmYn = json['acceptorConfirmYn'];
    requesterConfirmYn = json['requesterConfirmYn'];
    exchangeCompleteYn = json['exchangeCompleteYn'];
    exchangeCompleteDt = json['exchangeCompleteDt'];
    acceptorRating = json['acceptorRating'];
    requesterRating = json['requesterRating'];
    acceptorHistoryDeleteYn = json['acceptorHistoryDeleteYn'];
    requesterHistoryDeleteYn = json['requesterHistoryDeleteYn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['exchangeId'] = exchangeId;
    if (acceptorProduct != null) {
      data['acceptorProduct'] = acceptorProduct!.toJson();
    }
    if (requesterProduct != null) {
      data['requesterProduct'] = requesterProduct!.toJson();
    }
    data['acceptorConfirmYn'] = acceptorConfirmYn;
    data['requesterConfirmYn'] = requesterConfirmYn;
    data['exchangeCompleteYn'] = exchangeCompleteYn;
    data['exchangeCompleteDt'] = exchangeCompleteDt;
    data['acceptorRating'] = acceptorRating;
    data['requesterRating'] = requesterRating;
    data['acceptorHistoryDeleteYn'] = acceptorHistoryDeleteYn;
    data['requesterHistoryDeleteYn'] = requesterHistoryDeleteYn;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageSize;
  int? pageNumber;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
      this.offset,
      this.pageSize,
      this.pageNumber,
      this.paged,
      this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageSize = json['pageSize'];
    pageNumber = json['pageNumber'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sort != null) {
      data['sort'] = sort!.toJson();
    }
    data['offset'] = offset;
    data['pageSize'] = pageSize;
    data['pageNumber'] = pageNumber;
    data['paged'] = paged;
    data['unpaged'] = unpaged;
    return data;
  }
}

class Sort {
  bool? empty;
  bool? unsorted;
  bool? sorted;

  Sort({this.empty, this.unsorted, this.sorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    unsorted = json['unsorted'];
    sorted = json['sorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empty'] = empty;
    data['unsorted'] = unsorted;
    data['sorted'] = sorted;
    return data;
  }
}
