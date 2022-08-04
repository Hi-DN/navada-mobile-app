import 'package:flutter/cupertino.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class UserProvider extends ChangeNotifier {
  static int userId = 1;
  static String userName = "kim";
  static String userNickname = "mj";
  static String userEmail = "kim@naver.com";
  static String userPassword = "kim";
  static String userPhoneNum = "010-1111-2222";
  static String userAddress = "address";
  static String userLevel = "LV1_OUTSIDER";
  static double userRating = 0;
  static int userTradeCount = 0;
  static int userRatingCount = 0;

  UserModel userModel = UserModel(
      userId,
      userName,
      userNickname,
      userEmail,
      userPassword,
      userPhoneNum,
      userAddress,
      UserLevel.strToEnum(userLevel),
      userRating,
      userTradeCount,
      userRatingCount);

  void userNotifyListeners() {
    notifyListeners();
  }
}
