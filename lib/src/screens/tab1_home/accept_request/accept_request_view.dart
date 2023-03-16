// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_single_response.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/request/requtest_dto_model.dart';
import 'package:navada_mobile_app/src/providers/accept_request_provider.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/utilities/gcs_image.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/short_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import 'accept_request_view_model.dart';
import 'other_requests_modal.dart';

class AcceptRequestView extends StatelessWidget {
  AcceptRequestView({Key? key, required this.request}) : super(key: key);

  RequestDto request;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => AcceptRequestProvider(request)),
      ChangeNotifierProvider(
          create: (context) => AcceptRequestViewModel(
              request.requestStatusCd == RequestStatusCd.DENIED)),
    ], child: MaterialApp(home: AcceptRequestScreen(request: request)));
  }
}

class AcceptRequestScreen extends StatelessWidget {
  AcceptRequestScreen({Key? key, required this.request}) : super(key: key);

  RequestDto request;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    bool isDenied =
        Provider.of<AcceptRequestViewModel>(context, listen: false).isDenied;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "교환 수락하기",
        leadingYn: true,
        onTap: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductInfo(
                isAcceptor: true,
                product: ProductModel(
                    userNickname: "내 물품",
                    productName: request.acceptorProduct!.productName,
                    productCost: request.acceptorProduct!.productCost,
                    exchangeCostRange:
                        request.acceptorProduct!.exchangeCostRange,
                    productExplanation:
                        request.acceptorProduct!.productExplanation,
                    productImageUrl: request.acceptorProduct!.productImageUrl)),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_seeOtherRequestsBtn()]),
            const CustomDivider(),
            _ProductInfo(
                isAcceptor: false,
                product: ProductModel(
                    userNickname: request.requesterProduct!.userNickname,
                    productName: request.requesterProduct!.productName,
                    productCost: request.requesterProduct!.productCost,
                    exchangeCostRange:
                        request.requesterProduct!.exchangeCostRange,
                    productExplanation:
                        request.requesterProduct!.productExplanation,
                    productImageUrl:
                        request.requesterProduct!.productImageUrl)),
            _warningSection(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShortCircledBtn(
                  text: "거절하기",
                  backgroundColor: isDenied ? grey153 : red,
                  onTap: () => isDenied ? null : _showRejectConfirmDialog(),
                ),
                const Space(width: 15),
                ShortCircledBtn(
                  text: "수락하기",
                  backgroundColor: isDenied ? grey153 : green,
                  onTap: () => isDenied ? null : _showAcceptConfirmDialog(),
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
              border: Border(
                  bottom: BorderSide(
            color: grey153,
            width: 1.0,
          ))),
          child: const R12Text(text: "다른 이웃들의 교환 요청 보기 >", textColor: grey153),
        ));
  }

  _showOtherRequests() {
    ScreenSize size = ScreenSize();
    final viewModel =
        Provider.of<AcceptRequestViewModel>(_context!, listen: false);

    showModalBottomSheet(
        context: _context!,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size.getSize(30)),
              topRight: Radius.circular(size.getSize(30))),
        ),
        builder: (context) {
          return ChangeNotifierProvider.value(
              value: viewModel, child: OtherRequestsModal());
        });
  }

  Widget _warningSection() {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.all(size.getSize(22)),
      child: const R12Text(
          text: "  ※ 해당 물품을 교환 수락할 경우,\n다른 교환 요청 물품들은 자동으로 거절합니다.",
          textColor: grey153),
    );
  }

  _showRejectConfirmDialog() {
    return showDialog(
        context: _context!,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const R14Text(text: "정말로 거절하시겠습니까?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const R14Text(text: "아니요", textColor: grey153),
              ),
              TextButton(
                onPressed: () async {
                  bool result = await Provider.of<AcceptRequestProvider>(
                          _context!,
                          listen: false)
                      .rejectRequest(request.requestId!);
                  if (result) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  }
                },
                child: const R14Text(text: "네, 거절할게요!", textColor: blue),
              ),
            ],
          );
        });
  }

  _showAcceptConfirmDialog() {
    return showDialog(
        context: _context!,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const R14Text(text: "수락하시겠습니까?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const R14Text(text: "아니요", textColor: grey153),
              ),
              TextButton(
                onPressed: () async {
                  ExchangeSingleResponse? result =
                      await Provider.of<AcceptRequestProvider>(_context!,
                              listen: false)
                          .acceptRequest(request.requestId!);
                  if (result != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  }
                },
                child: const R14Text(text: "네, 수락할게요!", textColor: blue),
              ),
            ],
          );
        });
  }
}

class _ProductInfo extends StatelessWidget {
  _ProductInfo({Key? key, required this.product, required this.isAcceptor})
      : super(key: key);

  final ProductModel product;
  final bool isAcceptor;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.all(size.getSize(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _nickNameSection(),
          const Space(height: 10),
          _imageAndDetailSection(product),
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
        Row(children: [
          B16Text(text: product.userNickname),
          const R16Text(text: "님의 물품")
        ]),
        const Space(width: 10),
        !isAcceptor ? _roleBadge() : Container()
      ],
    );
  }

  Widget _roleBadge() {
    ScreenSize size = ScreenSize();
    bool isDenied =
        Provider.of<AcceptRequestViewModel>(_context!, listen: false).isDenied;
    return Container(
        height: size.getSize(24),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDenied ? grey153 : yellow, width: 1.0),
        ),
        child: B14Text(
            text: isDenied ? '거절' : '신청',
            textColor: isDenied ? grey153 : yellow));
  }

  Widget _imageAndDetailSection(ProductModel product) {
    return Row(
      children: [
        _productImage(product.productImageUrl),
        const Space(width: 10),
        _productDetails()
      ],
    );
  }

  Widget _productImage(String? imageUrl) {
    ScreenSize size = ScreenSize();
    return ClipRRect(
      borderRadius: BorderRadius.circular(size.getSize(5)),
      child: SizedBox(
        width: size.getSize(99.0),
        height: size.getSize(99.0),
        child: getGcsImage(imageUrl),
      ),
    );
  }

  Widget _productDetails() {
    ScreenSize size = ScreenSize();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(
            product.productName!.length > 12
                ? "물품명\n\n원가\n희망가격"
                : "물품명\n원가\n희망가격",
            style: styleB.copyWith(fontSize: size.getSize(14), height: 1.6)),
        const Space(width: 8),
        Text("${_lineBreak(product.productName!)}\n${product.productCost!}원\n",
            style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6)),
      ]),
      Text("${product.getLowerBound()}원 ~ ${product.getUpperBound()}원",
          style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6)),
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
        Text("물품 설명",
            style: styleB.copyWith(fontSize: size.getSize(14), height: 1.6)),
        Text(
          product.productExplanation!,
          style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6),
        )
      ],
    );
  }
}
