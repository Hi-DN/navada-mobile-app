import 'exchange_dto_model.dart';

class ExchangeDtoPageResponse {
  bool? success;
  int? code;
  String? message;
  List<ExchangeDtoModel>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? empty;
  bool? first;
  bool? last;
  int? numberOfElements;
  int? size;

  ExchangeDtoPageResponse(
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

  ExchangeDtoPageResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['content'] != null) {
      content = <ExchangeDtoModel>[];
      json['content'].forEach((v) {
        content!.add(ExchangeDtoModel.fromJson(v));
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
