import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

class NoRequests extends StatelessWidget {
  const NoRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraint) => 
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: _noRequestsNotice()
              ),
            ),
          )
      )
    );
  }

  Widget _noRequestsNotice() {
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
      const R14Text(
        text: '새로운 요청이 없네요 ㅜㅜ\n  낙담말고 기다려보세요!',
        textColor: grey153,
      ),
      const Space(height: kBottomNavigationBarHeight)
    ]);
  }
}
