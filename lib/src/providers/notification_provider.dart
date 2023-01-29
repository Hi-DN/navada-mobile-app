import 'package:flutter/cupertino.dart';
import 'package:navada_mobile_app/src/models/notification/notification_list_model.dart';
import 'package:navada_mobile_app/src/models/notification/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  NotificationListModel? _notificationListModel;
  NotificationListModel? get notificationListModel => _notificationListModel;

  List<NotificationContentModel>? _notificationList;
  List<NotificationContentModel>? get notificationList => _notificationList;

  fetchNotifications(int userId) async {
    NotificationListModel? model =
        await _notificationService.getNotificationsByUser(userId);

    if (model != null) {
      _notificationListModel = model;
      _notificationList = model.dataList;

      notifyListeners();
    }
  }
}
