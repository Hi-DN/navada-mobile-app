import 'package:flutter/cupertino.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class UserProvider extends ChangeNotifier {
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

  User user = User(
      userId: userId,
      userName: userName,
      userNickname: userNickname,
      userEmail: userEmail,
      userPhoneNum: userPhoneNum,
      userAddress: userAddress,
      userLevel: UserLevel.strToEnum(userLevel),
      userRating: userRating,
      userTradeCount: userTradeCount,
      userRatingCount: userRatingCount);

  void userNotifyListeners() {
    notifyListeners();
  }
}
