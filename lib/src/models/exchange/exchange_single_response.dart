import 'exchange_model.dart';

class ExchangeSingleResponse {
  bool? success;
  int? code;
  String? message;
  Exchange? data;

  ExchangeSingleResponse({this.success, this.code, this.message, this.data});

  ExchangeSingleResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Exchange.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
