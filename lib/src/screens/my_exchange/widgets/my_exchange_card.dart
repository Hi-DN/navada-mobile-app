import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';

import 'my_exchange_status_sign.dart';

class MyExchangeCard extends StatelessWidget {
  const MyExchangeCard({Key? key, this.statusSign, this.params}) : super(key: key);

  final MyExchangeStatusSign? statusSign;
  final MyExchangeCardParams? params;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Container(
      height: size.getSize(76),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.getSize(10)),
        border: Border.all(color: Colors.white, width: 3.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x90979797),
            offset: Offset(3.0, 3.0), //(x,y)
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Row(
        children: [
          statusSign!,
          const VerticalDivider(thickness: 1, color: grey239, indent: 0, endIndent: 0),
          _productContent(params?.requesterProductName, params?.requesterNickname, params?.requesterProductCost, params?.requesterProductCostRange, false),
          const VerticalDivider(thickness: 1, color: grey239, indent: 3, endIndent: 3),
          _productContent(params?.acceptorProductName, params?.acceptorNickname, params?.acceptorProductCost, params?.acceptorProductCostRange, true),
        ],
      )
    );
  }

  Widget _productContent(String? productName, Widget? nickName, int? cost, int? costRange, bool isAcceptor) {
    ScreenSize size = ScreenSize();

    return SizedBox(
      width: size.getSize(132),
      child: Row(
        children: [
          _exampleImage(),
          const Space(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: size.getSize(87),
                    child: R12Text(text: productName)),
                ],
              ),
              nickName!,
              R10Text(text: "원가 $cost원"),
              R10Text(text: "± $costRange원", textColor: grey183,)
            ],
          )
        ],
      ),
    );
  }

  Widget _exampleImage() {
    ScreenSize size = ScreenSize();
    return Container(
      width: size.getSize(40.0),
      height: size.getSize(50.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/test.jpeg')
        ),
      ),
    );
  }
}

class MyExchangeCardParams{
  const MyExchangeCardParams({this.requesterProductName, this.requesterNickname, this.requesterProductCost, this.requesterProductCostRange, this.acceptorProductName, this.acceptorNickname, this.acceptorProductCost, this.acceptorProductCostRange});

  final String? requesterProductName;
  final Widget? requesterNickname;
  final int? requesterProductCost;
  final int? requesterProductCostRange;
  final String? acceptorProductName;
  final Widget? acceptorNickname;
  final int? acceptorProductCost;
  final int? acceptorProductCostRange;
}
