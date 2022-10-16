import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';
import 'package:navada_mobile_app/src/screens/accept_request/other_requests_modal.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/short_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';


class AcceptRequestView extends StatelessWidget {
  AcceptRequestView({Key? key, required this.request}) : super(key: key);

  RequestModel request;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: CustomAppBar(
          titleText: "교환 수락하기",
          leadingYn: true,
          onTap: () => Navigator.of(context).pop(),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductInfo(
                isAcceptor: true,
                product: ProductModel(
                  userNickname: "내 물품",
                  productName: request.acceptorProductName,
                  productCost: request.acceptorProductCost,
                  exchangeCostRange: request.acceptorProductCostRange,
                  productExplanation: request.requesterProductExplanation)
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  _seeOtherRequestsBtn()]),
              const CustomDivider(),
              _ProductInfo(
                isAcceptor: false,
                product: ProductModel(
                  userNickname: request.requesterNickName,
                  productName: request.requesterProductName,
                  productCost: request.requesterProductCost,
                  exchangeCostRange: request.requesterProductCostRange,
                  productExplanation: request.requesterProductExplanation)),
              _warningSection(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ShortCircledBtn(
                    text: "거절하기",
                    backgroundColor: red,                      
                  ),
                  Space(width: 15),
                  ShortCircledBtn(
                    text: "수락하기"
                  ),
                ],
              ),
              const Space(height: 20)
            ],
          ),
        ),
    );
  }

  Widget _seeOtherRequestsBtn() {
    return TextButton(
      onPressed: () => _showOtherRequests(),
      child: Container(
        decoration: const BoxDecoration(
         border: Border(bottom: BorderSide(
         color: grey153, 
         width: 1.0,
        ))
      ),
        child: const R12Text(
          text: "다른 이웃들의 교환 요청 보기 >", 
          textColor: grey153),
      ));
  }

  _showOtherRequests() {
    ScreenSize size = ScreenSize();
    
    showModalBottomSheet(
      context: _context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.getSize(30)), 
          topRight: Radius.circular(size.getSize(30))),
      ),
      builder: (context) {
        return const OtherRequestsModal();
      },
    );
  }

  Widget _warningSection() {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.all(size.getSize(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Space(height: 20),
          R12Text(
            text: "  ※ 해당 물품을 교환 수락할 경우,\n다른 교환 요청 물품들은 자동으로 거절합니다.", 
            textColor: grey153),
          // Space(height: 20),
        ],
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({Key? key, required this.product, required this.isAcceptor}) : super(key: key);

  final ProductModel product;
  final bool isAcceptor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.all(size.getSize(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _nickNameSection(),
          const Space(height: 10),
          _imageAndDetailSection(),
          const Space(height: 13),
          _productExplanationSection(),
          const Space(height: 20),
        ],
      ),
    );
  }

  Widget _nickNameSection() {
    return Row(
      children: [
        Row(children: [B16Text(text: product.userNickname), const R16Text(text: "님의 물품")]),
        const Space(width: 10),
        !isAcceptor? _roleBadge() : Container()
      ],
    );
  }

  Widget _roleBadge() {
    ScreenSize size = ScreenSize();
    return Container(
      height: size.getSize(24),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: yellow, width: 1.0),
      ),
      child: const B14Text(text: '신청', textColor: yellow)
    );
  }

  Widget _imageAndDetailSection() {
    return Row(
      children: [
        _exampleImage(),
        const Space(width: 10),
        _productDetails()
      ],
    );
  }

  Widget _exampleImage() {
    ScreenSize size = ScreenSize();
    return ClipRRect(
      borderRadius: BorderRadius.circular(size.getSize(5)),
      child: Image.asset(
        'assets/images/test.jpeg',
        width: size.getSize(99.0),
        height: size.getSize(99.0),
      )
    );
  }

  Widget _productDetails() {
    ScreenSize size = ScreenSize();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
            Text(product.productName!.length > 12 ? "물품명\n\n원가\n희망가격" : "물품명\n원가\n희망가격", style: styleB.copyWith(fontSize: size.getSize(14), height: 1.6)),
            const Space(width: 8),
            Text("${_lineBreak(product.productName!)}\n${product.productCost!}원\n", style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6)),
        ]),
        Text("${product.getLowerBound()}원 ~ ${product.getUpperBound()}원", style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6)),
      ]);
  }

  String _lineBreak(String? str) {
    if (str!.length > 12) {
      str = "${str.substring(0, 12)}\n${str.substring(12, str.length)}";
    }
    return str;
  }

  Widget _productExplanationSection() {
    ScreenSize size = ScreenSize();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("물품 설명", style: styleB.copyWith(fontSize: size.getSize(14), height: 1.6)),
        Text(
          product.productExplanation!,
          style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6),
        )
      ],
    );
  }
}