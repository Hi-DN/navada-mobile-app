// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/product_detail_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_request_modal.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_view_model.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_model.dart';
import '../../models/user/user_model.dart';
import '../../utilities/enums.dart';
import '../../widgets/colors.dart';
import '../request_exchange/request_exchange_view.dart';

// ignore: must_be_immutable
class ProductDetail extends StatelessWidget {
  final int productId;
  bool like;
  ScreenSize screenSize = ScreenSize();

  ProductDetail({Key? key, required this.productId, required this.like})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => ProductDetailViewModel(like)),
            ChangeNotifierProvider(create: (context) => ProductDetailProvider())
          ],
          builder: (context, child) {
            return _buildProductDetail(context);
          }),
    );
  }

  Widget _buildProductDetail(BuildContext context) {
    Provider.of<ProductDetailProvider>(context, listen: false)
        .fetchProductDetailInfo(productId);
    ProductDetailViewModel viewModel =
        Provider.of<ProductDetailViewModel>(context, listen: false);

    return Consumer<ProductDetailProvider>(builder: (context, provider, child) {
      if (provider.productFetched &&
          provider.userFetched &&
          provider.requestsFetched) {
        if (!viewModel.likeNumFetched) {
          viewModel.setLikeNum(provider.product!.heartNum!);
        }
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
                        child: _userInfoSection(provider.userOfProduct)),
                    Flexible(
                        flex: 5, child: _productInfoSection(provider.product!)),
                    Flexible(
                        flex: 1,
                        child: _reportAndCreateDtSection(provider.product!)),
                    Flexible(
                        flex: 2, child: productDetailBottomButton(context)),
                  ],
                ),
              ),
            )
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _userInfoSection(User? userOfProduct) {
    if (userOfProduct != null) {
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
              text: userOfProduct.userNickname,
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
                  text: "${userOfProduct.userRating}",
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
        onPressed: () =>
            Navigator.of(context, rootNavigator: true).pop(context),
        padding: const EdgeInsets.only(top: 40.0),
        icon: const Icon(
          Icons.arrow_back,
          color: Color(0xFF747474),
          size: 30.0,
        ),
      )
    ]);
  }

  Widget _productInfoSection(ProductModel product) {
    return Column(
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
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _reportAndCreateDtSection(ProductModel product) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {},
              child: const Text(
                "게시글 신고하기",
                style: TextStyle(
                  color: Color(0xFFC4C4C4),
                  decoration: TextDecoration.underline,
                ),
              )),
          R12Text(
            text: product.createdDate?.replaceAll('T', ' '),
            textColor: const Color(0xFFC4C4C4),
          )
        ],
      ),
    );
  }

  Widget productDetailBottomButton(BuildContext context) {
    ProductDetailProvider provider =
        Provider.of<ProductDetailProvider>(context, listen: false);

    return (provider.userOfProduct!.userId == UserProvider.userId)
        ? _myProductDetailBottomButton(context, provider.product!)
        : (provider.product!.productExchangeStatusCd ==
                ProductExchangeStatusCd.REGISTERED)
            ? (provider.requestDtoList.isEmpty)
                ? _oneBottomButton(context)
                : _twoBottomButtons(context)
            : _canNotTradeButton(context);
  }

  Widget _myProductDetailBottomButton(
      BuildContext context, ProductModel product) {
    switch (product.productExchangeStatusCd) {
      case ProductExchangeStatusCd.REGISTERED:
        return _deleteAndModifyButtons(context, product);
      case ProductExchangeStatusCd.TRADING:
        return _onlyModifyButton(context, product);
      case ProductExchangeStatusCd.TRADE_COMPLETED:
        return _deleteAndModifyButtons(context, product);
      default:
        return Container();
    }
  }

  Widget _onlyModifyButton(BuildContext context, ProductModel product) {
    return Column(children: [
      Expanded(child: Container()),
      SizedBox(
        width: 327.0,
        height: screenSize.getSize(45.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0))),
          child: const R18Text(
            text: '수정하기',
            textColor: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 20.0),
    ]);
  }

  Widget _deleteAndModifyButtons(BuildContext context, ProductModel product) {
    return Column(children: [
      Expanded(child: Container()),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize.getSize(160.0),
            height: screenSize.getSize(45.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0))),
              child: const R18Text(
                text: '삭제하기',
                textColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
              width: screenSize.getSize(160.0),
              height: screenSize.getSize(45.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                child: const R18Text(
                  text: '수정하기',
                  textColor: Colors.white,
                ),
              ))
        ],
      ),
      const SizedBox(height: 20.0),
    ]);
  }

  Widget _oneBottomButton(BuildContext context) {
    return Column(children: [
      Expanded(child: Container()),
      SizedBox(
        width: 327.0,
        height: screenSize.getSize(45.0),
        child: ElevatedButton(
          onPressed: () {
            _pushRequestExchangeView(context);
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

  Widget _twoBottomButtons(BuildContext context) {
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
                _pushRequestExchangeView(context);
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
          SizedBox(
              width: screenSize.getSize(160.0),
              height: screenSize.getSize(45.0),
              child: ElevatedButton(
                onPressed: () {
                  _showRequestListModal(context);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: navy,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                child: const R18Text(
                  text: '교환 수락하기',
                  textColor: Colors.white,
                ),
              ))
        ],
      ),
      const SizedBox(height: 20.0),
    ]);
  }

  _showRequestListModal(BuildContext context) {
    ProductDetailProvider provider =
        Provider.of<ProductDetailProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
            value: provider, child: RequestListModal(initialLike: like));
      },
    );
  }

  _pushRequestExchangeView(BuildContext context) {
    ProductDetailProvider provider =
        Provider.of<ProductDetailProvider>(context, listen: false);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return RequestExchangeView(acceptorProduct: provider.product!);
    }));
  }

  Widget _canNotTradeButton(BuildContext context) {
    ProductExchangeStatusCd productExchangeStatusCd =
        Provider.of<ProductDetailProvider>(context, listen: false)
            .product!
            .productExchangeStatusCd!;

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
