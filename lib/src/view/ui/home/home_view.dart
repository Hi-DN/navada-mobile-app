import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/ui/home/home_requestsforme_widget.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/divider.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:navada_mobile_app/src/view/utils/space.dart';
import 'package:navada_mobile_app/src/view/utils/text_style.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getSize(22)),
          child: Column(children: const [
            HomeTopBar(),
            CategorySection(),
            CustomDivider(),
            Expanded(child: RequestsForMeSection())
            // SizedBox(height: 480, child: RequestsForMeSection())
          ]),
        ));
  }
}

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _logo(),
        // 검색창
      ],
    );
  }

  Widget _logo() {
    ScreenSize size = ScreenSize();
    return Image.asset(
        'assets/images/logo.png',
        width: size.getSize(120.0),
        height: size.getSize(50.0),
      );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Space(height: 10),
        CategoryIconsRow(children: _rowContent1),
        CategoryIconsRow(children: _rowContent2),
        // CategoryIconsRow(children: _rowContent3),
        const Space(height: 18),
      ]
    );
  }

  final _rowContent1 =  const[
    CategoryIconTile(icon: Icons.card_giftcard_outlined,label: '기프티콘'),
    CategoryIconTile(icon: Icons.devices, label: '전자기기'),
    CategoryIconTile(icon: Icons.chair_outlined, label: '가구'),
    CategoryIconTile(icon: Icons.stroller_outlined, label: '유아용품'),
    CategoryIconTile(icon: Icons.sports_baseball_outlined, label: '스포츠'),
  ];

  final _rowContent2 = const [
    CategoryIconTile(icon: Icons.fastfood_outlined, label: '식품'),
    CategoryIconTile(icon: Icons.brush_outlined, label: '취미용품'),
    CategoryIconTile(icon: Icons.face_retouching_natural, label: '미용'),
    CategoryIconTile(icon: Icons.female, label: '여성의류'),
    CategoryIconTile(icon: Icons.male, label: '남성의류'),
  ];

  final _rowContent3 = const [
    CategoryIconTile(icon: Icons.pets_outlined, label: '반려동물'),
    CategoryIconTile(icon: Icons.menu_book, label: '도서'),
    CategoryIconTile(icon: Icons.toys_outlined, label: '장난감'),
    CategoryIconTile(icon: Icons.park_outlined, label: '식물'),
    CategoryIconTile(icon: Icons.more_horiz, label: '기타'),
  ];
}

class CategoryIconsRow extends StatelessWidget {
  const CategoryIconsRow({Key? key, this.rowNum, this.children}) : super(key: key);

  final int? rowNum;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getSize(5)),
      child: SizedBox(
        height: size.getSize(60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children!
        ),
      ),
    );
  }
}

class CategoryIconTile extends StatelessWidget {
  const CategoryIconTile({Key? key, this.icon, this.label}) : super(key: key);

  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return SizedBox(
      height: size.getSize(60),
      width: size.getSize(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: size.getSize(36), color: grey183),
          R12Text(text: label)
        ],
      ),
    );
  }
}
