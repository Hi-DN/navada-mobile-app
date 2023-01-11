// 계정 정보 설정
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/screens/tab5_mypage/account_management/setting_user_info/modify_user_info_view.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class SettingUserInfoView extends StatelessWidget {
  const SettingUserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '계정 정보 설정',
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: Container(
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 10.0, bottom: 30.0),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    User user = UserProvider.user;
    return Column(
      children: [
        _setInfo('이름', user.userName!),
        _setInfo('닉네임', user.userNickname!),
        _setInfo('이메일', user.userEmail!),
        _setInfo('휴대폰번호', user.userPhoneNum!),
        _setInfo('주소', user.userAddress!),
        const Expanded(child: SizedBox()),
        _modifyButton(context)
      ],
    );
  }

  Widget _setInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          SizedBox(width: 120.0, child: B18Text(text: label)),
          R18Text(text: value)
        ],
      ),
    );
  }

  Widget _modifyButton(BuildContext context) {
    return LongCircledBtn(
      text: '수정하기',
      backgroundColor: green,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ModifyUserInfoView()));
      },
    );
  }
}
