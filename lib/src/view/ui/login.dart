import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/utils/custom_appbar.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:provider/provider.dart';

import '../../business_logic/user/user_provider.dart';
import 'home.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);

    // api test
    // getProduct(1);

    return Scaffold(
        appBar: CustomAppBar(titleText: "Appbar Test"),
        body: Center(
          child: ElevatedButton(
            child: const Text(
              '로그인하기',
            ),
            onPressed: () {
              UserProvider userProvider = Provider.of(context, listen: false);
              userProvider.notifyListeners();
              Navigator.of(context).pushNamed(Home.routeName);
            },
          ),
        ));
  }
}
