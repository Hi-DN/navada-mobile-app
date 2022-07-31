
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:navada_mobile_app/src/view/utils/text_style.dart';

class CostRangeBadge extends StatelessWidget {
  const CostRangeBadge
({Key? key, this.cost}) : super(key: key);

  final int? cost;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      height: size.getSize(21),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: green, width: 1.0),
      ),
      child: B12Text(text: '± $cost', textColor: green)
    );
  }
}
