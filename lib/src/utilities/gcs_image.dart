import 'package:flutter/material.dart';

//fixme 기본 이미지 지정 필요
Widget getGcsImage(String? gcsImageUrl) {
  return gcsImageUrl != null
      ? Image.network(
          gcsImageUrl,
          fit: BoxFit.contain,
        )
      : Image.asset("assets/images/logo.png");
}
