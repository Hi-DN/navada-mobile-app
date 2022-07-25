// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';

TextStyle styleR =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w400);

TextStyle styleB =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w700);

TextStyle styleL =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w100);

class R12Text extends StatelessWidget {
  const R12Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleR.copyWith(fontSize: size.getSize(12), color: textColor));
  }
}

class R16Text extends StatelessWidget {
  const R16Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleR.copyWith(fontSize: size.getSize(16), color: textColor));
  }
}

class B12Text extends StatelessWidget {
  const B12Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleB.copyWith(fontSize: size.getSize(12), color: textColor));
  }
}

class B16Text extends StatelessWidget {
  const B16Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleB.copyWith(fontSize: size.getSize(16), color: textColor));
  }
}
