import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class ModifyUserInfoView extends StatelessWidget {
  ModifyUserInfoView({Key? key}) : super(key: key);

  // User user = UserProvider().user;
  final TextEditingController _nickNameController =
      TextEditingController(text: UserProvider.userNickname);
  final TextEditingController _emailController =
      TextEditingController(text: UserProvider.userEmail);
  final TextEditingController _phoneNumController =
      TextEditingController(text: UserProvider.userPhoneNum);
  final TextEditingController _addressController =
      TextEditingController(text: UserProvider.userAddress);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '계정 정보 수정',
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(children: [
              _userInfoSection(),
              const Space(height: 200.0),
              _modifyButton()
            ]),
          ),
        ),
      ),
    );
  }

  Widget _userInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _setField('닉네임', _nickNameController),
        _setField('이메일', _emailController),
        _setField('휴대폰 번호', _phoneNumController),
        _setField('주소', _addressController),
      ],
    );
  }

  Widget _setField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space(height: 25.0),
        B18Text(text: label),
        const Space(height: 10.0),
        SizedBox(
          height: 50.0,
          child: TextField(
            decoration: _inputDecoration(),
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  Widget _modifyButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: LongCircledBtn(
        text: '수정하기',
        backgroundColor: navy,
        onTap: () {},
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
        hintText: '* 필수 항목입니다.',
        hintStyle: TextStyle(color: Colors.redAccent, fontSize: 14.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: green),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Color(0xFFB7B7B7)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        contentPadding: EdgeInsets.only(left: 10.0));
  }
}
