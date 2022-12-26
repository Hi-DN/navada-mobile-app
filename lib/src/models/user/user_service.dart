import 'package:navada_mobile_app/src/models/oauth/signIn_model.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

import '../api/http_client.dart';

HttpClient _httpClient = HttpClient();

class UserService {
  // 회원 존재여부 (카카오토큰 로그인)
  Future<SignInResponse> signInByKakaoToken(String kakaoAccessToken) async {
    Map<String, dynamic> response = await _httpClient.postRequest(
        '/signIn/kakao', 
        {
          "accessToken" : kakaoAccessToken
        },
        tokenYn: false);

    if (response['success']) {
      return SignInResponse.fromJson(response['data']);
    } else {
      throw Exception('signInByKakaoToken() fail!');
    }
  }

  // 회원 존재여부 (구글, 네이버 로그인)
  Future<SignInResponse> signInByOAuth(String userEmail, String userNickname, SignInPlatform platform) async {
    Map<String, dynamic> response = await _httpClient.postRequest(
        '/signin/oauth', 
        {
          "userEmail" : userEmail,
          "userNickname": userNickname,
          "signInPlatform": platform.name
        },
        tokenYn: false);

    if (response['success']) {
      return SignInResponse.fromJson(response['data']);
    } else {
      throw Exception('signInByOAuth() fail!');
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
