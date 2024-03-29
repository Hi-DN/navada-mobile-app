import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/product_detail_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_view_model.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:provider/provider.dart';

import '../../models/request/requtest_dto_model.dart';
import '../../widgets/colors.dart';
import '../../widgets/screen_size.dart';
import '../../widgets/text_style.dart';

class RequestListModal extends StatelessWidget {
  RequestListModal({Key? key}) : super(key: key);
  ScreenSize screenSize = ScreenSize();

  @override
  Widget build(BuildContext context) {
    List<RequestDto> requestList =
        Provider.of<ProductDetailProvider>(context, listen: false)
            .requestDtoList;

    return ChangeNotifierProvider(
      create: (context) => ProductDetailViewModel(),
      child: Center(
        child: Column(
          children: [
            const Space(height: 20.0),
            Container(
              width: screenSize.getSize(42.0),
              height: screenSize.getSize(5.0),
              decoration: BoxDecoration(
                  color: const Color(0xFFE2E2E2),
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            const Space(height: 10.0),
            _explanationText(requestList.length),
            const Space(height: 10.0),
            Expanded(
              child: _requestListView(requestList),
            ),
            const Space(height: 20.0),
            _acceptRequestButton(),
            const Space(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _requestListView(List<RequestDto> requestList) {
    ScrollController scrollController = ScrollController();

    return SizedBox(
      width: screenSize.getSize(342.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Scrollbar(
            controller: scrollController,
            radius: const Radius.circular(10.0),
            thumbVisibility: true,
            child: ListView.builder(
                controller: scrollController,
                itemCount: requestList.length,
                itemBuilder: (context, index) {
                  return _buildItem(context, requestList[index]);
                })),
      ),
    );
  }

  Widget _buildItem(context, RequestDto request) {
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'assets/images/test.jpeg',
                    fit: BoxFit.cover,
                    width: screenSize.getSize(70.0),
                    height: screenSize.getSize(70.0),
                  ),
                ),
                const SizedBox(width: 11.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3.0),
                      B14Text(text: request.acceptorProduct!.productName),
                      Expanded(child: Container()),
                      R14Text(
                        text: "원가 ${request.acceptorProduct!.productCost}원",
                        textColor: Colors.black.withOpacity(0.5),
                      ),
                      const SizedBox(height: 2.0),
                      R14Text(
                        text:
                            "희망가격 ${request.acceptorProduct!.productCost! - request.acceptorProduct!.exchangeCostRange!}원 ~ ${request.acceptorProduct!.productCost! + request.acceptorProduct!.exchangeCostRange!}원",
                        textColor: Colors.black.withOpacity(0.5),
                      ),
                      const SizedBox(height: 3.0),
                    ],
                  ),
                ),
                SizedBox(
                  child: IconButton(
                    icon: Provider.of<ProductDetailViewModel>(context)
                                .selectedRequestId ==
                            request.requestId
                        ? const Icon(Icons.radio_button_checked, color: green)
                        : const Icon(Icons.radio_button_unchecked,
                            color: grey153),
                    onPressed: () {
                      Provider.of<ProductDetailViewModel>(context,
                              listen: false)
                          .setSelectedRequestId(request.requestId!);
                    },
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

  Widget _acceptRequestButton() {
    return Consumer2<ProductDetailProvider, ProductDetailViewModel>(
        builder: (context, provider, viewModel, child) {
      return SizedBox(
        width: screenSize.getSize(327.0),
        height: screenSize.getSize(50.0),
        child: ElevatedButton(
          onPressed: () async {
            if (viewModel.selectedRequestId != -1) {
              await provider
                  .acceptOneRequest(viewModel.selectedRequestId)
                  .then((value) => _showResultDialog(context, value));
            }
          },
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: viewModel.selectedRequestId != -1 ? navy : grey153,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.0))),
          child: const R18Text(
            text: '교환 수락하기',
            textColor: Colors.white,
          ),
        ),
      );
    });
  }

  _showResultDialog(BuildContext context, bool success) {
    ProductDetailProvider provider =
        Provider.of<ProductDetailProvider>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
            height: screenSize.getSize(70.0),
            alignment: Alignment.center,
            child: B16Text(
                text: success ? '교환신청 수락을 완료했습니다.' : '교환신청 수락에 실패했습니다.')),
        actions: <Widget>[
          Center(
            child: SizedBox(
              width: screenSize.getSize(120.0),
              child: TextButton(
                onPressed: () {
                  int productId = provider.product!.productId!;
                  provider.fetchProductDetailInfo(productId);

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                child: const R14Text(
                  text: '확인',
                  textColor: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _explanationText(int length) {
    return SizedBox(
      width: screenSize.getSize(342.0),
      child: RichText(
          text: TextSpan(children: [
        const TextSpan(
            text: '내 물품 ', style: TextStyle(fontSize: 12.0, color: navy)),
        TextSpan(
            text: '$length',
            style: const TextStyle(
                fontSize: 16.0, color: navy, fontWeight: FontWeight.w700)),
        const TextSpan(
            text: '개에 대해 이미 요청이 있어요!',
            style: TextStyle(fontSize: 12.0, color: navy))
      ])),
    );
  }
}
