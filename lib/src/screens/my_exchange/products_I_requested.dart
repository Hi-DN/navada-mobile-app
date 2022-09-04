import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_request_provider.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductsThatIRequested extends StatelessWidget {
  ProductsThatIRequested({Key? key}) : super(key: key);

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: white,
      body: Column(
      children: [
        // _filterSection(),
        Expanded(child: _buildScreenDependingOnDataState()),
      ],
    ));
  }

  Widget _buildScreenDependingOnDataState() {
    return Consumer<MyExchangesRequestProvider>(builder:
        (BuildContext context, MyExchangesRequestProvider provider, Widget? _) {
      switch (provider.dataState) {
        case DataState.UNINITIALIZED:
          Future(() {
            provider.fetchData();
          });
          return _RequestListView(requestList: provider.requestDataList, isLoading: false);
        case DataState.INITIAL_FETCHING:
        case DataState.MORE_FETCHING:
        case DataState.REFRESHING:
          return _RequestListView(requestList: provider.requestDataList, isLoading: true);
        case DataState.FETCHED:
        case DataState.ERROR:
        case DataState.NO_MORE_DATA:
          return _RequestListView(requestList: provider.requestDataList, isLoading: false);
      }
    });
  }
}

// ignore: must_be_immutable
class _RequestListView extends StatelessWidget {
  _RequestListView({Key? key, required this.requestList, required this.isLoading}) : super(key: key);

  List<RequestModel> requestList;
  bool isLoading;

  late DataState? _dataState;
  late BuildContext? _context;


  @override
  Widget build(BuildContext context) {
    _dataState =
        Provider.of<MyExchangesRequestProvider>(context, listen: false).dataState;
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
      Provider.of<MyExchangesRequestProvider>(_context!, listen: false)
          .fetchData(isRefresh: false);
    }
    return true;
  }

  Widget _buildScreenIfHasData() {
    bool hasData = Provider.of<MyExchangesRequestProvider>(_context!).hasData;

    if (hasData) {
      return _requestListView();
    } else {
      return const NoRequestsThatIApplied();
    }
  }

  Widget _requestListView() {
    ScreenSize size = ScreenSize();

    return Padding(
      padding: EdgeInsets.all(size.getSize(12)),
      child: Column(
        children: [
          _totalElementsCount(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: requestList.length,
              itemBuilder: (context, index) {
                final request = requestList[index];
                bool isWait = request.exchangeStatusCd == ExchangeStatusCd.WAIT;
          
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if(isWait) {
                      Provider.of<MyExchangesRequestProvider>(_context!, listen: false).deleteRequest(request.requestId!);
                    }
                  },
                  confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: R14Text(text: isWait ? "교환신청을 정말로 취소하시겠습니까?" : "거절내역을 삭제하시겠습니까?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const R14Text(text: "아니요", textColor: grey153),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: R14Text(text: isWait ? "네, 취소할게요!" : "네, 삭제할게요!", textColor: blue),
                              ),
                            ],
                          );
                        }
                      );
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                      decoration: BoxDecoration(
                          color: grey183,
                          borderRadius: BorderRadius.circular(size.getSize(10))),
                      margin: EdgeInsets.only(bottom: size.getSize(8)),
                      padding: EdgeInsets.only(right: size.getSize(20)),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(Icons.delete, color: white,),
                      ],
                    )
                  ),
                  child: RequestItem(request: request),
                );
              },
              separatorBuilder: (context, index) {
                return const Space(height: 10);
              }),
          ),
        ],
      )
    );
  }

  Widget _totalElementsCount() {
    int totalElements = Provider.of<MyExchangesRequestProvider>(_context!).totalElements;
    return Column(
      children: [
        Row(children: [R10Text(text: "총 $totalElements건")]),
        const Space(height: 10)
      ],
    );
  }

  _onRefresh() async {
    if (!isLoading) {
      isLoading = true;
      Provider.of<MyExchangesRequestProvider>(_context!, listen: false)
          .fetchData(isRefresh: true);
    }
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({Key? key, this.request}) : super(key: key);

  final RequestModel? request;

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
          _requestStatusSign(),
          const VerticalDivider(thickness: 1, color: grey239, indent: 0, endIndent: 0),
          _productContent(request?.requesterProductName, request?.requesterNickName, request?.requesterProductCost, request?.requesterProductCostRange),
          const VerticalDivider(thickness: 1, color: grey239, indent: 3, endIndent: 3),
          _productContent(request?.acceptorProductName, request?.acceptorNickname, request?.acceptorProductCost, request?.acceptorProductCostRange),
        ],
      )
    );
  }

  Widget _requestStatusSign() {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.only(left: size.getSize(7)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          request?.exchangeStatusCd == ExchangeStatusCd.WAIT
            ? const Icon(Icons.access_time, color: yellow, size: 32)
            : const Icon(Icons.not_interested, color: grey216, size: 28),
          const Space(height: 5),
          request?.exchangeStatusCd == ExchangeStatusCd.WAIT
            ? const R10Text(text: '신청됨', textColor: yellow)
            : const R10Text(text: '거절됨', textColor: grey216)
        ]
      ),
    );
  }

  Widget _productContent(String? productName, String? userNickname, int? productCost, int? exchangeCostRange) {
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
              R12Text(text: _shortenStrTo(productName, 8)),
              R10Text(text: _shortenStrTo(userNickname,10), textColor: grey216),
              R10Text(text: "원가 $productCost원"),
              R10Text(text: "± $exchangeCostRange원", textColor: grey183,)
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

  _shortenStrTo(String? str, int wantedLength) {
    if (str!.length <= wantedLength) {
      return str;
    } else {
      return '${str.substring(0, wantedLength)}...';
    }
  }
}

class NoRequestsThatIApplied extends StatelessWidget {
  const NoRequestsThatIApplied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraint) => 
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight, minWidth: double.infinity),
              child: IntrinsicHeight(
                child: _noExchangesNotice()
              ),
            ),
          )
      )
    );
  }

  Widget _noExchangesNotice() {
    ScreenSize size = ScreenSize();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Icon(
        Icons.tag_faces_sharp,
        size: size.getSize(96),
        color: grey216,
      ),
      const Space(height: 10),
      const R14Text(
        text: '신청한 내역이 없습니다.',
        textColor: grey153,
      ),
      const Space(height: kBottomNavigationBarHeight)
    ]);
  }
}
