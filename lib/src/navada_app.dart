import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_provider.dart';
import 'package:navada_mobile_app/src/view/ui/home.dart';
import 'package:navada_mobile_app/src/view/ui/login.dart';
import 'package:provider/provider.dart';

class NavadaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: MaterialApp(
          title: 'Navada',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Login(),
          routes: {
            Home.routeName: (context) => Home(),
          },
        ));
  }
}
