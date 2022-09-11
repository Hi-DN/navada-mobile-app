import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class NoElements extends StatelessWidget {
  const NoElements({Key? key, required this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraint) => 
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight, minWidth: double.infinity),
              child: IntrinsicHeight(
                child: _noElementsNotice()
              ),
            ),
          )
      )
    );
  }

  Widget _noElementsNotice() {
    ScreenSize size = ScreenSize();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Icon(
        Icons.tag_faces_sharp,
        size: size.getSize(96),
        color: grey216,
      ),
      const Space(height: 10),
      R14Text(
        text: text!,
        textColor: grey153,
      ),
      const Space(height: kBottomNavigationBarHeight)
    ]);
  }
}
