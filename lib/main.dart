import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:navada_mobile_app/src/models/oauth/app_key.dart';
import 'package:navada_mobile_app/src/navada_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: AppKey.kakaoNative);
  runApp(const NavadaApp());
}
