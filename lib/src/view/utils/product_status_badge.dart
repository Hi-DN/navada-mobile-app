
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/enums.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:navada_mobile_app/src/view/utils/text_style.dart';

class ProductStatusBadge extends StatelessWidget {
  const ProductStatusBadge
({Key? key, this.productStatusCd}) : super(key: key);

  final ProductStatusCd? productStatusCd;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
      height: size.getSize(21),
      decoration: BoxDecoration(
        color: productStatusCd == ProductStatusCd.TRADING 
          ? green 
          : navy,
        borderRadius: BorderRadius.circular(11),
      ),
      child: R12Text(
        text: productStatusCd == ProductStatusCd.TRADING 
          ? '교환중' 
          : '교환완료', 
        textColor: white
      )
    );
  }
}
