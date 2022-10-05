// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';

TextStyle styleR =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w400);

TextStyle styleB =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w700);

TextStyle styleL =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w100);

    
class R8Text extends StatelessWidget {
  const R8Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleR.copyWith(fontSize: size.getSize(8), color: textColor));
  }
}

class B8Text extends StatelessWidget {
  const B8Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleB.copyWith(fontSize: size.getSize(8), color: textColor));
  }
}

class R10Text extends StatelessWidget {
  const R10Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleR.copyWith(fontSize: size.getSize(10), color: textColor));
  }
}

class B10Text extends StatelessWidget {
  const B10Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleB.copyWith(fontSize: size.getSize(10), color: textColor));
  }
}

class R12Text extends StatelessWidget {
  const R12Text({Key? key, @required this.text, this.textColor=black, this.params})
      : super(key: key);

  final String? text;
  final Color textColor;
  final TextParams? params;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return CustomText(
      text: text!,
      style: styleR.copyWith(fontSize: size.getSize(12), color: textColor),
      params: params,
    );
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

class R14Text extends StatelessWidget {
  const R14Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleR.copyWith(fontSize: size.getSize(14), color: textColor));
  }
}

class B14Text extends StatelessWidget {
  const B14Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleB.copyWith(fontSize: size.getSize(14), color: textColor));
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

class R18Text extends StatelessWidget {
  const R18Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleR.copyWith(fontSize: size.getSize(18), color: textColor));
  }
}

class B18Text extends StatelessWidget {
  const B18Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleB.copyWith(fontSize: size.getSize(18), color: textColor));
  }
}

class R20Text extends StatelessWidget {
  const R20Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleR.copyWith(fontSize: size.getSize(20), color: textColor));
  }
}

class B20Text extends StatelessWidget {
  const B20Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Text(text!,
        style: styleB.copyWith(fontSize: size.getSize(20), color: textColor));
  }
}

class CustomText extends StatelessWidget {
  const CustomText({Key? key, @required this.text, this.style, this.params})
     : super(key: key);
  
  final String? text;
  final TextStyle? style;
  final TextParams? params;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: style,
      strutStyle: params!.strutStyle,
      textAlign: params!.textAlign,
      textDirection: params!.textDirection,
      locale: params!.locale,
      softWrap: params!.softWrap,
      overflow: params!.overflow,
      textScaleFactor: params!.textScaleFactor,
      maxLines: params!.maxLines,
      semanticsLabel: params!.semanticsLabel,
      textWidthBasis: params!.textWidthBasis,
      textHeightBehavior: params!.textHeightBehavior,
    );
  }
}

class TextParams {
  const TextParams({Key? key, 
  this.style, 
  this.strutStyle,
  this.textAlign,
  this.textDirection,
  this.locale,
  this.softWrap,
  this.overflow,
  this.textScaleFactor, this.maxLines,
  this.semanticsLabel, this.textWidthBasis,this.textHeightBehavior});

  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
}
