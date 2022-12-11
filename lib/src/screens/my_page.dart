import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/screens/heart/heart_view.dart';
import 'package:navada_mobile_app/src/screens/my_products/my_products_view.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import 'exchange_history/exchange_history_view.dart';

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
            _UserProfile(),
            CustomDivider(),
            _UserActivities(),
            CustomDivider(),
            _AccountManagement()
          ]),
        ));
  }
}

class _UserProfile extends StatelessWidget {
  const _UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    User user = Provider.of<UserProvider>(context, listen: false).user;

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
                    B16Text(text: user.userNickname),
                    const Space(height: 2),
                    R14Text(text: user.userLevel.label),
                    const Space(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: size.getSize(15), color: grey183),
                        const Space(width: 2),
                        R14Text(text: user.userAddress, textColor: grey183),
                      ],
                    )
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

class _UserActivities extends StatelessWidget {
  const _UserActivities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space(height: 16),
        const _TitleText(text: "내 활동"),
        const Space(height: 21),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _iconTile(Icons.shopping_bag_outlined, "내 물품 목록", () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyProductsView()));
            }),
            _iconTile(
              Icons.favorite_border_outlined,
              "좋아요 목록",
              () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HeartView()));
              },
            ),
            _iconTile(
              Icons.list_alt_rounded,
              "교환 내역",
              () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ExchangeHistoryView()));
              },
            )
          ],
        ),
        const Space(height: 24),
      ],
    );
  }

  Widget _iconTile(IconData icon, String label, Function() onPressed) {
    ScreenSize size = ScreenSize();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(5)),
      child: Column(children: [
        IconButton(
          icon: Icon(icon),
          color: grey183,
          iconSize: size.getSize(48),
          onPressed: onPressed,
        ),
        const Space(height: 5),
        R14Text(text: label)
      ]),
    );
  }
}

class _AccountManagement extends StatelessWidget {
  const _AccountManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space(height: 16),
        const _TitleText(text: "계정관리"),
        const Space(height: 12),
        _listTile("계정 정보 설정"),
        _listTile("앱 정보"),
        _listTile("로그아웃"),
        _listTile("회원 탈퇴"),
        const Space(height: 24),
      ],
    );
  }

  Widget _listTile(String text) {
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

class _TitleText extends StatelessWidget {
  const _TitleText({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return B16Text(text: text);
  }
}
