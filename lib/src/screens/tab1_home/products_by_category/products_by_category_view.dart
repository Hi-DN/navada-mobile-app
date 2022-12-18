import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/providers/products_by_category_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail.dart';
import 'package:navada_mobile_app/src/screens/tab1_home/products_by_category/products_by_category_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/cost_range_badge.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/no_elements_screen.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/status_badge.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class ProductsByCategoryView extends StatelessWidget {
  int categoryId;
  ScreenSize screenSize = ScreenSize();

  ProductsByCategoryView({Key? key, required this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: Category.idToLabel(categoryId),
        leadingYn: true,
        onTap: () => Navigator.pop(context),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ProductsByCategoryProvider()),
          ChangeNotifierProvider(
              create: (context) => ProductsByCategoryViewModel()),
        ],
        builder: (context, child) => Center(
          child: Container(
            width: screenSize.getSize(327.0),
            padding: EdgeInsets.symmetric(vertical: screenSize.getSize(15.0)),
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    ProductsByCategoryViewModel viewModel =
        Provider.of<ProductsByCategoryViewModel>(context, listen: false);
    Provider.of<ProductsByCategoryProvider>(context, listen: false)
        .fetchProducts(categoryId, viewModel);

    return Consumer<ProductsByCategoryProvider>(
        builder: (context, provider, child) {
      return provider.productsByCategory != null
          ? provider.productsByCategory!.isNotEmpty
              ? Column(
                  children: [
                    _exchangeableOnlyCheckButton(),
                    const Space(height: 8.0),
                    _optionSection(),
                    const Space(height: 8.0),
                    Expanded(child: _listSection(context)),
                  ],
                )
              : const NoElements(text: '해당 카테고리에\n등록된 물품이 없습니다.')
          : const Center(child: CircularProgressIndicator());
    });
  }

  Widget _optionSection() {
    return Consumer<ProductsByCategoryProvider>(
        builder: (context, provider, child) {
      return Row(
        children: [
          R14Text(text: '전체 ${provider.totalElements}건의 결과'),
          const Expanded(child: SizedBox()),
          _sortSelection(),
          const Space(width: 5.0),
          _costRangeSelection()
        ],
      );
    });
  }

  Widget _sortSelection() {
    return Consumer2<ProductsByCategoryProvider, ProductsByCategoryViewModel>(
        builder: (context, provider, viewModel, child) {
      return SizedBox(
        height: screenSize.getSize(35.0),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                elevation: 0.0,
                primary: const Color(0xFFEBF5CF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(33.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                R14Text(text: viewModel.sort),
                Icon(
                  Icons.arrow_drop_down,
                  size: screenSize.getSize(18.0),
                  color: Colors.black,
                ),
              ],
            )),
      );
    });
  }

  Widget _costRangeSelection() {
    ScreenSize screenSize = ScreenSize();
    return SizedBox(
        width: screenSize.getSize(35.0),
        height: screenSize.getSize(35.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: const Color(0xFFEBF5CF),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(2.0)),
          child: Icon(
            Icons.filter_list,
            size: screenSize.getSize(20.0),
            color: const Color(0xFF14142B),
          ),
        ));
  }

  Widget _exchangeableOnlyCheckButton() {
    ScreenSize screenSize = ScreenSize();
    return Consumer2<ProductsByCategoryProvider, ProductsByCategoryViewModel>(
        builder: (context, provider, viewModel, child) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
                iconSize: screenSize.getSize(18.0),
                color: grey153,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Provider.of<ProductsByCategoryViewModel>(context,
                          listen: false)
                      .toggleCheckBox();
                  provider.fetchProducts(categoryId, viewModel);
                },
                icon: Provider.of<ProductsByCategoryViewModel>(context)
                        .showOnlyExchangeable
                    ? const Icon(Icons.check_box, color: navy)
                    : const Icon(Icons.check_box_outlined)),
          ),
          const Space(width: 3.0),
          R14Text(
              text: '교환 가능한 물품만 보기',
              textColor: Provider.of<ProductsByCategoryViewModel>(context)
                      .showOnlyExchangeable
                  ? navy
                  : grey153),
          const Expanded(child: SizedBox()),
        ],
      );
    });
  }

  Widget _listSection(BuildContext context) {
    ProductsByCategoryViewModel viewModel =
        Provider.of<ProductsByCategoryViewModel>(context, listen: false);

    return Consumer<ProductsByCategoryProvider>(
        builder: (context, provider, widget) {
      return ListView.builder(
          itemBuilder: (context, index) {
            ProductSearchDtoModel product = provider.productsByCategory![index];
            return InkWell(
              child: _buildItem(context, product),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ProductDetail(
                      productId: product.productId!, like: product.like!);
                })).then((value) => Provider.of<ProductsByCategoryProvider>(
                            context,
                            listen: false)
                        .fetchProducts(categoryId, viewModel));
              },
            );
          },
          itemCount: provider.productsByCategory!.length);
    });
  }

  Widget _buildItem(BuildContext context, ProductSearchDtoModel product) {
    ScreenSize screenSize = ScreenSize();

    return Column(
      children: [
        SizedBox(
          height: screenSize.getSize(8.0),
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset(
                'assets/images/test.jpeg',
                width: screenSize.getSize(65.0),
                height: screenSize.getSize(65.0),
              ),
            ),
            SizedBox(
              width: screenSize.getSize(12.0),
            ),
            Expanded(
              child: SizedBox(
                height: screenSize.getSize(70.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: Shortener.shortenStrTo(
                                  product.productName, 10),
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          TextSpan(
                              text: Shortener.shortenStrTo(
                                  ' | ${product.userNickname}', 10),
                              style: const TextStyle(color: Colors.grey))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: '원가 ',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          TextSpan(
                              text: '${product.productCost}원',
                              style: const TextStyle(color: Colors.black))
                        ])),
                        IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              product.like!
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: screenSize.getSize(20.0),
                              color: Colors.red,
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        CostRangeBadge(cost: product.exchangeCostRange),
                        Space(width: screenSize.getSize(10.0)),
                        ExchangeStatusBadge(
                            statusCd: product.productExchangeStatusCd)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Space(height: screenSize.getSize(8.0)),
        const CustomDivider()
      ],
    );
  }
}
