import 'package:flutter/material.dart';
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
              : _twoBottomButtons();
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
          onPressed: () {},
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

  Widget _twoBottomButtons() {
    return Column(children: [
      Expanded(child: Container()),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize.getSize(160.0),
            height: screenSize.getSize(40.0),
            child: ElevatedButton(
              onPressed: () {},
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
            height: screenSize.getSize(40.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: navy,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0))),
              child: const R18Text(
                text: '교환 수락하기',
                textColor: Colors.white,
              ),
            ),
          )
        ],
      ),
      const SizedBox(height: 15.0),
    ]);
  }
}
