import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/request/requtest_dto_model.dart';
import 'package:navada_mobile_app/src/providers/accept_request_provider.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import 'accept_request_view.dart';

class OtherRequestsModal extends StatelessWidget {
  OtherRequestsModal({Key? key}) : super(key: key);

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    Provider.of<AcceptRequestProvider>(_context!, listen: false)
        .loadMore(false);
    ScreenSize size = ScreenSize();
    return Container(
      padding: EdgeInsets.only(
          top: size.getSize(15),
          left: size.getSize(15),
          right: size.getSize(15)),
      height: size.getSize(420),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _greyStick(),
          const Space(height: 15),
          _titleSection(),
          const Space(height: 15),
          Expanded(child: _otherRequestListSection()),
        ],
      ),
    );
  }

  Widget _greyStick() {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: 3,
            width: size.getSize(40),
            decoration: BoxDecoration(
              color: grey216,
              borderRadius: BorderRadius.circular(size.getSize(10)),
              border: Border.all(color: Colors.white, width: 3.0),
            ))
      ]),
    );
  }

  Widget _titleSection() {
    return const B16Text(text: "이웃들의 교환요청");
  }

  Widget _otherRequestListSection() {
    ScreenSize size = ScreenSize();
    List<RequestDto> requests =
        Provider.of<AcceptRequestProvider>(_context!).otherRequests;
    return requests.isNotEmpty
        ? NotificationListener<ScrollNotification>(
            onNotification: _scrollNotification,
            child: RefreshIndicator(
              color: green,
              displacement: size.getSize(22),
              onRefresh: () async {
                Provider.of<AcceptRequestProvider>(_context!, listen: false)
                    .loadMore(true);
              },
              child: ListView.separated(
                  padding: const EdgeInsets.all(0.0),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    RequestDto request = requests[index];

                    return _productTile(request);
                  },
                  separatorBuilder: (context, index) {
                    return const CustomDivider();
                  }),
            ),
          )
        : const NoElements(text: "교환요청이 없습니다.");
  }

  bool _scrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.atEdge && scrollInfo.metrics.pixels != 0) {
      Provider.of<AcceptRequestProvider>(_context!, listen: false)
          .loadMore(false);
    }

    return true;
  }

  Widget _productTile(RequestDto request) {
    ProductModel product = request.requesterProduct!;
    ScreenSize size = ScreenSize();
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.getSize(15)),
      height: size.getSize(70.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _exampleImage(),
          const Space(width: 15),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  B14Text(
                      text: Shortener.shortenStrTo(product.productName!, 12)),
                  R14Text(
                      text:
                          ' | ${Shortener.shortenStrTo(product.userNickname!, 4)}',
                      textColor: grey153)
                ]),
                Row(children: [
                  const B14Text(text: '원가 '),
                  R14Text(text: product.productCost!.toString())
                ]),
                Row(children: [
                  const B14Text(text: '희망가격 '),
                  R14Text(
                      text:
                          "${product.productCost! - product.exchangeCostRange!} ~ ${product.productCost! + product.exchangeCostRange!}")
                ])
              ]),
          const Expanded(child: SizedBox()),
          _goAcceptRequestBtn(request),
        ],
      ),
    );
  }

  Widget _exampleImage() {
    ScreenSize size = ScreenSize();
    return ClipRRect(
        borderRadius: BorderRadius.circular(size.getSize(5)),
        child: Image.asset(
          'assets/images/test.jpeg',
          width: size.getSize(70.0),
          height: size.getSize(70.0),
        ));
  }

  Widget _goAcceptRequestBtn(RequestDto request) {
    ScreenSize size = ScreenSize();
    return GestureDetector(
        onTap: () => Navigator.push(
            _context!,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    AcceptRequestView(request: request))),
        child: Icon(Icons.arrow_forward_ios,
            color: grey183, size: size.getSize(18)));
  }
}
