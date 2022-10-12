import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/heart_provider.dart';
import 'package:navada_mobile_app/src/screens/heart/heart_view_model.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:provider/provider.dart';

import '../../models/heart/heart_list_model.dart';
import '../../models/product/product_model.dart';
import '../../widgets/colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/divider.dart';
import '../../widgets/screen_size.dart';
import '../../widgets/space.dart';
import '../../widgets/status_badge.dart';

class HeartView extends StatelessWidget {
  const HeartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return Scaffold(
      appBar: CustomAppBar(
        titleText: '관심 상품 목록',
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HeartViewModel()),
          ChangeNotifierProvider(create: (context) => HeartProvider()),
        ],
        child: Center(
          child: SizedBox(
            width: size.getSize(335.0),
            child: Column(
              children: [
                const CheckButtonSection(),
                Expanded(child: HeartListSection())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
CheckButtonSection : 교환가능상품만보기 체크 버튼 부분
 */
class CheckButtonSection extends StatelessWidget {
  const CheckButtonSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return Container(
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
                Provider.of<HeartViewModel>(context, listen: false)
                    .onCheckButtonTapped();
                Provider.of<HeartProvider>(context, listen: false).setShowAll();
              },
              icon: Provider.of<HeartViewModel>(context).isChecked
                  ? const Icon(Icons.check_circle, color: navy)
                  : const Icon(Icons.check_circle_outline)),
          Text('교환 가능 상품만 보기',
              style: TextStyle(
                  color: Provider.of<HeartViewModel>(context).isChecked
                      ? navy
                      : grey153))
        ],
      ),
    );
  }
}

/*
HeartListSection : 좋아요 상품 리스트 부분
 */
// ignore: must_be_immutable
class HeartListSection extends StatelessWidget {
  HeartListSection({Key? key}) : super(key: key);
  ScreenSize size = ScreenSize();

  @override
  Widget build(BuildContext context) {
    Provider.of<HeartProvider>(context, listen: false).fetchHeartList();

    return Consumer<HeartProvider>(builder: (context, provider, widget) {
      if (provider.heartList.isNotEmpty) {
        Provider.of<HeartViewModel>(context, listen: false)
            .createIconList(provider.heartListModel.totalElements);
        return _makeListView(provider.heartList);
      }
      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget _makeListView(List<HeartListContentModel> heartList) {
    return ListView.builder(
        itemBuilder: (context, index) {
          ProductModel product = heartList[index].product;
          int heartId = heartList[index].heartId;

          return Column(
            children: [
              SizedBox(
                height: size.getSize(8.0),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return ProductDetail(
                        productId: product.productId!, like: true);
                  })).then((value) =>
                          Provider.of<HeartProvider>(context, listen: false)
                              .fetchHeartList());
                },
                child: Row(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shortener.shortenStrWithMaxLines(
                              product.productName,
                              1,
                              TextStyle(
                                  fontSize: size.getSize(14.0),
                                  fontWeight: FontWeight.w700)),
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
                          ExchangeStatusBadge(
                              statusCd: product.productExchangeStatusCd)
                        ],
                      ),
                    ),
                    SizedBox(width: size.getSize(12.0)),
                    IconButton(
                        onPressed: () {
                          Provider.of<HeartViewModel>(context, listen: false)
                              .onHeartButtonTapped(index);
                          bool isDelete = !Provider.of<HeartViewModel>(context,
                                  listen: false)
                              .iconBoolList[index];
                          isDelete
                              ? Provider.of<HeartProvider>(context,
                                      listen: false)
                                  .deleteSelectedHeart(heartId)
                              : Provider.of<HeartProvider>(context,
                                      listen: false)
                                  .saveSelectedHeart(product.productId!);
                        },
                        icon: Icon(
                          Provider.of<HeartViewModel>(context)
                                  .iconBoolList[index]
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          size: size.getSize(25.0),
                          color: green,
                        ))
                  ],
                ),
              ),
              Space(height: size.getSize(8.0)),
              const CustomDivider()
            ],
          );
        },
        itemCount: heartList.length);
  }
}
