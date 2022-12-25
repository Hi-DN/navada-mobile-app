import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class SigninResponse {
  String? accessToken;
  String? refreshToken;
  UserDto? user;
  OAuthDto? oauth;

  SigninResponse({this.accessToken, this.refreshToken, this.user, this.oauth});

  SigninResponse.fromJson(Map<String, dynamic> json) {
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
  SigninPlatform? signinPlatform;

  OAuthDto({this.userEmail, this.signinPlatform});

  OAuthDto.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    signinPlatform = SigninPlatform.strToEnum(json['signinPlatform']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userEmail'] = userEmail;
    data['platform'] = signinPlatform;
    return data;
  }
}
