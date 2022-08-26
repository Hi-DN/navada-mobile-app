import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_dto_model.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail_requests.dart';
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
              : _twoBottomButtons(provider.requestDtoList);
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

  Widget _twoBottomButtons(List<RequestDtoContentModel> requestList) {
    return Column(children: [
      Expanded(child: Container()),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize.getSize(160.0),
            height: screenSize.getSize(40.0),
            child: ElevatedButton(
              onPressed: () {
                //fixme 신청 화면으로 이동!
                print('신청하기 버튼 클릭!');
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
          const ProductDetailRequests(),
        ],
      ),
      const SizedBox(height: 20.0),
    ]);
  }
}
