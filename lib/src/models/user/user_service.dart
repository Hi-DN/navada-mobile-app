import 'package:navada_mobile_app/src/models/oauth/signin_model.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';

import '../api/http_client.dart';

HttpClient _httpClient = HttpClient();

class UserService {
  // 회원 존재여부 (카카오토큰 로그인)
  Future<SigninResponse> signinByKakaoToken(String kakaoAccessToken) async {
    Map<String, dynamic> response = await _httpClient.postRequest(
        '/user/signin/kakao', 
        {
          "accessToken" : kakaoAccessToken
        },
        tokenYn: false);

    if (response['success']) {
      return SigninResponse.fromJson(response['data']);
    } else {
      throw Exception('signinByKakaoToken() fail!');
    }
  }

  // 회원 가입
  Future<UserDto> signup(UserParams params) async {
    Map<String, dynamic> response = await _httpClient.postRequest(
        '/signup', params.toJson(),
        tokenYn: false);

    if (response['success']) {
      return UserDto.fromJson(response['data']);
    } else {
      throw Exception('signup() fail!');
    }
  }

  // 회원 단건 조회(상품 ID)
  Future<UserModel> getUserByProductId(int productId) async {
    Map<String, dynamic> data =
        await _httpClient.getRequest('/user?productId=$productId');

    if (data['success']) {
      return UserModel.fromJson(data);
    } else {
      throw Exception('getUserByProductId() fail!');
    }
  }

}
