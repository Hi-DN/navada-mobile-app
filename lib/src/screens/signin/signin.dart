import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:navada_mobile_app/src/models/oauth/signIn_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';
import 'package:navada_mobile_app/src/screens/signin/signup.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/custom_navigation_bar.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:provider/provider.dart';


class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);

    return Scaffold(
        appBar: CustomAppBar(titleText: "Appbar Test"),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text(
                  '로그인하기',
                ),
                onPressed: () {
                  UserProvider userProvider = Provider.of(context, listen: false);
                  userProvider.notifyListeners();
                  Navigator.of(context).pushNamed(CustomNavigationBar.routeName);
                },
              ),
              const Space(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 204, 0)),
                child: const Text(
                  '카톡 로그인하기',
                ),
                onPressed: () async {
                  bool isInstalled = await isKakaoTalkInstalled();
                  OAuthToken? token;
                  UserService userService = UserService();

                    if (isInstalled) {
                      try {
                          token = await UserApi.instance.loginWithKakaoTalk();
                      } catch (error) {
                        debugPrint('카카오톡으로 로그인 실패 $error');
                        if (error is PlatformException && error.code == 'CANCELED') {
                            return;
                        }
                        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
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
                  final url = Uri.https('kapi.kakao.com', '/v2/user/me');

                  final response = await http.get(
                    url,
                    headers: {
                      HttpHeaders.authorizationHeader: 'Bearer ${token!.accessToken}'
                    },
                  );

                  final profileInfo = json.decode(response.body);
                  print(profileInfo.toString());
                  print(profileInfo["kakao_account"]["email"]);
                  print(profileInfo["properties"]["nickname"]);
                  String email = profileInfo["kakao_account"]["email"].toString();
                  String nickname = profileInfo["properties"]["nickname"].toString();

                  SignInResponse? signInResponse = await userService.signInByOAuth(email, nickname, SignInPlatform.KAKAO);

                    Provider.of<UserProvider>(context, listen: false).setOAuthInfo(email, SignInPlatform.KAKAO);
                    if (signInResponse.user == null) {
                      // 회원가입 진행
                      // Provider.of<UserProvider>(context, listen: false).setOAuthInfo(signInResponse.oauth);
                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const SignUp()));

                    } else {
                      // 로그인 진행
                      Provider.of<UserProvider>(context, listen: false).setUser(signInResponse.user!, email, SignInPlatform.KAKAO);
                      Navigator.of(context).pushNamed(CustomNavigationBar.routeName);
                    }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
                child: const Text(
                  '구글 로그인하기',
                ),
                onPressed: () async {
                  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                  UserService userService = UserService();
                  
                  if(googleUser != null){
                    SignInResponse? response = await userService.signInByOAuth(googleUser.email, googleUser.displayName ?? "", SignInPlatform.GOOGLE);
                    if (response.user == null) {
                      // 회원가입 진행
                      Provider.of<UserProvider>(context, listen: false).setOAuthInfo(googleUser.email, SignInPlatform.GOOGLE);
                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const SignUp()));

                    } else {
                      // 로그인 진행
                      Provider.of<UserProvider>(context, listen: false).setUser(response.user!, googleUser.email, SignInPlatform.GOOGLE);
                      Navigator.of(context).pushNamed(CustomNavigationBar.routeName);
                    }
                  }

                  
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 96, 206, 57)),
                child: const Text(
                  '네이버 로그인하기',
                ),
                onPressed: () async {
                  final NaverLoginResult result = await FlutterNaverLogin.logIn();
                  UserService userService = UserService();
                  
                  SignInResponse? response = await userService.signInByOAuth(result.account.email, result.account.nickname, SignInPlatform.NAVER);
                  if (response.user == null) {
                    // 회원가입 진행
                    Provider.of<UserProvider>(context, listen: false).setOAuthInfo(result.account.email, SignInPlatform.NAVER);
                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const SignUp()));

                  } else {
                    // 로그인 진행
                    Provider.of<UserProvider>(context, listen: false).setUser(response.user!, result.account.email, SignInPlatform.NAVER);
                    Navigator.of(context).pushNamed(CustomNavigationBar.routeName);
                  }
                  debugPrint(result.toString());
                },
              ),
            ],
          ),
        ));
  }
}
