import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/heart/heart_list_model.dart';

final HttpClient _httpClient = HttpClient();

//회원별 좋아요 목록 조회
Future<HeartListModel> getHeartsByUser(int userId, bool showAll) async {
  Map<String, dynamic> data =
      await _httpClient.getRequest('/user/$userId/hearts?showAll=$showAll');

  if (data['success']) {
    return HeartListModel.fromJson(data);
  } else {
    throw Exception('좋아요 목록 조회 fail');
  }
}

//좋아요 취소
Future<bool> deleteHeart(int heartId) async {
  Map<String, dynamic> data =
      await _httpClient.deleteRequest('/heart/$heartId');

  if (data['success']) {
    return true;
  } else {
    throw Exception('좋아요 취소 실패');
  }
}
