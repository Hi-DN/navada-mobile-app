import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_exchange_provider.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_request_provider.dart';
import 'package:navada_mobile_app/src/providers/my_products_provider.dart';
import 'package:navada_mobile_app/src/screens/home/home_view.dart';
import 'package:navada_mobile_app/src/screens/login.dart';
import 'package:navada_mobile_app/src/screens/my_exchange/my_exchanges_view.dart';
import 'package:navada_mobile_app/src/widgets/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class NavadaApp extends StatelessWidget {
  const NavadaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => MyExchangesExchangeProvider(UserProvider.userId)),
          ChangeNotifierProvider(create: (context) => MyExchangesRequestProvider(UserProvider.userId)),
          ChangeNotifierProvider(create: (context) => MyProductsProvider()),
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
            MyExchangesView.routeName: (context) => const MyExchangesView()
          }
        ));
  }
}
