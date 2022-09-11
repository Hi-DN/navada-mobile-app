import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/screens/request_exchange/request_exchange_view_model.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/request_exchange_provider.dart';
import '../../widgets/colors.dart';
import '../../widgets/screen_size.dart';
import '../../widgets/text_style.dart';

// 교환 신청하기 화면
class RequestExchangeView extends StatelessWidget {
  ProductModel acceptorProduct;
  ScreenSize screenSize = ScreenSize();
  RequestExchangeView({Key? key, required this.acceptorProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          titleText: '교환 신청하기',
          leadingYn: true,
          onTap: () => Navigator.pop(context),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => RequestExchangeProvider()),
            ChangeNotifierProvider(
                create: (context) => RequestExchangeViewModel()),
          ],
          child: Center(
            child: SizedBox(
              width: screenSize.getSize(342.0),
              child: Column(
                children: [
                  _acceptorProductInfo(acceptorProduct),
                  SizedBox(
                    height: 1.0,
                    child: Container(color: const Color(0xFFE2E2E2)),
                  ),
                  Expanded(
                      child: MyProductList(
                          acceptorProductId: acceptorProduct.productId!)),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _acceptorProductInfo(ProductModel acceptorProduct) {
    return SizedBox(
        height: screenSize.getSize(220.0),
        child: Container(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _setRichText(acceptorProduct.userNickname!, ' 님의 물품', 16.0),
              const Expanded(child: SizedBox(height: 10.0)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      'assets/images/test.jpeg',
                      fit: BoxFit.cover,
                      width: screenSize.getSize(99.0),
                      height: screenSize.getSize(99.0),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: SizedBox(
                      height: screenSize.getSize(99.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: SizedBox()),
                          _setRichText(
                              '상품명 ', acceptorProduct.productName!, 14.0),
                          const SizedBox(height: 3.0),
                          _setRichText(
                              '원가  ', '${acceptorProduct.productCost!}원', 14.0),
                          const SizedBox(height: 3.0),
                          _setRichText(
                              '희망가격\n',
                              '${acceptorProduct.getLowerBound()}원 ~ ${acceptorProduct.getUpperBound()}원',
                              14.0),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox(height: 10.0)),
              _setRichText('상품설명\n', acceptorProduct.productExplanation!, 14.0)
            ],
          ),
        ));
  }
}

class MyProductList extends StatelessWidget {
  int acceptorProductId;
  ScreenSize screenSize = ScreenSize();
  MyProductList({Key? key, required this.acceptorProductId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<RequestExchangeProvider>(context, listen: false)
        .fetchProductsList(acceptorProductId);

    return Container(
      padding: const EdgeInsets.only(top: 12.0, bottom: 15.0),
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: const B16Text(text: '내 물품 중 선택하기')),
          const SizedBox(height: 15.0),
          Expanded(
            child: Consumer<RequestExchangeProvider>(
                builder: (context, provider, widget) {
              if (provider.initialFetched && provider.productList.isNotEmpty) {
                return _makeListView(provider.productList);
              } else if (provider.initialFetched &&
                  provider.productList.isEmpty) {
                return const NoElements(text: '교환 신청 가능한 상품이 없습니다.');
              }
              return const Center(child: CircularProgressIndicator());
            }),
          ),
        ],
      ),
    );
  }

  Widget _makeListView(productList) {
    ScrollController scrollController = ScrollController();

    return SizedBox(
      // height: screenSize.getSize(403.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Scrollbar(
                  controller: scrollController,
                  radius: const Radius.circular(10.0),
                  thumbVisibility: true,
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return _buildItem(productList[index]);
                      })),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: const R12Text(
                text: '※ 여러 상품에 교환 신청하는 경우,\n 가장 먼저 수락되는 상품과 자동으로 교환이 이루어집니다.'),
          ),
          _exchangeRequestButton(),
        ],
      ),
    );
  }

  Widget _buildItem(ProductModel product) {
    return SizedBox(
      height: screenSize.getSize(100.0),
      width: screenSize.getSize(320.0),
      child: Column(
        children: [
          const SizedBox(height: 15.0),
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 11.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'assets/images/test.jpeg',
                    width: screenSize.getSize(70.0),
                    height: screenSize.getSize(70.0),
                  ),
                ),
                const SizedBox(width: 11.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: SizedBox()),
                      B14Text(text: product.productName),
                      const Expanded(child: SizedBox()),
                      _setRichText('원가  ', '${product.productCost!}원', 14.0),
                      const Expanded(child: SizedBox()),
                      _setRichText(
                          '희망가격 ',
                          '${product.getLowerBound()}원 ~ ${product.getUpperBound()}원',
                          14.0),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenSize.getSize(20.0),
                  height: screenSize.getSize(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //fixme
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        elevation: 0.0,
                        primary: Colors.white,
                        shape: const CircleBorder(
                            side: BorderSide(width: 2.5, color: grey153))),
                    child: Container(),
                  ),
                ),
                const SizedBox(width: 11.0),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            width: screenSize.getSize(320.0),
            height: 1.0,
            color: const Color(0xFFE2E2E2),
          )
        ],
      ),
    );
  }

  Widget _exchangeRequestButton() {
    return SizedBox(
      width: screenSize.getSize(327.0),
      height: screenSize.getSize(50.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.0))),
        child: const R18Text(
          text: '교환 신청하기',
          textColor: Colors.white,
        ),
      ),
    );
  }
}

Widget _setRichText(String key, String value, double fontSize) {
  return RichText(
      text: TextSpan(
    children: [
      TextSpan(
          text: key,
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontWeight: FontWeight.w700)),
      TextSpan(
          text: value,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          ))
    ],
  ));
}
