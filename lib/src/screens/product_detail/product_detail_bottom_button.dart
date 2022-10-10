import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_dto_model.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_acceptance.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../providers/product_detail_provider.dart';
import '../../widgets/colors.dart';
import '../../widgets/text_style.dart';
import '../request_exchange/request_exchange_view.dart';

// ignore: must_be_immutable
class ProductDetailBottomButton extends StatelessWidget {
  final ProductModel product;
  ScreenSize screenSize = ScreenSize();

  ProductDetailBottomButton({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductDetailAcceptanceProvider>(context, listen: false)
        .fetchRequestDtoList(product.productId!);

    return Consumer<ProductDetailAcceptanceProvider>(
        builder: (context, provider, child) {
      if (product.productExchangeStatusCd ==
          ProductExchangeStatusCd.REGISTERED) {
        if (provider.fetchCompleted && provider.requestDtoModel.success) {
          return provider.requestDtoList.isEmpty
              ? _oneBottomButton(context, product)
              : _twoBottomButtons(context, product, provider.requestDtoList);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      } else {
        return _canNotTradeButton(product.productExchangeStatusCd!);
      }
    });
  }

  Widget _oneBottomButton(BuildContext context, ProductModel product) {
    return Column(children: [
      Expanded(child: Container()),
      SizedBox(
        width: screenSize.getSize(327.0),
        height: screenSize.getSize(45.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return RequestExchangeView(acceptorProduct: product);
            }));
          },
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0))),
          child: const R18Text(
            text: '교환 신청하기',
            textColor: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 20.0),
    ]);
  }

  Widget _twoBottomButtons(BuildContext context, ProductModel product,
      List<RequestDtoContentModel> requestList) {
    return Column(children: [
      Expanded(child: Container()),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize.getSize(160.0),
            height: screenSize.getSize(45.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return RequestExchangeView(acceptorProduct: product);
                }));
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0))),
              child: const R18Text(
                text: '새로 신청하기',
                textColor: Colors.white,
              ),
            ),
          ),
          const ProductDetailAcceptance(),
        ],
      ),
      const SizedBox(height: 20.0),
    ]);
  }

  Widget _canNotTradeButton(ProductExchangeStatusCd productExchangeStatusCd) {
    return Column(children: [
      Expanded(child: Container()),
      SizedBox(
        width: screenSize.getSize(327.0),
        height: screenSize.getSize(45.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: grey153),
            child: Center(
                child: R18Text(
              text: productExchangeStatusCd == ProductExchangeStatusCd.TRADING
                  ? '교환중인 물품입니다.'
                  : '교환 완료된 물품입니다.',
              textColor: Colors.white,
            ))),
      ),
      const SizedBox(height: 20.0),
    ]);
  }
}
