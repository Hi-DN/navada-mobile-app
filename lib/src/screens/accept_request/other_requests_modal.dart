import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';

class OtherRequestsModal extends StatelessWidget {
  const OtherRequestsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return SizedBox(
      height: size.getSize(600),
      child: const Text("모달"),
    );
  }
}