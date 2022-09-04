import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/screens/heart/heart_view.dart';
import 'package:navada_mobile_app/src/screens/home/home_view.dart';
import 'package:navada_mobile_app/src/screens/my_exchange/my_exchanges_view.dart';
import 'package:navada_mobile_app/src/screens/my_page.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';

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
    const MyExchangesView(),
    const HeartView(),
    const MyPage()
  ];

  void _onMenuTapped(int index) {
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
        padding: const EdgeInsets.only(top:35),
        child: FloatingActionButton(
          onPressed: () {
            debugPrint('+ 버튼 클릭');
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
            const SizedBox(width: 70.0),
            _buildMenu(2, Icons.favorite_border_outlined),
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
