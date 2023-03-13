import 'dart:convert';
import 'dart:io';

import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:navada_mobile_app/src/models/oauth/signIn_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';


class SignInProvider with ChangeNotifier {
  UserService userService = UserService();

  Future<OAuthToken?> getKakaoToken() async {
    bool isInstalled = await isKakaoTalkInstalled();
    OAuthToken? token;
    if (isInstalled) {
      try {
          token = await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');
        if (error is PlatformException && error.code == 'CANCELED') {
            return null;
        }
        try {
            token = await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {
            debugPrint('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
      } catch (error) {
        debugPrint('카카오계정으로 로그인 실패 $error');
      }
    }
    return token;
  }

  Future<KakaoUserInfo> getKakaoUserInfo(OAuthToken? token) async {
    final url = Uri.https('kapi.kakao.com', '/v2/user/me');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token!.accessToken}'
      },
    );

    final profileInfo = json.decode(response.body);
    String email = profileInfo["kakao_account"]["email"].toString();
    String nickname = profileInfo["properties"]["nickname"].toString();
    return KakaoUserInfo(email, nickname);
  }

  Future<SignInResponse> signInByOAuth(String email, SignInPlatform platform) async {
    return await userService.signInByOAuth(email, platform);
  }

  Future<void> signOut() async {
    await signOutSocial();
    await userService.signOut(UserProvider.user.userId!);
    initializeTokens();
  }

  initializeTokens() {
    HttpClient.setAccessToken("");
    HttpClient.setRefreshToken("");
  }

  Future<bool> withdraw() async {
    disconnectSocialInfo();
    
    bool result = await userService.withdraw(UserProvider.user.userId!);
    if(result){
      initializeTokens();
      return true;
    } else {
      return false;
    }
  }

  signOutSocial() async {
    switch(UserProvider.user.signInPlatform) {
      case SignInPlatform.KAKAO:
        await UserApi.instance.logout();
        break;
      case SignInPlatform.GOOGLE:
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        break;
      default: //NAVER
        await FlutterNaverLogin.logOut();
        break;
    }
  }

  disconnectSocialInfo() async {
    switch(UserProvider.user.signInPlatform) {
      case SignInPlatform.KAKAO:
        await UserApi.instance.unlink();
        break;
      case SignInPlatform.GOOGLE:
        GoogleSignIn googleSignIn = GoogleSignIn();
        googleSignIn.disconnect();
        break;
      default: //NAVER
        await FlutterNaverLogin.logOutAndDeleteToken();
        break;
    }
  }
}

class KakaoUserInfo {
  late String email;
  late String nickname;
  KakaoUserInfo(this.email, this.nickname);
}