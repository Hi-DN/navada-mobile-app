import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/star_rating.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../../models/exchange/exchange_dto_model.dart';
import '../../models/product/product_model.dart';
import '../../providers/exchange_history_provider.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/space.dart';
import '../my_exchange/exchange_tab/exchange_detail/exchange_detail_view.dart';

class ExchangeHistoryView extends StatelessWidget {
  const ExchangeHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = ScreenSize();

    return Scaffold(
      appBar: CustomAppBar(
        titleText: '교환 내역',
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => ExchangeHistoryProvider())
          ],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: screenSize.getSize(20.0),
                vertical: screenSize.getSize(10.0),
              ),
              child: _buildBody(context),
            );
          }),
    );
  }

  Widget _buildBody(BuildContext context) {
    Provider.of<ExchangeHistoryProvider>(context, listen: false)
        .fetchExchangeHistory(UserProvider.userId);

    return Consumer<ExchangeHistoryProvider>(
        builder: (context, provider, widget) {
      if (provider.exchangeDtoPageResponse != null) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _numOfElements(provider.totalElements!),
                _topInfoSection(),
              ],
            ),
            const Space(height: 8.0),
            Expanded(
              child: _buildListView(provider.exchangeHistoryList!),
            )
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _buildListView(List<ExchangeDtoModel> exchangeHistoryList) {
    return exchangeHistoryList.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            itemCount: exchangeHistoryList.length,
            itemBuilder: (context, index) {
              ExchangeDtoModel exchange = exchangeHistoryList[index];
              return _buildItem(context, exchange);
            },
            separatorBuilder: (context, index) {
              return const Space(height: 10);
            })
        : const NoElements(text: '교환 완료 내역이 존재하지 않습니다.');
  }

  Widget _buildItem(BuildContext context, ExchangeDtoModel exchange) {
    ScreenSize screenSize = ScreenSize();
    bool isAcceptor = exchange.acceptorId == UserProvider.userId;

    ProductModel myProduct =
        isAcceptor ? exchange.acceptorProduct! : exchange.requesterProduct!;
    ProductModel otherProduct =
        isAcceptor ? exchange.requesterProduct! : exchange.acceptorProduct!;

    double myRating =
        isAcceptor ? exchange.acceptorRating! : exchange.requesterRating!;
    double otherRating =
        isAcceptor ? exchange.requesterRating! : exchange.acceptorRating!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ExchangeDetailView(exchange: exchange)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenSize.getSize(5.0)),
          border: Border.all(color: Colors.white, width: 3.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x90979797),
              offset: Offset(3.0, 3.0), //(x,y)
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Space(height: 5.0),
            _exchangeCompletedDt(
                '교환완료일시 ${DateFormat('yyyy.MM.dd').format(exchange.exchangeCompleteDt!)}'),
            const Space(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _exchangedProductInfo(myProduct, myRating, true),
                Container(
                    width: 1.0,
                    height: screenSize.getSize(70.0),
                    color: const Color(0xFFEFEFEF)),
                _exchangedProductInfo(otherProduct, otherRating, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exchangedProductInfo(
      ProductModel product, double rating, bool isMyProduct) {
    ScreenSize screenSize = ScreenSize();
    bool isRated = rating != -1;

    return SizedBox(
      width: screenSize.getSize(150.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: screenSize.getSize(50.0),
                height: screenSize.getSize(55.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/test.jpeg')),
                ),
              ),
              const Space(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenSize.getSize(90.0),
                    child: B12Text(
                        text: product.productName,
                        params:
                            const TextParams(overflow: TextOverflow.ellipsis)),
                  ),
                  isMyProduct
                      ? Container()
                      : R8Text(text: product.userNickname, textColor: grey153),
                  R10Text(text: "원가 ${product.productCost}원"),
                  R10Text(
                    text: "± ${product.exchangeCostRange}원",
                    textColor: grey183,
                  )
                ],
              )
            ],
          ),
          SizedBox(
              height: 25.0,
              child: isRated ? _ratedInfo(rating) : _notRatedInfo())
        ],
      ),
    );
  }

  Widget _numOfElements(int cnt) {
    return B14Text(
      text: '총 $cnt건',
      textColor: const Color(0xFF737373),
    );
  }

  Widget _topInfoSection() {
    ScreenSize screenSize = ScreenSize();

    return Row(
      children: [
        Icon(
          Icons.info,
          size: screenSize.getSize(15.0),
          color: grey153,
        ),
        const R12Text(
          text: '교환이 완료된 내역들만 확인 가능합니다.',
          textColor: grey153,
        ),
      ],
    );
  }

  Widget _exchangeCompletedDt(String completedDt) {
    return B10Text(
      text: completedDt,
      textColor: const Color(0xFFC4C4C4),
    );
  }

  Widget _ratedInfo(double rating) {
    return Row(
      children: [
        StarRating(rating: rating),
        B10Text(text: rating.toString(), textColor: grey153)
      ],
    );
  }

  Widget _notRatedInfo() {
    return Container(
      alignment: Alignment.centerLeft,
      child: const R10Text(
        text: '별점을 입력하지 않았습니다.',
        textColor: Color(0xFFC4C4C4),
      ),
    );
  }
}
