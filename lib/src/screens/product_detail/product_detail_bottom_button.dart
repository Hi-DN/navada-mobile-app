import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_dto_model.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:provider/provider.dart';

import '../../providers/product_detail_provider.dart';
import '../../widgets/colors.dart';
import '../../widgets/text_style.dart';

// ignore: must_be_immutable
class ProductDetailBottomButton extends StatelessWidget {
  final int productId;
  ScreenSize screenSize = ScreenSize();

  ProductDetailBottomButton({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductDetailProvider>(context, listen: false)
        .fetchRequestDtoList(productId);

    return Consumer<ProductDetailProvider>(
      builder: (context, provider, widget) {
        if (provider.fetchCompleted && provider.requestDtoModel.success) {
          return provider.requestDtoList.isEmpty
              ? _oneBottomButton()
              : _twoBottomButtons(context, provider.requestDtoList);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _oneBottomButton() {
    return Column(children: [
      Expanded(child: Container()),
      SizedBox(
        width: screenSize.getSize(327.0),
        height: screenSize.getSize(40.0),
        child: ElevatedButton(
          onPressed: () {
            //fixme 교환 신청 화면으로!
            print('신청하기 버튼 클릭!');
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
      const SizedBox(height: 15.0),
    ]);
  }

  Widget _twoBottomButtons(
      BuildContext context, List<RequestDtoContentModel> requestList) {
    return Column(children: [
      Expanded(child: Container()),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _setButton(context, true, requestList),
          _setButton(context, false, requestList),
        ],
      ),
      const SizedBox(height: 15.0),
    ]);
  }

  Widget _setButton(BuildContext context, bool isNewRequest,
      List<RequestDtoContentModel> requestList) {
    return SizedBox(
      width: screenSize.getSize(160.0),
      height: screenSize.getSize(40.0),
      child: ElevatedButton(
        onPressed: () {
          //fixme 신청 화면으로 이동!
          isNewRequest
              ? print('신청하기 버튼 클릭!')
              : _showRequestListSheet(context, requestList);
        },
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: isNewRequest ? green : navy,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0))),
        child: R18Text(
          text: isNewRequest ? '새로 신청하기' : '교환 수락하기',
          textColor: Colors.white,
        ),
      ),
    );
  }

  _showRequestListSheet(
      BuildContext context, List<RequestDtoContentModel> requestList) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
              width: screenSize.getSize(42.0),
              height: screenSize.getSize(5.0),
              decoration: BoxDecoration(
                  color: const Color(0xFFE2E2E2),
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            const SizedBox(height: 20.0),
            Expanded(child: _requestListView(context, requestList)),
            const SizedBox(height: 20.0),
            _modalBottomButton(),
            const SizedBox(height: 20.0),
          ],
        );
      },
    );
  }

  Widget _requestListView(
      BuildContext context, List<RequestDtoContentModel> requestList) {
    ScrollController scrollController = ScrollController();
    return SizedBox(
      width: screenSize.getSize(342.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: CupertinoScrollbar(
          controller: scrollController,
          radius: const Radius.circular(10.0),
          thumbVisibility: true,
          child: ListView.builder(
              controller: scrollController,
              //fixme test용
              // itemCount: requestList.length,
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildItem(requestList[0]);
              }),
        ),
      ),
    );
  }

  Widget _buildItem(RequestDtoContentModel request) {
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
                SizedBox(
                  height: screenSize.getSize(70.0),
                  width: screenSize.getSize(70.0),
                  child: Image.asset(
                    'assets/images/test.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 11.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3.0),
                      B14Text(text: request.acceptorProductName),
                      Expanded(child: Container()),
                      R14Text(
                        text: "원가 ${request.acceptorProductCost}원",
                        textColor: Colors.black.withOpacity(0.5),
                      ),
                      const SizedBox(height: 2.0),
                      R14Text(
                        text:
                            "희망가격 ${request.acceptorProductCost - request.acceptorProductCostRange}원 ~ ${request.acceptorProductCost - request.acceptorProductCostRange}원",
                        textColor: Colors.black.withOpacity(0.5),
                      ),
                      const SizedBox(height: 3.0),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenSize.getSize(20.0),
                  height: screenSize.getSize(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // viewProvider.setSelectedRequestId(request.requestId);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        elevation: 0.0,
                        primary:
                            // viewProvider.selectedRequestId == request.requestId
                            //     ? green
                            Colors.white,
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

  Widget _modalBottomButton() {
    return SizedBox(
      width: screenSize.getSize(327.0),
      height: screenSize.getSize(50.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: navy,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.0))),
        child: const R18Text(
          text: '교환 수락하기',
          textColor: Colors.white,
        ),
      ),
    );
  }
}
