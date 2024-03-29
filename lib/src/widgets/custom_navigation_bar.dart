import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_exchange_provider.dart';
import 'package:navada_mobile_app/src/providers/search_products_provider.dart';
import 'package:navada_mobile_app/src/screens/tab5_mypage/my_page.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:provider/provider.dart';

import '../screens/tab1_home/home/home_view.dart';
import '../screens/tab2_products/search_products/search_products_view.dart';
import '../screens/tab2_products/search_products/search_products_view_model.dart';
import '../screens/tab3_create/create_product/create_product_view.dart';
import '../screens/tab4_exchange/my_exchange/my_exchanges_view.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);
  static const routeName = 'navigation-bar';

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  UserModel? user;
  int _currIndex = 0;

  final List<Widget> _widgetList = [
    const HomeView(),
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SearchProductsViewModel()),
      ChangeNotifierProvider(create: (context) => SearchProductsProvider())
    ], child: SearchProductsView()),
    const MyExchangesView(),
    const MyPage()
  ];

  void _onMenuTapped(int index) {
    int userId = UserProvider.user.userId!;
    if (index == 2) {
      Provider.of<MyExchangesExchangeProvider>(context, listen: false)
          .fetchData(userId, isRefresh: true);
    }
    setState(() {
      _currIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const CreateProductView()));
          },
          tooltip: 'Increment',
          backgroundColor: green,
          elevation: 0.0,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: _widgetList.elementAt(_currIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMenu(0, Icons.home_outlined),
            _buildMenu(1, Icons.menu),
            const SizedBox(width: 66.0),
            _buildMenu(2, Icons.compare_arrows),
            _buildMenu(3, Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(int index, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          _onMenuTapped(index);
        },
        icon: Icon(
          icon,
          size: 30.0,
          color: _currIndex == index ? green : grey153,
        ),
      ),
    );
  }
}
