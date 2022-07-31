import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_provider.dart';
import 'package:navada_mobile_app/src/view/ui/home/home_view.dart';
import 'package:navada_mobile_app/src/view/ui/login.dart';
import 'package:navada_mobile_app/src/view/utils/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class NavadaApp extends StatelessWidget {
  const NavadaApp({Key? key}) : super(key: key);

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
          home: const Login(),
          routes: {
            HomeView.routeName: (context) => const HomeView(),
            CustomNavigationBar.routeName: (context) => const CustomNavigationBar(),
          },
        ));
  }
}
