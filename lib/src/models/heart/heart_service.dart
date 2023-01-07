import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/heart/heart_list_model.dart';

final HttpClient _httpClient = HttpClient();

class HeartService {
  //회원별 좋아요 목록 조회
  Future<HeartListModel> getHeartsByUser(
      int userId, bool showAll, int page) async {
    Map<String, dynamic> data = await _httpClient
        .getRequest('/user/$userId/hearts?showAll=$showAll&page=$page');

    if (data['success']) {
      return HeartListModel.fromJson(data);
    } else {
      throw Exception('좋아요 목록 조회 fail');
    }
  }

//좋아요 등록
  Future<void> saveHeart(int productId, int userId) async {
    Map<String, dynamic> data = await _httpClient.postRequest(
        '/product/$productId/heart?userId=$userId', <String, dynamic>{});

    if (data['success']) {
      return;
    } else {
      throw Exception('좋아요 목록 조회 fail');
    }
  }

//좋아요 취소 by heartId
  Future<bool> deleteHeartByHeartId(int heartId) async {
    Map<String, dynamic> data =
        await _httpClient.deleteRequest('/heart/$heartId');

    if (data['success']) {
      return true;
    } else {
      throw Exception('좋아요 취소 실패');
    }
  }

//좋아요 취소 by product and user
  Future<bool> deleteHeartByProductAndUser(int productId, int userId) async {
    Map<String, dynamic> data = await _httpClient
        .deleteRequest('/product/$productId/heart?userId=$userId');

    if (data['success']) {
      return true;
    } else {
      throw Exception('좋아요 취소 실패');
    }
  }
}
