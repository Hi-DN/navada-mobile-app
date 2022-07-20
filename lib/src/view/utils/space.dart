// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';

class Space extends StatelessWidget {
  final double width;
  final double height;

  const Space({Key? key, this.width = 0.0, this.height = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return SizedBox(
      width: size.getSize(width),
      height: size.getSize(height),
    );
  }
}
