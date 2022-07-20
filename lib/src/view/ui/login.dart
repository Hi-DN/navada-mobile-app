import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business_logic/user/user_provider.dart';
import 'home.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: const Text(
          '로그인하기',
        ),
        onPressed: () {
          UserProvider userProvider = Provider.of(context, listen: false);
          userProvider.notifyListeners();

          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Home()));
        },
      ),
    ));
  }
}
