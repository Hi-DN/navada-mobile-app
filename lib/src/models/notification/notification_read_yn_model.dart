class NotificationReadYnModel {
  NotificationReadYnModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final int code;
  late final String message;
  late final bool data;

  NotificationReadYnModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    data['data'] = data;
    return data;
  }
}
