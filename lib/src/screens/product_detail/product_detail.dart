// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/heart/heart_list_model.dart';
import 'package:navada_mobile_app/src/providers/product_detail_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_bottom_button.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_view_model.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../../widgets/colors.dart';

// ignore: must_be_immutable
class ProductDetail extends StatelessWidget {
  final Product product;
  bool like;
  ScreenSize screenSize = ScreenSize();

  ProductDetail({Key? key, required this.product, required this.like})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiProvider(
            providers: [
          ChangeNotifierProvider(
              create: (context) => ProductDetailViewModel(true)),
          ChangeNotifierProvider(create: (context) => ProductDetailProvider())
        ],
            builder: (context, child) {
              return Column(
                children: [
                  _productImagesSection(context),
                  Expanded(
                    child: Container(
                      width: screenSize.getSize(335.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _userInfoSection(),
                          _productInfoSection(product),
                          _reportSection(),
                          Expanded(
                              child:
                                  ProductDetailBottomButton(product: product))
                        ],
                      ),
                    ),
                  )
                ],
              );
            }));
  }

  Widget _productImagesSection(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Image.asset(
          'assets/images/test.jpeg',
          fit: BoxFit.cover,
        ),
      ),
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        padding: const EdgeInsets.only(top: 50.0),
        icon: const Icon(
          Icons.arrow_back,
          color: Color(0xFF747474),
          size: 30.0,
        ),
      )
    ]);
  }

  Widget _userInfoSection() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25.0,
            backgroundColor: grey153,
            child: CircleAvatar(
              radius: 23.0,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: grey153,
              ),
            ),
          ),
          SizedBox(width: screenSize.getSize(10.0)),
          const R14Text(
            text: "김판매(임의)",
            textColor: Color(0xFF5B5B5A),
          ),
          SizedBox(width: screenSize.getSize(10.0)),
          Row(
            children: const [
              Icon(
                Icons.star_outline,
                color: green,
              ),
              R14Text(
                text: "4.5",
                textColor: green,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _productInfoSection(Product product) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  R20Text(text: product.productName),
                  const SizedBox(height: 8.0),
                  R14Text(
                    text: "원가 : ${product.productCost}원",
                    textColor: Colors.black.withOpacity(0.5),
                  ),
                  const SizedBox(height: 5.0),
                  R14Text(
                    text:
                        "희망교환가격범위 : ${getLowerCostBound(product)}원 ~ ${getUpperCostBound(product)}원",
                    textColor: Colors.black.withOpacity(0.5),
                  )
                ],
              ),
              Consumer2<ProductDetailViewModel, ProductDetailProvider>(
                  builder: (context, viewProvider, provider, widget) {
                return IconButton(
                    onPressed: () {
                      viewProvider.setLikeValue();
                      viewProvider.like
                          ? provider.saveHeart(product.productId)
                          : provider.deleteHeart(product.productId);
                    },
                    icon: Icon(
                      viewProvider.like
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: const Color(0xFFDD8560),
                      size: 35.0,
                    ));
              })
            ],
          ),
          const SizedBox(height: 8.0),
          const Divider(
            color: green,
            thickness: 1.0,
          ),
          const SizedBox(height: 8.0),
          R14Text(
            text: product.productExplanation,
            textColor: navy,
          )
        ],
      ),
    );
  }

  int getUpperCostBound(Product product) {
    return product.productCost + product.exchangeCostRange;
  }

  int getLowerCostBound(Product product) {
    return product.productCost - product.exchangeCostRange;
  }

  Widget _reportSection() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
          onTap: () {},
          child: const Text(
            "게시글 신고하기",
            style: TextStyle(
              color: Color(0xFFC4C4C4),
              decoration: TextDecoration.underline,
            ),
          )),
    );
  }
}
