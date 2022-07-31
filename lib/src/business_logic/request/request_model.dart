import 'package:navada_mobile_app/src/view/utils/enums.dart';

class PageResponse {
  bool? success;
  int? code;
  String? message;
  List<RequestModel>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? empty;
  bool? first;
  bool? last;
  int? numberOfElements;
  int? size;

  PageResponse(
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

  PageResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['content'] != null) {
      content = <RequestModel>[];
      json['content'].forEach((v) {
        content!.add(RequestModel.fromJson(v));
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

class RequestModel {
  int? requestId;
  ExchangeStatusCd? exchangeStatusCd;
  String? acceptorNickname;
  String? requesterNickName;
  String? acceptorProductName;
  String? requesterProductName;
  int? acceptorProductCost;
  int? requesterProductCost;
  int? acceptorProductCostRange;
  int? requesterProductCostRange;

  RequestModel(
      {this.requestId,
      this.exchangeStatusCd,
      this.acceptorNickname,
      this.requesterNickName,
      this.acceptorProductName,
      this.requesterProductName,
      this.acceptorProductCost,
      this.requesterProductCost,
      this.acceptorProductCostRange,
      this.requesterProductCostRange});

  RequestModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    exchangeStatusCd = ExchangeStatusCd.intToEnum(json['exchangeStatusCd']);
    acceptorNickname = json['acceptorNickname'];
    requesterNickName = json['requesterNickName'];
    acceptorProductName = json['acceptorProductName'];
    requesterProductName = json['requesterProductName'];
    acceptorProductCost = json['acceptorProductCost'];
    requesterProductCost = json['requesterProductCost'];
    acceptorProductCostRange = json['acceptorProductCostRange'];
    requesterProductCostRange = json['requesterProductCostRange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['exchangeStatusCd'] = exchangeStatusCd!.code.toString();
    data['acceptorNickname'] = acceptorNickname;
    data['requesterNickName'] = requesterNickName;
    data['acceptorProductName'] = acceptorProductName;
    data['requesterProductName'] = requesterProductName;
    data['acceptorProductCost'] = acceptorProductCost;
    data['requesterProductCost'] = requesterProductCost;
    data['acceptorProductCostRange'] = acceptorProductCostRange;
    data['requesterProductCostRange'] = requesterProductCostRange;
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
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empty'] = empty;
    data['sorted'] = sorted;
    data['unsorted'] = unsorted;
    return data;
  }
}
