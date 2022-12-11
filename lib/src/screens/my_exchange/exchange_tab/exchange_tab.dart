import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_exchange_provider.dart';
import 'package:navada_mobile_app/src/screens/my_exchange/exchange_tab/exchange_detail/exchange_detail_view.dart';
import 'package:navada_mobile_app/src/screens/my_exchange/my_exchanges_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../widgets/my_exchange_card.dart';
import '../widgets/my_exchange_status_sign.dart';

// ignore: must_be_immutable
class ExchangeTab extends StatelessWidget {
  const ExchangeTab({Key? key}) : super(key: key);

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
    return Consumer<MyExchangesExchangeProvider>(builder:
        (BuildContext context, MyExchangesExchangeProvider provider, Widget? _) {
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

// ignore: must_be_immutable
class _ExchangeListView extends StatelessWidget {
  _ExchangeListView({Key? key, required this.exchangeList, required this.isLoading}) : super(key: key);

  List<ExchangeDtoModel> exchangeList;
  bool isLoading;

  late DataState? _dataState;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _dataState = Provider.of<MyExchangesExchangeProvider>(context, listen: false).dataState;
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
      Provider.of<MyExchangesExchangeProvider>(_context!, listen: false).fetchData(isRefresh: false);
    }
    return true;
  }

  Widget _buildScreenIfHasData() {
    ScreenSize size = ScreenSize();
    bool hasData = Provider.of<MyExchangesExchangeProvider>(_context!).hasData;

    return Padding(
      padding: EdgeInsets.all(size.getSize(12)),
      child: Column(
        children: [
          _filterSection(),
          hasData
            ? _exchangeListView()
            : const Expanded(child: NoElements(text: '물물교환내역이 없습니다.'))
        ]),
    );
  }

  Widget _exchangeListView() {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: exchangeList.length,
        itemBuilder: (context, index) {
          ExchangeDtoModel exchange = exchangeList[index];
          bool isTrading = (exchange.exchangeStatusCd == ExchangeStatusCd.TRADING);

          return (isTrading)
            ? _tappableTradingExchangeItem(context, exchange)
            : _dismissibleCompletedExchangeItem(context, exchange);
        },
        separatorBuilder: (context, index) {
          return const Space(height: 10);
        }),
    );
  }

  Widget _tappableTradingExchangeItem(BuildContext? context, ExchangeDtoModel? exchange) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context!,
              MaterialPageRoute(builder: (BuildContext context) => ExchangeDetailView(exchange: exchange)));
        },
        child: ExchangeItem(exchange: exchange),
    );
  }

  Widget _dismissibleCompletedExchangeItem(BuildContext? context, ExchangeDtoModel? exchange) {
    ScreenSize size = ScreenSize();

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        Provider.of<MyExchangesExchangeProvider>(_context!, listen: false).deleteCompletedExchange(exchange!.exchangeId, exchange.acceptorId);
      },
      confirmDismiss: (direction) async {
          return await showDialog(
            context: context!,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const R14Text(text: "교환내역을 삭제하시겠습니까?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const R14Text(text: "아니요", textColor: grey153),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const R14Text(text: "네, 삭제할게요!", textColor: blue),
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
      child: _tappableTradingExchangeItem(context, exchange),
    );
  }

  Widget _filterSection() {
    int totalElements = Provider.of<MyExchangesExchangeProvider>(_context!).totalElements;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [R10Text(text: "총 $totalElements건"), _ViewFilter()]),
        const Space(height: 10)
      ],
    );
  }

  _onRefresh() async {
    if (!isLoading) {
      isLoading = true;
      Provider.of<MyExchangesExchangeProvider>(_context!, listen: false).fetchData(isRefresh: true);
    }
  }
}

class ExchangeItem extends StatelessWidget {
  const ExchangeItem({Key? key, this.exchange}) : super(key: key);

  final ExchangeDtoModel? exchange;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    bool isTrading = (exchange?.exchangeStatusCd == ExchangeStatusCd.TRADING);
    ProductModel? requesterProduct = exchange?.requesterProduct;
    ProductModel? acceptorProduct = exchange?.acceptorProduct;

    return MyExchangeCard(
      statusSign: isTrading
        ? const MyExchangeStatusSign(color: green, icon: Icons.compare_arrows, label: '교환중')
        : const MyExchangeStatusSign(color: navy, icon: Icons.check, label: '교환완료'),
      params: MyExchangeCardParams(
        requesterProductName: requesterProduct?.productName,
        requesterNickname: Row(children: [
                  B10Text(text: "신청 ", textColor: isTrading ? green : navy),
                  SizedBox(
                    width: size.getSize(66),
                    child: R10Text(text: requesterProduct?.userNickname, textColor: grey183)),]),
        requesterProductCost: requesterProduct?.productCost,
        requesterProductCostRange: requesterProduct?.exchangeCostRange,
        acceptorProductName: acceptorProduct?.productName,
        acceptorNickname: Row(children: [
                  B10Text(text: "수락 ", textColor: isTrading ? green : navy),
                  SizedBox(
                    width: size.getSize(66),
                    child: R10Text(text: acceptorProduct?.userNickname, textColor: grey183)),]),
        acceptorProductCost: acceptorProduct?.productCost,
        acceptorProductCostRange: acceptorProduct?.exchangeCostRange
      ),
    );
  }
}

// ignore: must_be_immutable
class _ViewFilter extends StatelessWidget {

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    ScreenSize size = ScreenSize();
    MyExchangesFilterItem curFilter = Provider.of<MyExchangesViewModel>(_context!).curFilter;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size.getSize(15)), 
              topRight: Radius.circular(size.getSize(15))),
          ),
          builder: (context) {
            return _viewSelectionModal();
          },
        );
      },
      child: Row(
        children: [
          Icon(Icons.check, size: size.getSize(10)),
          const Space(width: 3),
          R10Text(text: curFilter.label),
        ],
      ),
    );
  }

  Widget _viewSelectionModal() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Wrap(
        children: [
          _greyStick(),
          _customListTile(MyExchangesFilterItem.viewAll),
          const CustomDivider(horizontalIndent: 18),
          _customListTile(MyExchangesFilterItem.viewOnlyISent),
          const CustomDivider(horizontalIndent: 18),
          _customListTile(MyExchangesFilterItem.viewOnlyIGot)
        ],
      ),
    );
  }

  Widget _greyStick() {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 3,
            width: size.getSize(40),
            decoration: BoxDecoration(
              color: grey216,
              borderRadius: BorderRadius.circular(size.getSize(10)),
              border: Border.all(color: Colors.white, width: 3.0),
              ))
      ]),
    );
  }

  Widget _customListTile(MyExchangesFilterItem? selectedFilter) {
    ScreenSize size = ScreenSize();
    return GestureDetector(
      onTap: () async {
        Provider.of<MyExchangesViewModel>(_context!, listen: false).setFilter(selectedFilter!);
        Provider.of<MyExchangesExchangeProvider>(_context!, listen: false).setFilter(selectedFilter);
        Navigator.of(_context!).pop(false);
      },
      child: ListTile(
        minVerticalPadding: size.getSize(20),
        title: R16Text(text: selectedFilter?.label),
      ),
    );
  }
}