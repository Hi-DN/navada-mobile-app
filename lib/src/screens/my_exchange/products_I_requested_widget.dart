import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_request_provider.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/my_exchange_card.dart';
import 'package:navada_mobile_app/src/widgets/my_exchange_status_sign.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductsThatIRequested extends StatelessWidget {
  const ProductsThatIRequested({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
      children: [
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
    ScreenSize size = ScreenSize();
    bool hasData = Provider.of<MyExchangesRequestProvider>(_context!).hasData;
    return Padding(
      padding: EdgeInsets.all(size.getSize(12)),
      child: Column(
        children: [
          _totalElementsCount(),
          hasData
            ? _requestListView()
            : const Expanded(child: NoElements(text: '신청한 내역이 없습니다.'))
        ]),
    );
  }

  Widget _requestListView() {
    ScreenSize size = ScreenSize();

    return Expanded(
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
                padding: EdgeInsets.only(right: size.getSize(20)),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [Icon(Icons.delete, color: white)])
            ),
            child: RequestItem(request: request),
          );
        },
        separatorBuilder: (context, index) {
          return const Space(height: 10);
        }),
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
    bool isWait = request?.exchangeStatusCd == ExchangeStatusCd.WAIT;

    return MyExchangeCard(
      statusSign: isWait
        ? const MyExchangeStatusSign(color: yellow, icon: Icons.access_time, label: '신청됨')
        : const MyExchangeStatusSign(color: grey216, icon: Icons.not_interested, label: '거절됨'),
      params: MyExchangeCardParams(
        requesterProductName: request?.requesterProductName,
        requesterNickname: request?.requesterNickName,
        requesterProductCost: request?.requesterProductCost,
        requesterProductCostRange: request?.requesterProductCostRange,
        acceptorProductName: request?.acceptorProductName,
        acceptorNickname: request?.acceptorNickname,
        acceptorProductCost: request?.acceptorProductCost,
        acceptorProductCostRange: request?.acceptorProductCostRange
      ),
    );
  }
}
