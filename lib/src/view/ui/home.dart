import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_model.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('안녕하세요\n ${user.toString()}'),
      ),
    );
  }
}
