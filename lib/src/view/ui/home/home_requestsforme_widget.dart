import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/business_logic/request/request_model.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_model.dart';
import 'package:navada_mobile_app/src/business_logic/user/user_provider.dart';
import 'package:navada_mobile_app/src/view/utils/colors.dart';
import 'package:navada_mobile_app/src/view/utils/cost_range_badge.dart';
import 'package:navada_mobile_app/src/view/utils/enums.dart';
import 'package:navada_mobile_app/src/view/ui/home/home_requestsforme_controller.dart';
import 'package:navada_mobile_app/src/view/utils/screen_size.dart';
import 'package:navada_mobile_app/src/view/utils/space.dart';
import 'package:navada_mobile_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

class RequestsForMeSection extends StatelessWidget {
  const RequestsForMeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user =Provider.of<UserProvider>(context, listen: false).userModel;

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => RequestsForMeController(),
        child: Column(
          children: [
            _sectionTitle(user.userNickname!),
            Expanded(
              child: _buildScreenDependingOnDataState()
            ),
          ],
        )
      )
    );
  }

  Widget _sectionTitle(String userNickname) {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getSize(18)),
      child: Row(
        children: [
          B16Text(text: userNickname),
          const R16Text(text: '님에게 온 교환 요청'),
        ],
      ),
    );
  }

  Widget _buildScreenDependingOnDataState() {
    return Consumer<RequestsForMeController>(
      builder: (BuildContext context, RequestsForMeController controller, Widget? _) {
          switch(controller.dataState) {
            case DataState.UNINITIALIZED:
              Future(() {
                controller.fetchData();
              });
              return _RequestsForMeGridView(requestsForMe: controller.dataList, isLoading: false);
            case DataState.INITIAL_FETCHING:
            case DataState.MORE_FETCHING:
            case DataState.REFRESHING:
              return _RequestsForMeGridView(requestsForMe: controller.dataList, isLoading: true);
            case DataState.FETCHED:
            case DataState.ERROR:
            case DataState.NO_MORE_DATA:
              return _RequestsForMeGridView(requestsForMe: controller.dataList, isLoading: false);
          }
        });
  }
}


// ignore: must_be_immutable
class _RequestsForMeGridView extends StatelessWidget {
  _RequestsForMeGridView({Key? key, required this.requestsForMe, required this.isLoading}) : super(key: key);

  List<RequestModel> requestsForMe;
  bool isLoading;
  
  late DataState? _dataState;
  late BuildContext? _buildContext;

  @override
  Widget build(BuildContext context) {
    _dataState = Provider.of<RequestsForMeController>(context, listen: false).dataState;
    _buildContext = context;
    return _scrollNotificationWidget();
  }

  Widget _scrollNotificationWidget() {
    return Column(children: [
      Expanded(
        child: NotificationListener<ScrollNotification> (
          onNotification: _scrollNotification,
          child: RefreshIndicator(
            onRefresh:() async {
              await _onRefresh();
            },
            child: _buildRequestsForMeGridView()
          ))),
      if(_dataState == DataState.MORE_FETCHING)
          const Center(child: CircularProgressIndicator()),
    ]);
  }

  bool _scrollNotification(ScrollNotification scrollInfo) {
    if(!isLoading && 
    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      isLoading = true;
      Provider.of<RequestsForMeController>(_buildContext!, listen: false).fetchData(isRefresh: false);
    }
    return true;
  }

  Widget _buildRequestsForMeGridView() {
    return GridView.builder(
      gridDelegate: 
        const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
        childAspectRatio: 10 / 14.5, //item 의 가로 / 세로  비율
        mainAxisSpacing: 0, //수평 Padding
        crossAxisSpacing: 10, //수직 Padding
      ),
      itemCount: requestsForMe.length,
      itemBuilder: (context, index) {
          return RequestItem(request: requestsForMe[index]);
        
      },
    );
  }

  _onRefresh() async {
    if(!isLoading) {
      isLoading = true;
      Provider.of<RequestsForMeController>(_buildContext!, listen: false).fetchData(isRefresh: true);
    }
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({Key? key, this.request}) : super(key: key);

  final RequestModel? request;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _exampleImage(),
        const Space(height: 8),
        _requesterProjectInfo()
      ],
    );
  }

  Widget _exampleImage() {
    ScreenSize size = ScreenSize();
    return Image.asset(
      'assets/images/test.jpeg',
      width: size.getSize(160.0),
      height: size.getSize(160.0),
    );
  }

  Widget _requesterProjectInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productAndRequesterInfo(),
          const Space(height: 2),
          _priceInfo(),
          const Space(height: 4),
          _costRangeInfo(),
        ],
      ),
    );
  }

  _productAndRequesterInfo() {
    return Row(
      children: [
        B12Text(text: _shortenStrTo(request!.requesterProductName!, 10)),
        R12Text(text: ' | ${_shortenStrTo(request!.requesterNickName!, 5)}', textColor: grey153)
      ],
    );
  }

  _priceInfo() {
    return Row(
      children: [
        const B12Text(text: '원가 '),
        R12Text(text: request!.requesterProductCost!.toString())
      ],
    );
  }

  _costRangeInfo() {
    return CostRangeBadge(cost: request!.requesterProductCostRange);
  }

  _shortenStrTo(String str, int wantedLength) {
    if (str.length <= wantedLength) {
      return str;
    } else {
      return '${str.substring(0, wantedLength)}...'
      ;
    }
  }
}
