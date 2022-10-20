import 'requtest_dto_model.dart';

class RequestListResponse {
  RequestListResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.dataList,
  });
  late final bool success;
  late final int code;
  late final String message;
  late final List<RequestDto> dataList;

  RequestListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    dataList = List.from(json['dataList'])
        .map((e) => RequestDto.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    data['dataList'] = dataList.map((e) => e.toJson()).toList();
    return data;
  }
}
