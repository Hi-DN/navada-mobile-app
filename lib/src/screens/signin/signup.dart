import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/screens/signIn/signIn.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ScreenSize size = ScreenSize();
  String userName="", userNickname="", userPhoneNum="", userAddress="";

  final FocusNode _nameFNode = FocusNode();
  final FocusNode _nicknameFNode = FocusNode();
  final FocusNode _phoneNumFNode = FocusNode();
  final FocusNode _addressFNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameFNode.dispose();
    _nicknameFNode.dispose();
    _phoneNumFNode.dispose();
    _addressFNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(
        titleText: "회원가입", 
        leadingYn: true, 
        onTap: () => Navigator.of(context).pop()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.getSize(26)),
        child: Column(children: [
          const Space(height: 20),
          _nameField(),
          const Space(height: 20),
          _nicknameField(),
          const Space(height: 20),
          _phoneNumField(),
          const Space(height: 20),
          _addressField(),
          const Expanded(child: SizedBox()),
          LongCircledBtn(text: "회원가입하기", onTap: () => handleSignUp()),
          const Space(height: 40)
        ]),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      focusNode: _nameFNode,
      style: styleR.copyWith(fontSize: size.getSize(16)),
      onChanged: (value) {
        setState(() { userName = value; });
      },
      decoration: InputDecoration(
        hintText: "이름을 입력해주세요",
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0, vertical: size.getSize(10.0),
        ),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
      ),
    );
  }

  Widget _nicknameField() {
    return TextFormField(
      focusNode: _nicknameFNode,
      style: styleR.copyWith(fontSize: size.getSize(16)),
      onChanged: (value) {
        setState(() { userNickname = value; });
      },
      decoration: InputDecoration(
        hintText: "닉네임을 입력해주세요",
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0, vertical: size.getSize(10.0),
        ),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
      ),
    );
  }

  Widget _phoneNumField() {
    return TextFormField(
      focusNode: _phoneNumFNode,
      style: styleR.copyWith(fontSize: size.getSize(16)),
      onChanged: (value) {
        setState(() { userPhoneNum = value; });
      },
      decoration: InputDecoration(
        hintText: "핸드폰 번호를 입력해주세요",
        helperText: "'010-0000-0000' 형식으로 입력해주세요",
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0, vertical: size.getSize(10.0),
        ),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
      ),
    );
  }

  Widget _addressField() {
    return TextFormField(
      focusNode: _addressFNode,
      style: styleR.copyWith(fontSize: size.getSize(16)),
      onChanged: (value) {
        setState(() { userAddress = value; });
      },
      decoration: InputDecoration(
        hintText: "주소를 입력해주세요",
        helperText: "'OO시 OO구' 형식으로 입력해주세요",
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0, vertical: size.getSize(10.0),
        ),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey183)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: green)),
      ),
    );
  }

  handleSignUp() async {
    if (!_checkValid(userName)) {
      _checkField(_nameFNode, "이름을 입력해주세요!");
    } else if (!_checkValid(userNickname)) {
      _checkField(_nicknameFNode, "닉네임을 입력해주세요!");
    } else if (!_checkValid(userPhoneNum)) {
      _checkField(_phoneNumFNode, "핸드폰 번호를 입력해주세요!");
    } else if (!_checkValid(userAddress)) {
      _checkField(_addressFNode, "주소를 입력해주세요!");
    } else {
      try {
        bool result = await Provider.of<UserProvider>(context, listen: false).signup(userName, userNickname, userPhoneNum, userAddress);

        if(result) {
          _showSignupConfirmDialog(context);
        } else {
          _showUserExistsDialog(context);
        }

      } catch(e) {
        _showUserExistsDialog(context);
      }
    }
  }

  bool _checkValid(String? value) {
    if(value == null || value == "") return false;
    return true;
  }

  _checkField(FocusNode fnode, String snackBarText) {
    FocusScope.of(context).requestFocus(fnode);
    _showSnackBarDurationForSec(snackBarText);
  }

  _showSnackBarDurationForSec(String snackBarText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: R16Text(text: snackBarText, textColor: white),
    ));
  }

  _showSignupConfirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const R14Text(text: "Navada Village에 오신 것을 환영합니다!\n로그인하러 가볼까요?!😆🥰❤️"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, SignIn.routeName, (route)=> false),
              child: const R14Text(text: "확인", textColor: green),
            )
          ],
        );
      });
  }

  _showUserExistsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const R14Text(text: "이미 존재하는 회원입니다.\n다른 플랫폼으로 로그인을 진행해주세요!"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, SignIn.routeName, (route)=> false),
              child: const R14Text(text: "확인", textColor: green),
            )
          ],
        );
      });
  }
}
