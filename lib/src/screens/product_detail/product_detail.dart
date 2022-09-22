// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/product_detail_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_bottom_button.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_view_model.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../widgets/colors.dart';

// ignore: must_be_immutable
class ProductDetail extends StatelessWidget {
  final ProductModel product;
  bool like;
  int likeNum;
  ScreenSize screenSize = ScreenSize();

  ProductDetail(
      {Key? key,
      required this.product,
      required this.like,
      required this.likeNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => ProductDetailViewModel(like, likeNum)),
            ChangeNotifierProvider(
                create: (context) => ProductDetailProvider()),
            ChangeNotifierProvider(
                create: (context) => ProductDetailAcceptanceProvider())
          ],
          builder: (context, child) {
            return Column(
              children: [
                Flexible(flex: 1, child: _productImagesSection(context)),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: screenSize.getSize(335.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            flex: 2,
                            child:
                                UserInfoSection(productId: product.productId!)),
                        Flexible(flex: 5, child: _productInfoSection(product)),
                        Flexible(flex: 1, child: _reportSection()),
                        Flexible(
                            flex: 2,
                            child: ProductDetailBottomButton(product: product)),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget _productImagesSection(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
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

  Widget _productInfoSection(ProductModel product) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shortener.shortenStrWithMaxLines(product.productName, 1,
                      TextStyle(fontSize: screenSize.getSize(20.0))),
                  const SizedBox(height: 8.0),
                  R14Text(
                    text: "원가 : ${product.productCost}원",
                    textColor: Colors.black.withOpacity(0.5),
                  ),
                  const SizedBox(height: 5.0),
                  R14Text(
                    text:
                        "희망교환가격범위 : ${product.getLowerBound()}원 ~ ${product.getUpperBound()}원",
                    textColor: Colors.black.withOpacity(0.5),
                  )
                ],
              ),
            ),
            Consumer2<ProductDetailViewModel, ProductDetailProvider>(
                builder: (context, viewProvider, provider, widget) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      viewProvider.setLikeValue();
                      viewProvider.like
                          ? provider.saveHeart(product.productId!)
                          : provider.deleteHeart(product.productId!);
                    },
                    icon: Icon(
                      viewProvider.like
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: const Color(0xFFDD8560),
                      size: 35.0,
                    ),
                  ),
                  R14Text(
                    text: viewProvider.likeNum.toString(),
                    textColor: const Color(0xFFDD8560),
                  )
                ],
              );
            })
          ],
        ),
        SizedBox(height: screenSize.getSize(8.0)),
        const Divider(
          color: green,
          thickness: 1.0,
        ),
        SizedBox(height: screenSize.getSize(8.0)),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              product.productExplanation!,
              style: TextStyle(
                color: navy,
                fontSize: screenSize.getSize(14.0),
                // letterSpacing: 2,
                // wordSpacing: 2
              ),
            ),
          ),
        ),
      ],
    ));
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

// ignore: must_be_immutable
class UserInfoSection extends StatelessWidget {
  ScreenSize screenSize = ScreenSize();
  int productId;
  UserInfoSection({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductDetailProvider>(context, listen: false)
        .fetchUserInfo(productId);

    return Consumer<ProductDetailProvider>(
      builder: (context, provider, widget) {
        if (provider.userOfProduct != null) {
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
                R14Text(
                  text: provider.userOfProduct?.userNickname,
                  textColor: const Color(0xFF5B5B5A),
                ),
                SizedBox(width: screenSize.getSize(10.0)),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      color: green,
                    ),
                    R14Text(
                      text: "${provider.userOfProduct?.userRating}",
                      textColor: green,
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
