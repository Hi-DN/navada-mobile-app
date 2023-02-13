import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/screens/tab5_mypage/account_management/setting_user_info/modify_user_info_view_model.dart';
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

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '계정 정보 수정',
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ModifyUserInfoViewModel(),
        builder: (context, child) {
          _context = context;
          return Container(
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
          );
        }
      ),
    );
  }

  Widget _userInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nicknameField(),
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

  Widget _nicknameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space(height: 25.0),
        const B18Text(text: "닉네임"),
        const Space(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _setNicknameField(),
            _checkNicknameBtn(_nickNameController.value.text)
          ]
        )
      ]
    );
  }

  Widget _setNicknameField() {
    return SizedBox(
      height: 70.0,
      width: 220,
      child: TextField(
        decoration: _inputDecoration("닉네임은 10자 이내로 설정 가능합니다."),
        textAlignVertical: TextAlignVertical.center,
        controller: _nickNameController,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          Provider.of<ModifyUserInfoViewModel>(_context, listen: false).setNicknameAvailable(false, value);
        },
      ),
    );
  }

  Widget _checkNicknameBtn(String nickname) {
    bool isNicknameAvailable = Provider.of<ModifyUserInfoViewModel>(_context).isNicknameAvailable;
    return Padding(
      padding: const EdgeInsets.only(bottom: 23),
      child: GestureDetector(
        onTap: () => _validNickname(nickname),
        child: Container(
          alignment: Alignment.center,
          width: 90,
          height: 47,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isNicknameAvailable ? green : white,
            border: Border.all(color: green, width: 2)
          ),
          child: R16Text(
            text: isNicknameAvailable ? "확인 완료" : "중복 확인",
            textColor: isNicknameAvailable ? white : green)
        ),
      ),
    );
  }

  _validNickname(String nickname) async {
    if(nickname.isNotEmpty) {
      bool result = await Provider.of<UserProvider>(_context, listen: false).checkNicknameUsable(nickname);
      if (result) {
        Provider.of<ModifyUserInfoViewModel>(_context, listen: false).setNicknameAvailable(true, nickname);
      } else {
        _showWarningSnackBar("다른 닉네임을 사용해주세요!");
      }
    }
  }

  Widget _modifyButton(BuildContext context) {
    String phoneNumber =  _phoneNumController.value.text;
    String address = _addressController.value.text;
    bool isNicknameAvailable = Provider.of<ModifyUserInfoViewModel>(_context).isNicknameAvailable;

    return Container(
      alignment: Alignment.bottomCenter,
      child: LongCircledBtn(
        text: '수정하기',
        backgroundColor: navy,
        onTap: () {
          if (!isNicknameAvailable) {
            _showWarningSnackBar("닉네임 중복확인을 해주세요!");
          } else if (phoneNumber.isEmpty) {
            _showWarningSnackBar("핸드폰 번호를 입력해주세요!");
          } else if (address.isEmpty) {
            _showWarningSnackBar("주소를 입력해주세요!");
          } else {
            _modifyUserInfo();
          }
        }
      )
    );
  }

  _modifyUserInfo() async {
    final scaffoldMessenger = ScaffoldMessenger.of(_context);
    final navigator = Navigator.of(_context);
    User user = UserProvider.user;

    UserParams userParams = UserParams(
        signInPlatform: user.signInPlatform!,
        userName: user.userName!,
        userEmail: user.userEmail!,
        userNickname: _nickNameController.value.text,
        userPhoneNum: _phoneNumController.value.text,
        userAddress: _addressController.value.text);

    bool success = await Provider.of<UserProvider>(_context, listen: false)
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

  _showWarningSnackBar(String snackBarText) {
    ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: R16Text(text: snackBarText, textColor: white),
    ));
  }
}
