import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider(
      {Key? key, this.thickness = 1.0, this.horizontalIndent = 0.0})
      : super(key: key);

  final double thickness;
  final double horizontalIndent;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Divider(
      height: 0.0,
      color: grey216,
      thickness: thickness,
      indent: size.getSize(horizontalIndent),
      endIndent: size.getSize(horizontalIndent),
    );
  }
}
