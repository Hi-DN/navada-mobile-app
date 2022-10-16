import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';
import 'package:navada_mobile_app/src/models/user/user_model.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/home_requests_provider.dart';
import 'package:navada_mobile_app/src/screens/home/home_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/cost_range_badge.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
        child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              _deniedVisibleCheckBox()])
          ],
        )
      );
    });
  }

  Widget _sectionTitle() {
    ScreenSize size = ScreenSize();
    User user = Provider.of<UserProvider>(_context!, listen: false).user;
    return RichText(
      text: TextSpan(children: [
          TextSpan(
          text: user.userNickname,
          style: styleB.copyWith(fontSize: size.getSize(16))),
      TextSpan(
          text: '님에게 온 교환 요청',
          style: styleR.copyWith(fontSize: size.getSize(16)))
    ]));
  }

  Widget _deniedVisibleCheckBox() {
    ScreenSize size = ScreenSize();
    return Consumer2<HomeViewModel, RequestsForMeProvider>(builder:
        (BuildContext context, HomeViewModel homeViewModel,
            RequestsForMeProvider requestsForMeProvider, Widget? _) {
      return SizedBox(
        width: size.getSize(130),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
        ]),
      );
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
      return const NoElements(text: '새로운 요청이 없네요 ㅜㅜ\n  낙담말고 기다려보세요!');
    }
  }

  Widget _requestsForMeGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 10 / 14.5, 
        mainAxisSpacing: 0, 
        crossAxisSpacing: 10,
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

// ignore: must_be_immutable
class RequestItem extends StatelessWidget {
  RequestItem({Key? key, this.request}) : super(key: key);

  final RequestModel? request;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
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
          if (request!.requestStatusCd == RequestStatusCd.DENIED)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _costRangeInfo(),
            if (request!.requestStatusCd == RequestStatusCd.DENIED)
              _deleteDeniedRequestBtn(),
          ],)
        ],
      ),
    );
  }

  _productAndRequesterInfo() {
    return Row(
      children: [
        B12Text(text: Shortener.shortenStrTo(request!.requesterProductName, 9)),
        R12Text(text: ' | ${Shortener.shortenStrTo(request!.requesterNickName!, 3)}', 
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

  _deleteDeniedRequestBtn() {
    ScreenSize size = ScreenSize();
    return PopupMenuButton(
      constraints: BoxConstraints(maxWidth: size.getSize(60)),
      padding: const EdgeInsets.all(0),
      offset: const Offset(0, -25),
      elevation: 10.0,
      position: PopupMenuPosition.over,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(size.getSize(5))),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            Provider.of<RequestsForMeProvider>(_context!, listen: false).deleteDeniedRequest(request?.requestId);
          },
          height: size.getSize(24),
          value: '삭제',
          child: SizedBox(width: size.getSize(30), child: const R14Text(text: '삭제')),
        )
      ],
      child: Icon(Icons.more_vert, size: size.getSize(18), color: Colors.grey,)
    );
  }
}