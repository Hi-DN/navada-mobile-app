import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/heart/heart_list_model.dart';

class HeartService {
  final HttpClient _httpClient = HttpClient();

  //회원별 좋아요 목록 조회
  Future<HeartListModel> getHeartsByUser(int userId) async {
    Map<String, dynamic> data = await _httpClient.getRequest('/hearts/$userId');
    print(data);

    if (data['success']) {
      return HeartListModel.fromJson(data);
    } else {
      throw Exception('좋아요 목록 조회 fail');
    }
  }
}
