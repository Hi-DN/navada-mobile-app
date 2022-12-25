import 'package:flutter/cupertino.dart';
import 'package:navada_mobile_app/src/models/oauth/signin_model.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';

class UserProvider extends ChangeNotifier {
  /* 삭제? */
  static int userId = 1;
  static String userName = "홍길동";
  static String userNickname = "홍길동입니다아아아아";
  static String userEmail = "kim@naver.com";
  static String userPhoneNum = "010-1111-2222";
  static String userAddress = "서울시 서초구 서초3동";
  static String userLevel = "LV1_OUTSIDER";
  static double userRating = 4.5;
  static int userTradeCount = 10;
  static int userRatingCount = 10;
  /* 삭제? */

  late User user = User();

  final UserService _userService = UserService();

  void setUser(OAuthDto oauthParams, UserDto userParams) {
    setOAuthInfo(oauthParams);
    setUserInfo(userParams);
    notifyListeners();
  }

  void setOAuthInfo(OAuthDto params) {
    user.userEmail = params.userEmail!;
    user.signinPlatform = params.signinPlatform!;
    notifyListeners();
  }

  void setUserInfo(UserDto params) {
    user.userId = params.userId;
    user.userName = params.userName;
    user.userNickname = params.userNickname;
    user.userAddress = params.userAddress;
    user.userLevel = params.userLevel;
    user.userRating = params.userRating;
    user.userTradeCount = params.userTradeCount;
    user.userRatingCount = params.userRatingCount;
    notifyListeners();
  }

  void userNotifyListeners() {
    notifyListeners();
  }

  Future<bool> signup(String userName, String userNickname, String userPhoneNum, String userAddress) async {
    UserParams params = UserParams(
      userName: userName, userNickname: userNickname, userPhoneNum: userPhoneNum, userAddress: userAddress,
      userEmail: user.userEmail!, signinPlatform: user.signinPlatform!);
    UserDto newUser = await _userService.signup(params);
    setUserInfo(newUser);
    return true;
  }
}
