import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/screens/complete_exchange/complete_exchange_view_model.dart';
import 'package:navada_mobile_app/src/screens/complete_exchange/exchange_confirm_modal.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class CompleteExchangeView extends StatelessWidget {
  const CompleteExchangeView({Key? key, this.exchange}) : super(key: key);

  final ExchangeDtoModel? exchange;

  @override
  Widget build(BuildContext context) {

    int userId = Provider.of<UserProvider>(context, listen: false).user.userId;
    bool isAcceptor = (userId == exchange!.acceptorId);
    bool isCompleteFeatureActive = !(isAcceptor ? exchange!.acceptorConfirmYn! : exchange!.requesterConfirmYn!);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CompleteExchangeViewModel(isCompleteFeatureActive)),
      ],
      child: Consumer<CompleteExchangeViewModel>(builder: 
        (BuildContext context, CompleteExchangeViewModel viewModel, Widget? _) {

        bool isCompleteBtnActive = viewModel.isCompleteFeatureActive;
        
        return Scaffold(
          appBar: CustomAppBar(
            titleText: "교환 완료하기",
            leadingYn: true,
            onTap: () => Navigator.of(context).pop(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _ProductInfo(product: exchange!.requesterProduct, isAcceptor: false),
                const CustomDivider(),
                _ProductInfo(product: exchange!.acceptorProduct, isAcceptor: true),
                LongCircledBtn(
                  text: "교환 완료하기",
                  onTap: () => isCompleteBtnActive ? _showExchangeConfirmModal(context) : null,
                  backgroundColor: isCompleteBtnActive ? green : grey183,                  
                ),
                const Space(height: 20)
              ],
            ),
          ),
        );
      })
      
    );
  }

  _showExchangeConfirmModal(BuildContext? context) {
    ScreenSize size = ScreenSize();
    showModalBottomSheet(
      context: context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.getSize(30)), 
          topRight: Radius.circular(size.getSize(30))),
      ),
      builder: (context) {
        return ExchangeConfirmModal(exchange: exchange);
      },
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({Key? key, this.product, this.isAcceptor}) : super(key: key);

  final ProductModel? product;
  final bool? isAcceptor;

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
        Row(children: [B16Text(text: product!.userNickname), const R16Text(text: "님의 물품")]),
        const Space(width: 10),
        _roleBadge()
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
        border: Border.all(color: isAcceptor! ? navy : green, width: 1.0),
      ),
      child: B14Text(text: isAcceptor! ? '수락' : '신청', textColor: isAcceptor! ? navy : green)
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
            Text(product!.productName!.length > 12 ? "물품명\n\n원가\n희망가격" : "물품명\n원가\n희망가격", style: styleB.copyWith(fontSize: size.getSize(14), height: 1.6)),
            const Space(width: 8),
            Text("${_lineBreak(product!.productName!)}\n${product!.productCost!}원\n", style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6)),
        ]),
        Text("${product!.getLowerBound()}원 ~ ${product!.getUpperBound()}원", style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6)),
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
          product!.productExplanation!,
          style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6),
        )
      ],
    );
  }
}

