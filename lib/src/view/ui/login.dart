import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/utils/custom_appbar.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);

    return Scaffold(
        appBar: CustomAppBar(titleText: "Appbar Test"),
        body: Container(
          child: const Text("하염"),
        ));
  }
}
