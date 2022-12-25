import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:navada_mobile_app/src/models/oauth/signin_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/models/user/user_service.dart';
import 'package:navada_mobile_app/src/screens/%08signin/signup.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/custom_navigation_bar.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:provider/provider.dart';


class Signin extends StatelessWidget {
  const Signin({Key? key}) : super(key: key);

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
                  if(token != null){
                    SigninResponse? response = await userService.signinByKakaoToken(token.accessToken);
                    if (response.user == null) {
                      // 회원가입 진행
                      Provider.of<UserProvider>(context, listen: false).setOAuthInfo(response.oauth!);
                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const SignUp()));

                    } else {
                      // 로그인 진행
                      Provider.of<UserProvider>(context, listen: false).setUser(response.oauth!, response.user!);
                      Navigator.of(context).pushNamed(CustomNavigationBar.routeName);
                    }
                  }
                  
                },
              ),
            ],
          ),
        ));
  }
}
