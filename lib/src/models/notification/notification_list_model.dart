import 'package:navada_mobile_app/src/utilities/enums.dart';

class NotificationListModel {
  bool? success;
  int? code;
  String? message;
  List<NotificationContentModel>? dataList;

  NotificationListModel({this.success, this.code, this.message, this.dataList});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['dataList'] != null) {
      dataList = <NotificationContentModel>[];
      json['dataList'].forEach((v) {
        dataList!.add(NotificationContentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (dataList != null) {
      data['dataList'] = dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationContentModel {
  String? createdDate;
  String? modifiedDate;
  int? notificationId;
  String? notificationContent;
  NotificationType? notificationType;

  NotificationContentModel(
      {this.createdDate,
      this.modifiedDate,
      this.notificationId,
      this.notificationContent,
      this.notificationType});

  NotificationContentModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    notificationId = json['notificationId'];
    notificationContent = json['notificationContent'];
    notificationType = NotificationType.strToEnum(json['notificationType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['notificationId'] = notificationId;
    data['notificationContent'] = notificationContent;
    data['notificationType'] = notificationType;
    return data;
  }
}
