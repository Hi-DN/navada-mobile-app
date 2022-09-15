import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    @required this.titleText,
    this.leadingYn = false,
    this.onTap,
    this.popBoolValue = true,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  final String? titleText;
  final bool? leadingYn;
  final VoidCallback? onTap;
  final bool? popBoolValue;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();

    return AppBar(
        leading: leadingYn ?? false
            ? GestureDetector(
                onTap: onTap,
                child: const Icon(Icons.arrow_back, color: grey153))
            : Container(),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: grey216,
              height: 1.0,
            )),
        title: B18Text(text: titleText));
  }
}
