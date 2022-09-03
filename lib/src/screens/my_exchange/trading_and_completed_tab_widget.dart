import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_model.dart';
import 'package:navada_mobile_app/src/providers/exchange_provider.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class TradingAndCompletedTab extends StatelessWidget {
  TradingAndCompletedTab({Key? key}) : super(key: key);

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Column(
      children: [
        // _filterSection(),
        Expanded(child: _buildScreenDependingOnDataState()),
      ],
    ));
  }

  Widget _buildScreenDependingOnDataState() {
    return Consumer<ExchangeProvider>(builder:
        (BuildContext context, ExchangeProvider provider, Widget? _) {
      switch (provider.dataState) {
        case DataState.UNINITIALIZED:
          Future(() {
            provider.fetchData();
          });
          return _ExchangeListView(exchangeList: provider.exchangeDataList, isLoading: false);
        case DataState.INITIAL_FETCHING:
        case DataState.MORE_FETCHING:
        case DataState.REFRESHING:
          return _ExchangeListView(exchangeList: provider.exchangeDataList, isLoading: true);
        case DataState.FETCHED:
        case DataState.ERROR:
        case DataState.NO_MORE_DATA:
          return _ExchangeListView(exchangeList: provider.exchangeDataList, isLoading: false);
      }
    });
  }
}

class _ExchangeListView extends StatelessWidget {
  _ExchangeListView({Key? key, required this.exchangeList, required this.isLoading}) : super(key: key);

  List<ExchangeModel> exchangeList;
  bool isLoading;

  late DataState? _dataState;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _dataState =
        Provider.of<ExchangeProvider>(context, listen: false).dataState;
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
      Provider.of<ExchangeProvider>(_context!, listen: false)
          .fetchData(isRefresh: false);
    }
    return true;
  }

  Widget _buildScreenIfHasData() {
    bool hasData = Provider.of<ExchangeProvider>(_context!).hasData;

    if (hasData) {
      return _exchangeListView();
    } else {
      return const NoExchanges();
    }
  }

  Widget _exchangeListView() {
    return ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exchangeList.length,
              itemBuilder: (context, index) {
                return ExchangeItem(exchange: exchangeList[index]);
              },
              // separatorBuilder: (context, index) {
              //   return Divider(thickness: 1.0);
              // }
      );
    // return ListView.builder(
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
    //     childAspectRatio: 10 / 14.5, //item 의 가로 / 세로  비율
    //     mainAxisSpacing: 0, //수평 Padding
    //     crossAxisSpacing: 10, //수직 Padding
    //   ),
    //   itemCount: requestsForMe.length,
    //   itemBuilder: (context, index) {
    //     return RequestItem(request: requestsForMe[index]);
    //   },
    // );
  }

  _onRefresh() async {
    if (!isLoading) {
      isLoading = true;
      Provider.of<ExchangeProvider>(_context!, listen: false)
          .fetchData(isRefresh: true);
    }
  }
}

class ExchangeItem extends StatelessWidget {
  const ExchangeItem({Key? key, this.exchange}) : super(key: key);

  final ExchangeModel? exchange;

  @override
  Widget build(BuildContext context) {
    return Text(exchange?.acceptorProduct!.productName?? "wow");
  }
}

class NoExchanges extends StatelessWidget {
  const NoExchanges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraint) => 
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
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
        text: '물물교환내역이 없습니다.',
        textColor: grey153,
      ),
      const Space(height: kBottomNavigationBarHeight)
    ]);
  }
}
