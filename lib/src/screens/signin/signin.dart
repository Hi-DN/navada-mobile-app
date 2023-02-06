
import 'package:flutter/material.dart';

import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/oauth/signIn_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/signin_provider.dart';
import 'package:navada_mobile_app/src/screens/signin/signup.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_navigation_bar.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';


class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  static const routeName = 'signin';
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);
    _context = context;

    return Scaffold(
      backgroundColor: white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Space(height: 40),
          _logo(),
          const Space(height: 170),
          _loginTestBtn(),
          const Space(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            _kakaoBtn(),
            const Space(width: 20),
            _googleBtn(),
            const Space(width: 20),
            _naverBtn()
          ])
        ],
      ));
  }

  Widget _logo() {
    ScreenSize size = ScreenSize();
    return Image.asset(
      'assets/images/logo.png',
      width: size.getSize(280.0),
      height: size.getSize(160.0),
    );
  }

  Widget _loginTestBtn() {
    return GestureDetector(
      onTap: () {
        UserProvider userProvider = Provider.of(_context!, listen: false);
        userProvider.notifyListeners();
        Navigator.of(_context!).pushNamed(CustomNavigationBar.routeName);
      },
      child: const R14Text(text: '로그인(테스트용)', textColor: grey153,)
    );
  }

  Widget _kakaoBtn() {
    return Card(
      elevation: 18.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: const Color(0xFFFEE500),
      margin: EdgeInsets.zero,
      child: Ink.image(
        image: const AssetImage('assets/images/kakao_logo.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: () async {
            SignInProvider provider = Provider.of<SignInProvider>(_context!, listen: false);
            OAuthToken? token = await provider.getKakaoToken();
            if(token != null) {
              handleSignIn(token.accessToken, SignInPlatform.KAKAO);
            }
          },
        ),
      ),
    );
  }

  Widget _googleBtn() {
    return Card(
      elevation: 18.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Ink.image(
          image: const AssetImage('assets/images/google_logo.png'),
          width: 34,
          height: 34,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
            onTap: () async {
              final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
              if(googleUser != null){
                GoogleSignInAuthentication authentication = await googleUser.authentication;
                handleSignIn(authentication.accessToken!, SignInPlatform.GOOGLE);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _naverBtn() {
    return Card(
      elevation: 18.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: Ink.image(
        image: const AssetImage('assets/images/naver_logo.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: () async {
            await FlutterNaverLogin.logIn();
            NaverAccessToken accessToken = await FlutterNaverLogin.currentAccessToken;
            handleSignIn(accessToken.accessToken, SignInPlatform.NAVER);
          },
        ),
      ),
    );
  }

  handleSignIn(String token, SignInPlatform platform) async {
    SignInResponse? response = await Provider.of<SignInProvider>(_context!, listen: false).signInByOAuth(token, platform);
    if (response.user == null) {
      // 회원가입 진행
      Provider.of<UserProvider>(_context!, listen: false).setOAuthInfo(response.oauth!.userEmail!, platform);
      Navigator.push(_context!,MaterialPageRoute(builder: (BuildContext context) => const SignUp()));

    } else {
      // 로그인 진행
      HttpClient.setAccessToken(response.accessToken!);
      HttpClient.setRefreshToken(response.refreshToken!);
      Provider.of<UserProvider>(_context!, listen: false).setUser(response.user!, response.oauth!.userEmail!, platform);
      Navigator.of(_context!).pushNamed(CustomNavigationBar.routeName);
    }
  }
}
