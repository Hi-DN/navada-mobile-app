import 'package:flutter/material.dart';

class Shortener {
  static shortenStrTo(String? str, int wantedLength) {
    if (str!.length <= wantedLength) {
      return str;
    } else {
      return '${str.substring(0, wantedLength)}...';
    }
  }

  static shortenStrWithMaxLines(String? text, int maxLine, TextStyle style) {
    return Text(
      text!,
      style: style,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}
