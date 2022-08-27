import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/home_requests_provider.dart';
import 'package:navada_mobile_app/src/screens/home/home_no_requests_widget.dart';
import 'package:navada_mobile_app/src/screens/home/home_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/cost_range_badge.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/status_badge.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RequestsForMe extends StatelessWidget {
  RequestsForMe({Key? key}) : super(key: key);

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        body: Column(
      children: [
        _titleSection(),
        Expanded(child: _buildScreenDependingOnDataState()),
      ],
    ));
  }

  Widget _titleSection() {
    ScreenSize size = ScreenSize();
    return Consumer<RequestsForMeProvider>(builder:
        (BuildContext context, RequestsForMeProvider provider, Widget? _) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.getSize(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_sectionTitle(), _deniedVisibleCheckBox()],
        ),
      );
    });
  }

  Widget _sectionTitle() {
    User user = Provider.of<UserProvider>(_context!, listen: false).user;
    return Row(
      children: [
        B16Text(text: user.userNickname),
        const R16Text(text: '님에게 온 교환 요청'),
      ],
    );
  }

  Widget _deniedVisibleCheckBox() {
    return Consumer2<HomeViewModel, RequestsForMeProvider>(builder:
        (BuildContext context, HomeViewModel homeViewModel,
            RequestsForMeProvider requestsForMeProvider, Widget? _) {
      return Row(children: [
        Checkbox(
            visualDensity:
                const VisualDensity(horizontal: -3.0, vertical: -4.0),
            value: homeViewModel.isDeniedVisible,
            side: const BorderSide(color: grey183),
            activeColor: grey183,
            onChanged: (value) {
              homeViewModel.setDeniedVisible(value!);
              requestsForMeProvider.fetchDependingOnDeniedCheck(value);
            }),
        const R12Text(
          text: '거절한 요청도 보기',
          textColor: grey183,
        )
      ]);
    });
  }

  Widget _buildScreenDependingOnDataState() {
    return Consumer<RequestsForMeProvider>(builder:
        (BuildContext context, RequestsForMeProvider provider, Widget? _) {
      switch (provider.dataState) {
        case DataState.UNINITIALIZED:
          Future(() {
            provider.fetchData();
          });
          return _RequestsForMeGridView(
              requestsForMe: provider.requestDataList, isLoading: false);
        case DataState.INITIAL_FETCHING:
        case DataState.MORE_FETCHING:
        case DataState.REFRESHING:
          return _RequestsForMeGridView(
              requestsForMe: provider.requestDataList, isLoading: true);
        case DataState.FETCHED:
        case DataState.ERROR:
        case DataState.NO_MORE_DATA:
          return _RequestsForMeGridView(
              requestsForMe: provider.requestDataList, isLoading: false);
      }
    });
  }
}

// ignore: must_be_immutable
class _RequestsForMeGridView extends StatelessWidget {
  _RequestsForMeGridView(
      {Key? key, required this.requestsForMe, required this.isLoading})
      : super(key: key);

  List<RequestModel> requestsForMe;
  bool isLoading;

  late DataState? _dataState;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _dataState =
        Provider.of<RequestsForMeProvider>(context, listen: false).dataState;
    _context = context;
    return _scrollNotificationWidget();
  }

  Widget _scrollNotificationWidget() {
    ScreenSize size = ScreenSize();
    return Column(children: [
      Expanded(
          child: NotificationListener<ScrollNotification>(
              onNotification: _scrollNotification,
              child: RefreshIndicator(
                  color: green,
                  displacement: size.getSize(22),
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: _buildScreenIfHasData()))),
      if (_dataState == DataState.MORE_FETCHING)
        const Center(child: CircularProgressIndicator()),
    ]);
  }

  bool _scrollNotification(ScrollNotification scrollInfo) {
    if (!isLoading &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      isLoading = true;
      Provider.of<RequestsForMeProvider>(_context!, listen: false)
          .fetchData(isRefresh: false);
    }
    return true;
  }

  Widget _buildScreenIfHasData() {
    bool hasData = Provider.of<RequestsForMeProvider>(_context!).hasData;

    if (hasData) {
      return _requestsForMeGridView();
    } else {
      return const NoRequests();
    }
  }

  Widget _requestsForMeGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    if (!isLoading) {
      isLoading = true;
      Provider.of<RequestsForMeProvider>(_context!, listen: false)
          .fetchData(isRefresh: true);
    }
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({Key? key, this.request}) : super(key: key);

  final RequestModel? request;

  @override
  Widget build(BuildContext context) {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(size.getSize(5)),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/test.jpeg',
            width: size.getSize(160.0),
            height: size.getSize(160.0),
          ),
          if (request!.exchangeStatusCd == ExchangeStatusCd.DENIED)
            _blackTransparentFilter()
        ],
      ),
    );
  }

  Widget _blackTransparentFilter() {
    ScreenSize size = ScreenSize();
    return Container(
        width: size.getSize(160.0),
        height: size.getSize(160.0),
        color: const Color.fromRGBO(0, 0, 0, 0.5),
        child: const Center(
            child: StatusBadge(
          label: '거절됨',
          backgroundColor: grey153,
        )));
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
        R12Text(
            text: ' | ${_shortenStrTo(request!.requesterNickName!, 5)}',
            textColor: grey153)
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
      return '${str.substring(0, wantedLength)}...';
    }
  }
}
