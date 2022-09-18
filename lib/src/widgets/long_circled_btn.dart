import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class LongCircledBtn extends StatelessWidget {
  const LongCircledBtn({
    Key? key, @required this.text, this.onTap, this.backgroundColor=green})  : super(key: key);

  final String? text;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: size.getSize(327),
        height: size.getSize(54),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: backgroundColor
        ),
        child: B16Text(text: text, textColor: white)
      ),
    );
  }
}
