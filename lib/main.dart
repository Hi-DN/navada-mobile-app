import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/navada_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  runApp(NavadaApp());
}
