import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';

class ModifyUserInfoViewModel extends ChangeNotifier {
  bool isNicknameAvailable = true;

  setNicknameAvailable(bool val, String newNickname) {
    if(newNickname == UserProvider.user.userNickname) {
      isNicknameAvailable = true;
    } else {
      isNicknameAvailable = val;
    }
    notifyListeners();
  }
}