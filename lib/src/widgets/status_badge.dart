import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

import '../utilities/enums.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({Key? key, this.label, this.backgroundColor})
      : super(key: key);

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
        child: R12Text(text: label, textColor: white));
  }
}

class ExchangeStatusBadge extends StatelessWidget {
  const ExchangeStatusBadge({Key? key, this.statusCd}) : super(key: key);

  final ProductExchangeStatusCd? statusCd;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
        height: size.getSize(21),
        decoration: BoxDecoration(
          color: _getBackgroundColor(statusCd!),
          borderRadius: BorderRadius.circular(11),
        ),
        child: R12Text(text: statusCd?.label, textColor: white));
  }

  Color _getBackgroundColor(ProductExchangeStatusCd statusCd) {
    switch (statusCd) {
      case ProductExchangeStatusCd.REGISTERED:
        return const Color(0xFFFFF279);
      case ProductExchangeStatusCd.TRADING:
        return green;
      case ProductExchangeStatusCd.COMPLETED:
        return navy;
    }
  }
}
