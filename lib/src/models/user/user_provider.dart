import 'package:flutter/cupertino.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class UserProvider extends ChangeNotifier {
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

    try {
      UserDto newUser = await _userService.signup(params);
      setUserInfo(newUser);
      return true;
    } catch (e) {
      Exception('signup() fail!');
      return false;
    }
  }

  Future<bool> modifyUser(int userId, UserParams userParams) async {
    UserDto? modifiedUser = await _userService.modifyUser(userId, userParams);
    if (modifiedUser != null) {
      setUserInfo(modifiedUser);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> withdraw(int userId) async {
    return await _userService.withdraw(userId);
  }

  // ======= 알림 확인 여부
  bool? _userNotiReadYn;
  bool? get userNotiReadYn => _userNotiReadYn;

  fetchUserNotiReadYn(int userId) async {
    _userNotiReadYn = await _userService.getNotiReadYnByUser(userId);
    notifyListeners();
  }

  setUserNotiReadYnTrue(int userId) async {
    bool? result = await _userService.patchNotiReadYnTrue(userId);
    if (result!) {
      _userNotiReadYn = true;
      notifyListeners();
    }
  }
}
