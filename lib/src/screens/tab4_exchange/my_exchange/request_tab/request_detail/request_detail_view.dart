import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/request/request_service.dart';
import 'package:navada_mobile_app/src/models/request/requtest_dto_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/status_badge.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class RequestDetailView extends StatelessWidget {
  const RequestDetailView({super.key, this.request});

  final RequestDto? request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "상세보기",
        leadingYn: true,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              _requestInfo(request!),
              _ProductInfo(
                  product: request!.requesterProduct!,
                  isAcceptor: false,
                  requestStatusCd: request!.requestStatusCd),
              const CustomDivider(),
              _ProductInfo(
                  product: request!.acceptorProduct!,
                  isAcceptor: true,
                  requestStatusCd: request!.requestStatusCd),
              const Space(height: 50.0),
            ],
          ),
        ),
        _bottomButton(context, request!)
      ]),
    );
  }
}

Widget _requestInfo(RequestDto request) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 22.0, top: 10.0),
    child: R14Text(
      textColor: grey153,
      text: '신청일자 ${request.requestCreatedDt!.split('T')[0]}',
    ),
  );
}

Widget _bottomButton(BuildContext context, RequestDto request) {
  RequestStatusCd requestStatusCd = request.requestStatusCd!;
  bool isDeniedRequest = requestStatusCd == RequestStatusCd.DENIED;
  return Container(
    alignment: Alignment.bottomCenter,
    padding: const EdgeInsets.only(bottom: 30.0),
    child: LongCircledBtn(
        onTap: () {
          _showConfirmDialog(context, isDeniedRequest, request.requestId!);
        },
        text: isDeniedRequest ? '삭제하기' : '신청 취소하기',
        backgroundColor: isDeniedRequest ? red : green),
  );
}

_showConfirmDialog(BuildContext context, bool isDeniedRequest, int requestId) {
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  RequestService requestService = RequestService();

  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: R16Text(
        text: isDeniedRequest ? '거절내역을 삭제하시겠습니까?' : '교환신청을 정말로 취소하시겠습니까?',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => navigator.pop(),
          child: const R14Text(text: "아니요", textColor: grey153),
        ),
        TextButton(
          onPressed: isDeniedRequest
              ? () async {
                  RequestDto? result = await requestService
                      .deleteDeniedRequestByRequester(requestId);

                  if (result != null) {
                    navigator.pop();
                    navigator.pop();
                  } else {
                    messenger.showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: R16Text(
                          text: '삭제에 실패했습니다. 다시 시도해주세요.', textColor: white),
                    ));
                    navigator.pop();
                  }
                }
              : () async {
                  bool success = await requestService.deleteRequest(requestId);

                  if (success) {
                    navigator.pop();
                    navigator.pop();
                  } else {
                    messenger.showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: R16Text(
                          text: '신청취소에 실패했습니다. 다시 시도해주세요.', textColor: white),
                    ));
                    navigator.pop();
                  }
                },
          child: R14Text(
            text: isDeniedRequest ? "네, 삭제할게요!" : "네, 취소할게요!",
          ),
        ),
      ],
    ),
  );
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo(
      {Key? key, this.product, required this.isAcceptor, this.requestStatusCd})
      : super(key: key);

  final ProductModel? product;
  final bool isAcceptor;
  final RequestStatusCd? requestStatusCd;

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
        Row(children: [
          B16Text(text: product!.userNickname),
          const R16Text(text: "님의 물품")
        ]),
        const Space(width: 10),
        (requestStatusCd == RequestStatusCd.DENIED)
            ? (isAcceptor ? Container() : _deniedBadge())
            : (isAcceptor ? Container() : _waitBadge())
      ],
    );
  }

  Widget _waitBadge() {
    return const StatusBadge(
      label: '신청',
      labelColor: yellow,
      borderColor: yellow,
    );
  }

  Widget _deniedBadge() {
    return const StatusBadge(
      label: '거절됨',
      labelColor: grey153,
      borderColor: grey153,
    );
  }

  Widget _imageAndDetailSection() {
    return Row(
      children: [_exampleImage(), const Space(width: 10), _productDetails()],
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
        ));
  }

  Widget _productDetails() {
    ScreenSize size = ScreenSize();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(
            product!.productName!.length > 12
                ? "물품명\n\n원가\n희망가격"
                : "물품명\n원가\n희망가격",
            style: styleB.copyWith(fontSize: size.getSize(14), height: 1.6)),
        const Space(width: 8),
        Text(
            "${_lineBreak(product!.productName!)}\n${product!.productCost!}원\n",
            style: styleR.copyWith(fontSize: size.getSize(14), height: 1.6)),
      ]),
      Text("${product!.getLowerBound()}원 ~ ${product!.getUpperBound()}원",
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
            style: styleB.copyWith(fontSize: size.getSize(16), height: 1.6)),
        Text(
          product!.productExplanation!,
          style: styleR.copyWith(fontSize: size.getSize(16), height: 1.6),
        )
      ],
    );
  }
}
