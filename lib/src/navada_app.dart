import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_exchange_provider.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_request_provider.dart';
import 'package:navada_mobile_app/src/providers/my_products_provider.dart';
import 'package:navada_mobile_app/src/providers/signin_provider.dart';
import 'package:navada_mobile_app/src/screens/signIn/signIn.dart';
import 'package:navada_mobile_app/src/screens/tab1_home/home/home_view.dart';
import 'package:navada_mobile_app/src/screens/tab4_exchange/my_exchange/my_exchanges_view.dart';
import 'package:navada_mobile_app/src/widgets/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class NavadaApp extends StatelessWidget {
  const NavadaApp({Key? key, required this.navigatorKey}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => SignInProvider()),
          ChangeNotifierProvider(create: (context) => MyExchangesExchangeProvider()),
          ChangeNotifierProvider(create: (context) => MyExchangesRequestProvider()),
          ChangeNotifierProvider(create: (context) => MyProductsProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Navada',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: SignIn(),
          routes: {
            SignIn.routeName:(context) => SignIn(),
            HomeView.routeName: (context) => const HomeView(),
            CustomNavigationBar.routeName: (context) =>const CustomNavigationBar(),
            MyExchangesView.routeName: (context) => const MyExchangesView()
          },
          onGenerateRoute: (settings) {
            if (settings.name == SignIn.routeName) {
              return PageRouteBuilder(pageBuilder: (_, __, ___) => SignIn());
            }

            return null;
          }
        ));
  }
}
