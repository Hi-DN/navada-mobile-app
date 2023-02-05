import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class ModifyUserInfoView extends StatelessWidget {
  ModifyUserInfoView({Key? key}) : super(key: key);

  final TextEditingController _nickNameController =
      TextEditingController(text: UserProvider.user.userNickname);
  final TextEditingController _phoneNumController =
      TextEditingController(text: UserProvider.user.userPhoneNum);
  final TextEditingController _addressController =
      TextEditingController(text: UserProvider.user.userAddress);

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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              _userInfoSection(),
              const Space(height: 200.0),
              _modifyButton(context)
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
        _setField('닉네임', "닉네임은 10자 이내로 설정 가능합니다.", _nickNameController),
        _setField('휴대폰 번호', "'010-0000-0000' 형식으로 입력해주세요", _phoneNumController),
        _setField('주소', "'OO시 OO구' 형식으로 입력해주세요", _addressController),
      ],
    );
  }

  Widget _setField(
      String label, String? helperText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space(height: 25.0),
        B18Text(text: label),
        const Space(height: 10.0),
        SizedBox(
          height: 70.0,
          child: TextField(
            decoration: _inputDecoration(helperText),
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  Widget _modifyButton(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    User user = UserProvider.user;

    return Container(
      alignment: Alignment.bottomCenter,
      child: LongCircledBtn(
        text: '수정하기',
        backgroundColor: navy,
        onTap: () async {
          UserParams userParams = UserParams(
              signInPlatform: user.signInPlatform!,
              userName: user.userName!,
              userEmail: user.userEmail!,
              userNickname: _nickNameController.value.text,
              userPhoneNum: _phoneNumController.value.text,
              userAddress: _addressController.value.text);

          bool success = await Provider.of<UserProvider>(context, listen: false)
              .modifyUser(user.userId!, userParams);

          if (success) {
            scaffoldMessenger.showSnackBar(const SnackBar(
              duration: Duration(seconds: 1),
              content: R16Text(text: '수정이 완료되었습니다 :D', textColor: white),
            ));
            navigator.pop();
          } else {
            scaffoldMessenger.showSnackBar(const SnackBar(
              duration: Duration(seconds: 1),
              content: R16Text(
                  text: '수정에 실패했습니다. 잠시 후 다시 시도해주세요.', textColor: white),
            ));
          }
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String? helperText) {
    return InputDecoration(
        hintText: '* 필수 항목입니다.',
        helperText: helperText,
        hintStyle: const TextStyle(color: Colors.redAccent, fontSize: 14.0),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Color(0xFFB7B7B7)),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        contentPadding: const EdgeInsets.only(left: 10.0));
  }
}
