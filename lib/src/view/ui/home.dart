import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_model.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_provider.dart';
import 'package:navada_mobile_app/src/view/ui/heart_list.dart';
import 'package:navada_mobile_app/src/view/ui/my_page.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel? user;
  int _currIndex = 0;

  List<Widget> _widgetList = [Text('0'), Text('1'), HeartList(), MyPage()];

  void _onMenuTapped(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetList.elementAt(_currIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: green,
        currentIndex: _currIndex,
        onTap: _onMenuTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined), label: 'favorite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'person')
        ],
      ),
    );
  }
}
