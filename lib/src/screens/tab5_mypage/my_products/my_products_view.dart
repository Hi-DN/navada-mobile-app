import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/providers/my_products_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/status_badge.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class MyProductsView extends StatelessWidget {
  const MyProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<MyProductsProvider>(context, listen: false).loadMore(false);
    return Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(
            titleText: "내 물품 목록",
            leadingYn: true,
            onTap: () => Navigator.pop(context)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Space(height: 12),
            _FilterSelection(),
            const Space(height: 2),
            Expanded(child: _ProductList()),
          ],
        ));
  }
}

class _FilterSelection extends StatelessWidget {
  _FilterSelection();

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    ScreenSize size = ScreenSize();
    MyProductsFilter curFilter =
        Provider.of<MyProductsProvider>(_context).curFilter;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(10)),
      child: Row(children: [
        _AllStatusBadge(curFilter),
        const Space(width: 7),
        _WaitStatusBadge(curFilter),
        const Space(width: 7),
        _TradingStatusBadge(curFilter),
        const Space(width: 7),
        _CompletedStatusBadge(curFilter),
      ]),
    );
  }
}

class _ProductList extends StatelessWidget {
  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    ScreenSize size = ScreenSize();
    List<ProductModel> products =
        Provider.of<MyProductsProvider>(_context!).products;
    return products.isNotEmpty
        ? NotificationListener<ScrollNotification>(
            onNotification: _scrollNotification,
            child: RefreshIndicator(
              color: green,
              displacement: size.getSize(22),
              onRefresh: () async {
                Provider.of<MyProductsProvider>(_context!, listen: false)
                    .loadMore(true);
              },
              child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: size.getSize(16)),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _productTile(context, products[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const CustomDivider();
                  }),
            ))
        : const NoElements(text: "등록한 물품이 없습니다.");
  }

  bool _scrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.atEdge && scrollInfo.metrics.pixels != 0) {
      Provider.of<MyProductsProvider>(_context!, listen: false).loadMore(false);
    }
    return true;
  }

  Widget _productTile(BuildContext context, ProductModel product) {
    ScreenSize size = ScreenSize();
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetail(productId: product.productId!))).then(
            (value) => Provider.of<MyProductsProvider>(context, listen: false)
                .loadMore(true));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.getSize(15)),
        height: size.getSize(70.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _exampleImage(),
            const Space(width: 15),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    B14Text(
                        text: Shortener.shortenStrTo(product.productName!, 12)),
                    const Space(width: 10),
                    _productStatusBadge(product.productExchangeStatusCd!)
                  ]),
                  Row(children: [
                    const B14Text(text: '원가 '),
                    R14Text(text: product.productCost!.toString())
                  ]),
                  Row(children: [
                    const B14Text(text: '희망가격 '),
                    R14Text(
                        text:
                            "${product.productCost! - product.exchangeCostRange!} ~ ${product.productCost! + product.exchangeCostRange!}")
                  ])
                ])
          ],
        ),
      ),
    );
  }

  Widget _productStatusBadge(ProductExchangeStatusCd statusCd) {
    switch (statusCd) {
      case ProductExchangeStatusCd.REGISTERED:
        return Container();
      case ProductExchangeStatusCd.TRADING:
        return _TradingStatusBadge(MyProductsFilter.showTrading);
      case ProductExchangeStatusCd.COMPLETED:
        return _CompletedStatusBadge(MyProductsFilter.showCompleted);
    }
  }

  Widget _exampleImage() {
    ScreenSize size = ScreenSize();
    return ClipRRect(
        borderRadius: BorderRadius.circular(size.getSize(5)),
        child: Image.asset(
          'assets/images/test.jpeg',
          width: size.getSize(70.0),
          height: size.getSize(70.0),
        ));
  }
}

class _AllStatusBadge extends StatelessWidget {
  _AllStatusBadge(this.selectedFilter);

  MyProductsFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    bool isSelected = (selectedFilter == MyProductsFilter.showAll);

    return StatusBadge(
        label: "전체",
        labelColor: isSelected ? white : grey183,
        backgroundColor: isSelected ? grey183 : white,
        borderColor: grey183,
        onTap: (() => Provider.of<MyProductsProvider>(context, listen: false)
            .setCurFilter(MyProductsFilter.showAll)));
  }
}

class _WaitStatusBadge extends StatelessWidget {
  _WaitStatusBadge(this.selectedFilter);

  MyProductsFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    bool isSelected = (selectedFilter == MyProductsFilter.showWait);

    return StatusBadge(
        label: "등록",
        labelColor: isSelected ? white : yellow,
        backgroundColor: isSelected ? yellow : white,
        borderColor: yellow,
        onTap: (() => Provider.of<MyProductsProvider>(context, listen: false)
            .setCurFilter(MyProductsFilter.showWait)));
  }
}

class _TradingStatusBadge extends StatelessWidget {
  _TradingStatusBadge(this.selectedFilter);

  MyProductsFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    bool isSelected = (selectedFilter == MyProductsFilter.showTrading);

    return StatusBadge(
        label: "교환중",
        labelColor: isSelected ? white : green,
        backgroundColor: isSelected ? green : white,
        borderColor: green,
        onTap: (() => Provider.of<MyProductsProvider>(context, listen: false)
            .setCurFilter(MyProductsFilter.showTrading)));
  }
}

class _CompletedStatusBadge extends StatelessWidget {
  _CompletedStatusBadge(this.selectedFilter);

  MyProductsFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    bool isSelected = (selectedFilter == MyProductsFilter.showCompleted);

    return StatusBadge(
        label: "교환완료",
        labelColor: isSelected ? white : navy,
        backgroundColor: isSelected ? navy : white,
        borderColor: navy,
        onTap: (() => Provider.of<MyProductsProvider>(context, listen: false)
            .setCurFilter(MyProductsFilter.showCompleted)));
  }
}
