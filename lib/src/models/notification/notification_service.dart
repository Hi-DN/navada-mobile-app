import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/notification/notification_list_model.dart';

class NotificationService {
  final _httpClient = HttpClient();

  // 사용자별 알림 목록 조회
  Future<NotificationListModel?> getNotificationsByUser(int userId) async {
    Map<String, dynamic> data = await _httpClient
        .getRequest('/user/$userId/notifications', tokenYn: true);

    if (data['success']) {
      return NotificationListModel.fromJson(data);
    } else {
      return null;
    }
  }
}
