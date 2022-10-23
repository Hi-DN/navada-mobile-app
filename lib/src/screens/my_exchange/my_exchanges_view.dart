import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_exchange_provider.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_request_provider.dart';
import 'package:navada_mobile_app/src/screens/my_exchange/my_exchanges_view_model.dart';
import 'package:navada_mobile_app/src/screens/my_exchange/products_I_requested_widget.dart';
import 'package:navada_mobile_app/src/screens/my_exchange/trading_and_completed_tab_widget.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class MyExchangesView extends StatelessWidget {
  const MyExchangesView({Key? key}) : super(key: key);

  static const routeName = 'my-exchanges';

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    User user = Provider.of<UserProvider>(context, listen: false).user;
    
    return Scaffold(
      appBar: CustomAppBar(titleText: '내 물물교환'),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyExchangesViewModel()),
        ],
            child: Container(
        color: white,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                onTap: (index) {
                  if(index == 0) {
                    Provider.of<MyExchangesExchangeProvider>(context, listen: false).fetchData(isRefresh: true);
                  } else {
                    Provider.of<MyExchangesRequestProvider>(context, listen: false).fetchData(isRefresh: true);
                  }
                },
                tabs: [
                  Tab(text: "교환중/교환완료", height: size.getSize(58)),
                  Tab(text: "내가 신청한 물품", height: size.getSize(58)),
                ],
                labelColor: green,
                labelStyle: styleR.copyWith(fontSize: size.getSize(16)),
                indicatorColor: green,
                unselectedLabelColor: grey183,
                unselectedLabelStyle: styleR.copyWith(fontSize: size.getSize(16)),
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    TradingAndCompletedTab(),
                    ProductsThatIRequested()
                  ],
                ),
              )])
        ),
      )));
  }
}