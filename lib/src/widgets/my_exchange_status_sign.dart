import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class MyExchangeStatusSign extends StatelessWidget {
  const MyExchangeStatusSign({Key? key, this.icon, this.label, this.color}) : super(key: key);

  final IconData? icon;
  final String? label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      width: size.getSize(42),
      padding: EdgeInsets.only(left: size.getSize(7)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon!, color: color, size: 32),
          const Space(height: 5),
          R10Text(text: label, textColor: color!)
        ]
      ),
    );
  }
}
