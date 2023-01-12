import 'package:flutter/cupertino.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class UserProvider extends ChangeNotifier {
  /* 삭제? */
  // static int userId = 1;
  // static String userName = "홍길동";
  // static String userNickname = "홍길동입니다아아아아";
  // static String userEmail = "kim@naver.com";
  // static String userPhoneNum = "010-1111-2222";
  // static String userAddress = "서울시 서초구 서초3동";
  // static String userLevel = "LV1_OUTSIDER";
  // static double userRating = 4.5;
  // static int userTradeCount = 10;
  // static int userRatingCount = 10;
  /* 삭제? */

  static User user = User();

  final UserService _userService = UserService();

  void setUser(UserDto userParams, String email, SignInPlatform platform) {
    setOAuthInfo(email, platform);
    setUserInfo(userParams);
    notifyListeners();
  }

  void setOAuthInfo(String email, SignInPlatform platform) {
    user.userEmail = email;
    user.signInPlatform = platform;
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
    user.userPhoneNum = params.userPhoneNum;
    notifyListeners();
  }

  void userNotifyListeners() {
    notifyListeners();
  }

  Future<bool> signup(String userName, String userNickname, String userPhoneNum,
      String userAddress) async {
    UserParams params = UserParams(
        userName: userName,
        userNickname: userNickname,
        userPhoneNum: userPhoneNum,
        userAddress: userAddress,
        userEmail: user.userEmail!,
        signInPlatform: user.signInPlatform!);
    UserDto newUser = await _userService.signup(params);
    setUserInfo(newUser);
    return true;
  }
}
