import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class MyExchangesView extends StatelessWidget {
  const MyExchangesView({Key? key}) : super(key: key);

  static const routeName = 'my-exchanges';

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Scaffold(
      appBar: CustomAppBar(titleText: '내 물물교환'),
      body: Container(
        color: white,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: "교환중/교환완료", height: size.getSize(58)),
                  Tab(text: "내가 신청한 물품", height: size.getSize(58)),
                ],
                labelColor: green,
                labelStyle: styleR.copyWith(fontSize: size.getSize(16)),
                indicatorColor: green,
                unselectedLabelColor: grey183,
                unselectedLabelStyle: styleR.copyWith(fontSize: size.getSize(16)),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: const Text('1'),
                    ),
                    Container(
                      child: const Text('2')
                    ),
                  ],
                ),
              )])
        ),
      ),
    );
  }
}