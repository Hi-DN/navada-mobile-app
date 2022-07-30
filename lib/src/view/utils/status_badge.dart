
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:navada_mobile_app/src/view/utils/text_style.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge
({Key? key, this.label, this.backgroundColor}) : super(key: key);

  final String? label;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
      height: size.getSize(21),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: R12Text(
        text: label, 
        textColor: white
      )
    );
  }
}
