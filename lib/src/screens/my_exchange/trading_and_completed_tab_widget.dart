import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/providers/my_exchanges_exchange_provider.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TradingAndCompletedTab extends StatelessWidget {
  TradingAndCompletedTab({Key? key}) : super(key: key);

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
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

  List<ExchangeModel> exchangeList;
  bool isLoading;

  late DataState? _dataState;
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _dataState =
        Provider.of<MyExchangesExchangeProvider>(context, listen: false).dataState;
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
      Provider.of<MyExchangesExchangeProvider>(_context!, listen: false)
          .fetchData(isRefresh: false);
    }
    return true;
  }

  Widget _buildScreenIfHasData() {
    bool hasData = Provider.of<MyExchangesExchangeProvider>(_context!).hasData;

    if (hasData) {
      return _exchangeListView();
    } else {
      return const NoExchanges();
    }
  }

  Widget _exchangeListView() {
    ScreenSize size = ScreenSize();

    return Padding(
      padding: EdgeInsets.all(size.getSize(12)),
      child: Column(
        children: [
          _filterSection(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: exchangeList.length,
              itemBuilder: (context, index) {
                return ExchangeItem(exchange: exchangeList[index]);
              },
              separatorBuilder: (context, index) {
                return const Space(height: 10);
              }),
          ),
        ],
      )
    );
  }

  Widget _filterSection() {
    int totalElements = Provider.of<MyExchangesExchangeProvider>(_context!).totalElements;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [R10Text(text: "총 $totalElements건"), _filter()]),
        const Space(height: 10)
      ],
    );
  }

  Widget _filter() {
    ScreenSize size = ScreenSize();
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: _context!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(size.getSize(15)), topRight: Radius.circular(size.getSize(15))),
          ),
          builder: (context) {
            return Wrap(
              children: [
                Padding(
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
                ),
                ListTile(
                  minVerticalPadding: size.getSize(20),
                  title: const R16Text(text:'전체보기'),
                ),
                const CustomDivider(horizontalIndent: 18),
                ListTile(
                  minVerticalPadding: size.getSize(20),
                  title: const R16Text(text: '내가 신청한것만 보기'),
                ),
                const CustomDivider(horizontalIndent: 18),
                ListTile(
                  minVerticalPadding: size.getSize(20),
                  title: const R16Text(text: '신청받은것만 보기'),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          Icon(Icons.check, size: size.getSize(10)),
          const Space(width: 3),
          const R10Text(
            text: '전체보기',
          ),
        ],
      ),
    );
  }

  _onRefresh() async {
    if (!isLoading) {
      isLoading = true;
      Provider.of<MyExchangesExchangeProvider>(_context!, listen: false)
          .fetchData(isRefresh: true);
    }
  }
}

class ExchangeItem extends StatelessWidget {
  const ExchangeItem({Key? key, this.exchange}) : super(key: key);

  final ExchangeModel? exchange;

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
          _exchangeStatusSign(exchange?.acceptorProduct!.productStatusCd),
          const VerticalDivider(thickness: 1, color: grey239, indent: 0, endIndent: 0),
          _productContent(exchange?.requesterProduct),
          const VerticalDivider(thickness: 1, color: grey239, indent: 3, endIndent: 3),
          _productContent(exchange?.acceptorProduct),
        ],
      )
    );
  }

  Widget _exchangeStatusSign(ProductStatusCd? statusCd) {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.only(left: size.getSize(7)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          statusCd == ProductStatusCd.TRADING
            ? const Icon(Icons.compare_arrows, color: green, size: 32)
            : const Icon(Icons.check, color: navy, size: 28),
          const Space(height: 5),
          statusCd == ProductStatusCd.TRADING
            ? const R10Text(text: '교환중', textColor: green)
            : const R10Text(text: '교환완료', textColor: navy)
        ]
      ),
    );
  }

  Widget _productContent(ProductModel? product) {
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
              R12Text(text: _shortenStrTo(product!.productName, 8)),
              R10Text(text: _shortenStrTo(product.userNickname,10), textColor: grey216),
              R10Text(text: "원가 ${product.productCost}원"),
              R10Text(text: "± ${product.exchangeCostRange}원", textColor: grey183,)
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

class NoExchanges extends StatelessWidget {
  const NoExchanges({Key? key}) : super(key: key);

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
    return IntrinsicWidth(
      child: Column(
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
      ]),
    );
  }
}
