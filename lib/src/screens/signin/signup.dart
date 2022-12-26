import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/custom_navigation_bar.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ScreenSize size = ScreenSize();
  late String userName, userNickname, userPhoneNum, userAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "회원가입"),
      body: Column(children: [
        TextFormField(
          style: styleR.copyWith(fontSize: size.getSize(16)),
          onChanged: (value) {
            setState(() { userName = value; });
          },
          decoration: InputDecoration(
            hintText: "이름",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0, vertical: size.getSize(10.0),
            ),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
          ),
        ),
        TextFormField(
          style: styleR.copyWith(fontSize: size.getSize(16)),
          onChanged: (value) {
            setState(() { userNickname = value; });
          },
          decoration: InputDecoration(
            hintText: "닉네임",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0, vertical: size.getSize(10.0),
            ),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
          ),
        ),
        TextFormField(
          style: styleR.copyWith(fontSize: size.getSize(16)),
          onChanged: (value) {
            setState(() { userPhoneNum = value; });
          },
          decoration: InputDecoration(
            hintText: "폰번호",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0, vertical: size.getSize(10.0),
            ),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
          ),
        ),
        TextFormField(
          style: styleR.copyWith(fontSize: size.getSize(16)),
          onChanged: (value) {
            setState(() { userAddress = value; });
          },
          decoration: InputDecoration(
            hintText: "주소",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0, vertical: size.getSize(10.0),
            ),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
          ),
        ),
        LongCircledBtn(text: "회원가입하기", onTap: () async {
          bool result = await Provider.of<UserProvider>(context, listen: false).signup(userName, userNickname, userPhoneNum, userAddress);
          if(result) Navigator.of(context).pushNamed(CustomNavigationBar.routeName);
        },)
      ]),
    );
  }
}