import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/heart/heart_list_model.dart';
import 'package:navada_mobile_app/src/view/ui/heart_list_provider.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/custom_appbar.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:provider/provider.dart';

import '../utils/divider.dart';
import '../utils/space.dart';
import '../utils/status_badge.dart';
import '../utils/text_style.dart';

class HeartListWidget extends StatelessWidget {
  const HeartListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return Scaffold(
      appBar: CustomAppBar(titleText: '관심 상품 목록'),
      body: ChangeNotifierProvider(
        create: (context) => HeartListProvider(),
        child: Center(
          child: Container(
            width: size.getSize(335.0),
            child: Column(
              children: [
                const CheckButtonSection(),
                Expanded(
                  child: HeartList(
                      heartListContent: Provider.of<HeartListProvider>(context)
                          .getHeartList()!),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckButtonSection extends StatelessWidget {
  const CheckButtonSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return ChangeNotifierProvider(
      create: (context) => HeartListCheckButton(),
      child: Container(
        padding: const EdgeInsets.only(top: 5.0),
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Expanded(child: Container()),
            IconButton(
              alignment: Alignment.centerRight,
              iconSize: size.getSize(18.0),
              color: grey153,
              onPressed: () {
                Provider.of<HeartListCheckButton>(context, listen: false)
                    .onTapped();
              },
              icon: Provider.of<HeartListCheckButton>(context).setIcon(),
            ),
            Provider.of<HeartListCheckButton>(context).setText(),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class HeartList extends StatelessWidget {
  HeartList({Key? key, required this.heartListContent}) : super(key: key);

  ScreenSize size = ScreenSize();
  List<HeartListContentModel> heartListContent;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildItem(index);
      },
      itemCount: heartListContent.length,
    );
  }

  Widget _buildItem(int index) {
    Product? product = heartListContent.elementAt(index).product;
    return Column(children: [
      SizedBox(
        height: size.getSize(8.0),
      ),
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              'assets/images/test.jpeg',
              width: size.getSize(65.0),
              height: size.getSize(65.0),
            ),
          ),
          SizedBox(
            width: size.getSize(12.0),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              B14Text(text: product.productName),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: '원가 ',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                TextSpan(
                    text: '${product.productCost}원',
                    style: const TextStyle(color: Colors.black))
              ])),
              Space(height: size.getSize(5.0)),
              _statusBadge(product),
            ],
          ),
          Expanded(child: Container()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                size: size.getSize(25.0),
                color: green,
              ))
        ],
      ),
      Space(
        height: size.getSize(8.0),
      ),
      const CustomDivider()
    ]);
  }

  Widget _statusBadge(Product? product) {
    switch (product?.productStatusCd) {
      case 0:
        return Container();
      case 1:
        return const StatusBadge(
          label: '교환중',
          backgroundColor: green,
        );
      case 2:
        return const StatusBadge(
          label: '교환완료',
          backgroundColor: navy,
        );
    }
    return Container();
  }
}
