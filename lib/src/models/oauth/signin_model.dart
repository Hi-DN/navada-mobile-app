import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class SignInResponse {
  String? accessToken;
  String? refreshToken;
  UserDto? user;
  OAuthDto? oauth;

  SignInResponse({this.accessToken, this.refreshToken, this.user, this.oauth});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? UserDto.fromJson(json['user']) : null;
    oauth = json['oauth'] != null ? OAuthDto.fromJson(json['oauth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (oauth != null) {
      data['oauth'] = oauth!.toJson();
    }
    return data;
  }
}

class OAuthDto {
  String? userEmail;
  SignInPlatform? signInPlatform;

  OAuthDto({this.userEmail, this.signInPlatform});

  OAuthDto.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    signInPlatform = SignInPlatform.strToEnum(json['signInPlatform']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userEmail'] = userEmail;
    data['platform'] = signInPlatform;
    return data;
  }
}
