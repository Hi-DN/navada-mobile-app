import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_model.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/custom_appbar.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:navada_mobile_app/src/view/utils/space.dart';
import 'package:navada_mobile_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

import '../../business_logic/user/user_provider.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Scaffold(
        appBar: CustomAppBar(titleText: "마이페이지"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getSize(22)),
          child: Column(children: const [
            UserProfile(),
            Divider(),
            UserActivities(),
            Divider(),
            AccountManagement()
          ]),
        ));
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    UserModel user =
        Provider.of<UserProvider>(context, listen: false).userModel;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getSize(27)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Icon(Icons.face, color: green, size: size.getSize(48)),
                const Space(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    B20Text(text: user.userNickname),
                    const Space(height: 5),
                    R14Text(text: user.userLevel!.label)
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star_rate_rounded, color: green),
                R16Text(text: user.userRating.toString()),
                const Space(width: 8)
              ],
            )
          ]),
        ],
      ),
    );
  }
}

class UserActivities extends StatelessWidget {
  const UserActivities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space(height: 16),
        const TitleText(text: "내 활동"),
        const Space(height: 21),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            iconTile(Icons.shopping_bag_outlined, "내 물품 목록"),
            iconTile(Icons.list_alt_rounded, "거래 후기 내역"),
            iconTile(Icons.local_activity_outlined, "내 활동 3")
          ],
        ),
        const Space(height: 24),
      ],
    );
  }

  Widget iconTile(IconData icon, String label) {
    ScreenSize size = ScreenSize();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(5)),
      child: Column(children: [
        Icon(icon, color: grey183, size: size.getSize(50)),
        const Space(height: 5),
        R14Text(text: label)
      ]),
    );
  }
}

class AccountManagement extends StatelessWidget {
  const AccountManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space(height: 16),
        const TitleText(text: "계정관리"),
        const Space(height: 12),
        listTile("계정 정보 설정"),
        listTile("로그아웃"),
        listTile("회원 탈퇴"),
        const Space(height: 24),
      ],
    );
  }

  Widget listTile(String text) {
    ScreenSize size = ScreenSize();
    return Padding(
        padding: EdgeInsets.symmetric(vertical: size.getSize(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            R16Text(text: text),
          ],
        ));
  }
}

class TitleText extends StatelessWidget {
  const TitleText({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return B16Text(text: text);
  }
}
