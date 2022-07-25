import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/heart/heart_list_model.dart';
import 'package:navada_mobile_app/src/business_logic/heart/heart_service.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_provider.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/custom_appbar.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:navada_mobile_app/src/view/utils/text_style.dart';

class HeartList extends StatefulWidget {
  @override
  _HeartListState createState() => _HeartListState();
}

class _HeartListState extends State<HeartList> {
  final HeartService heartService = HeartService();
  ScreenSize size = ScreenSize();
  Future<HeartListModel>? _heartList;
  List<HeartListContentModel>? _heartListContent;

  @override
  void initState() {
    super.initState();
    _fetchHeartList();
  }

  _fetchHeartList() {
    int userId = UserProvider.userId;
    _heartList = heartService.getHeartsByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: '관심 상품 목록'),
      body: Center(
          child: Container(width: size.getSize(335.0), child: _buildBody())),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<HeartListModel>(
        future: _heartList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _heartListContent = snapshot.data?.dataList;
            return Column(
              children: [
                _buildCheckButton(),
                Expanded(
                    child: ListView.builder(
                  itemCount: _heartListContent?.length,
                  itemBuilder: (context, index) => _buildItem(index),
                ))
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 20.0,
              ),
            );
          }
        });
  }

  Widget _buildItem(int index) {
    Product? product = _heartListContent?.elementAt(index).product;
    return Column(children: [
      SizedBox(
        height: size.getSize(8.0),
      ),
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              'assets/images/test.jpeg',
              width: size.getSize(65.0),
              height: size.getSize(65.0),
            ),
          ),
          SizedBox(
            width: size.getSize(12.0),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              B14Text(text: product?.productName),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: '원가 ',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                TextSpan(
                    text: '${product?.productCost}원',
                    style: const TextStyle(color: Colors.black))
              ])),
              _statusBadge(product),
            ],
          ),
          Expanded(child: Container()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                size: size.getSize(25.0),
                color: green,
              ))
        ],
      ),
      SizedBox(
        height: size.getSize(8.0),
      ),
      const Divider(
        height: 1.0,
        color: grey153,
      )
    ]);
  }

  Widget _buildCheckButton() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      alignment: Alignment.centerRight,
      child: Row(children: [
        Expanded(
          child: Container(),
        ),
        IconButton(
          onPressed: () {},
          iconSize: size.getSize(18.0),
          icon: Icon(Icons.check_circle_outline),
          color: grey153,
          alignment: Alignment.centerRight,
        ),
        Text(
          '교환 가능 상품만 보기',
          style: TextStyle(color: grey153, fontSize: size.getSize(12.0)),
        )
      ]),
    );
  }

  Widget _statusBadge(Product? product) {
    return Container(
      width: size.getSize(77.0),
      height: size.getSize(26.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: product?.productStatusCd == 1 ? green : navy),
      child: Center(
        child: Text(
          product?.productStatusCd == 1 ? '교환중' : '교환완료',
          style: TextStyle(
            color: Colors.white,
            fontSize: size.getSize(12.0),
          ),
        ),
      ),
    );
  }
}
