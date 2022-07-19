import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/ui/login.dart';

class NavadaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navada',
      theme: ThemeData(
        // fontFamily: 'AppleSDGothicNeo',
        primarySwatch: Colors.green,
      ),
      home: Login(),
    );
  }
}
