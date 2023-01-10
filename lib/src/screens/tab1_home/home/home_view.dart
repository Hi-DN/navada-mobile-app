import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/home_requests_provider.dart';
import 'package:navada_mobile_app/src/screens/tab1_home/products_by_category/products_by_category_view.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import 'home_requests_widget.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    User user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
        body: MultiProvider(
            providers: [
          ChangeNotifierProvider(
              create: (context) => RequestsForMeProvider(user.userId!)),
          ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getSize(22)),
              child: Column(children: [
                const _HomeTopBar(),
                const _CategorySection(),
                const CustomDivider(),
                Expanded(child: RequestsForMe())
              ]),
            )));
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.only(top: size.getSize(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_logo()],
      ),
    );
  }

  Widget _logo() {
    ScreenSize size = ScreenSize();
    return Image.asset(
      'assets/images/logo.png',
      width: size.getSize(110.0),
      height: size.getSize(50.0),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return Consumer<HomeViewModel>(builder:
        (BuildContext context, HomeViewModel homeViewModel, Widget? _) {
      CarouselController carouselController = homeViewModel.carouselController;
      return Column(
        children: [
          CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
                height: size.getSize(175),
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  homeViewModel.setCurrentCategoryIndex(index);
                }),
            items: [
              _categoryFirstSlide(carouselController),
              _categorySecondSlide(carouselController)
            ],
          ),
        ],
      );
    });
  }

  Widget _categoryFirstSlide(CarouselController carouselController) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Column(children: [
        const Space(height: 10),
        _CategoryIconsRow(children: _rowContent1),
        _CategoryIconsRow(children: _rowContent2),
        const Space(height: 18),
      ])),
      _nextPageArrowBtn(carouselController)
    ]);
  }

  Widget _nextPageArrowBtn(CarouselController carouselController) {
    ScreenSize size = ScreenSize();
    return GestureDetector(
        onTap: () => carouselController.nextPage(),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: size.getSize(12),
          color: grey183,
        ));
  }

  Widget _categorySecondSlide(CarouselController carouselController) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _prevPageArrowBtn(carouselController),
      Expanded(
          child: Column(children: [
        const Space(height: 10),
        _CategoryIconsRow(children: _rowContent3),
        const Space(height: 78)
      ])),
    ]);
  }

  Widget _prevPageArrowBtn(CarouselController carouselController) {
    ScreenSize size = ScreenSize();
    return GestureDetector(
        onTap: () => carouselController.previousPage(),
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: size.getSize(12),
          color: grey183,
        ));
  }

  final _rowContent1 = const [
    _CategoryIconTile(icon: Icons.card_giftcard_outlined, label: '기프티콘'),
    _CategoryIconTile(icon: Icons.devices, label: '전자기기'),
    _CategoryIconTile(icon: Icons.chair_outlined, label: '가구'),
    _CategoryIconTile(icon: Icons.stroller_outlined, label: '유아용품'),
    _CategoryIconTile(icon: Icons.sports_baseball_outlined, label: '스포츠'),
  ];

  final _rowContent2 = const [
    _CategoryIconTile(icon: Icons.fastfood_outlined, label: '식품'),
    _CategoryIconTile(icon: Icons.brush_outlined, label: '취미용품'),
    _CategoryIconTile(icon: Icons.face_retouching_natural, label: '미용'),
    _CategoryIconTile(icon: Icons.female, label: '여성의류'),
    _CategoryIconTile(icon: Icons.male, label: '남성의류'),
  ];

  final _rowContent3 = const [
    _CategoryIconTile(icon: Icons.pets_outlined, label: '반려동물'),
    _CategoryIconTile(icon: Icons.menu_book, label: '도서'),
    _CategoryIconTile(icon: Icons.toys_outlined, label: '장난감'),
    _CategoryIconTile(icon: Icons.park_outlined, label: '식물'),
    _CategoryIconTile(icon: Icons.more_horiz, label: '기타'),
  ];
}

class _CategoryIconsRow extends StatelessWidget {
  _CategoryIconsRow({Key? key, this.children})
      : super(key: key);

  late int? rowNum;
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
            children: children!),
      ),
    );
  }
}

class _CategoryIconTile extends StatelessWidget {
  const _CategoryIconTile({Key? key, this.icon, this.label}) : super(key: key);

  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    int categoryId = Category.labelToId(label!);
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ProductsByCategoryView(categoryId: categoryId))),
      child: SizedBox(
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
      ),
    );
  }
}
