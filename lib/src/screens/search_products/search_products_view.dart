import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/user/user_provider.dart';
import 'package:navada_mobile_app/src/providers/search_products_provider.dart';
import 'package:navada_mobile_app/src/screens/search_products/search_products_view_model.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_search_page_model.dart';
import '../../widgets/colors.dart';
import '../../widgets/divider.dart';

class SearchProductsView extends StatelessWidget {
  SearchProductsView({Key? key}) : super(key: key);
  ScreenSize screenSize = ScreenSize();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: screenSize.getSize(330.0),
        padding: EdgeInsets.only(top: screenSize.getSize(5.0)),
        child: Column(
          children: [
            Flexible(flex: 2, child: _buildSearchField()),
            Flexible(flex: 3, child: _buildOptionSection()),
            Flexible(flex: 15, child: _buildListSection(context))
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Center(
        child: Container(
            height: screenSize.getSize(40.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
                width: screenSize.getSize(2.0),
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                Space(width: screenSize.getSize(8.0)),
                Icon(
                  Icons.search,
                  size: screenSize.getSize(25.0),
                  color: Colors.black12,
                ),
                Expanded(
                  child: Container(),
                )
              ],
            )));
  }

  Widget _buildOptionSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _totalElementsText(),
              const Expanded(child: SizedBox()),
              _sortSelection(),
              Space(width: screenSize.getSize(5.0)),
              _categorySelection(),
              Space(width: screenSize.getSize(5.0)),
              _costRangeSection()
            ],
          ),
          _exchangeableOnlyCheckButton()
        ],
      ),
    );
  }

  Widget _buildListSection(context) {
    SearchProductsViewModel viewModel =
        Provider.of<SearchProductsViewModel>(context, listen: false);

    Provider.of<SearchProductsProvider>(context, listen: false)
        .getSearchedProducts(
            UserProvider.userId,
            viewModel.searchValue,
            viewModel.categoryIds,
            viewModel.lowerCostBound,
            viewModel.upperCostBound,
            viewModel.sortMap);

    return Consumer<SearchProductsProvider>(
        builder: (context, provider, widget) {
      if (provider.productSearchDtoList != null) {
        return ListView.builder(
            itemBuilder: (context, index) {
              ProductSearchDtoModel product =
                  provider.productSearchDtoList![index];
              // int heartId = heartList[index].heartId;
              return _buildListItem(product, context);
            },
            itemCount: provider.productSearchDtoList!.length);
      }
      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildListItem(ProductSearchDtoModel product, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: screenSize.getSize(8.0),
        ),
        InkWell(
          onTap: () {},
          child: Row(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            icon: Icon(
                              product.like!
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: screenSize.getSize(25.0),
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Space(height: screenSize.getSize(8.0)),
        const CustomDivider()
      ],
    );
  }

  Widget _totalElementsText() {
    return Consumer<SearchProductsProvider>(
        builder: (context, provider, child) {
      return SizedBox(
        child: R16Text(
          text: '${provider.totalElements}개의 검색결과',
        ),
      );
    });
  }

  Widget _sortSelection() {
    return Consumer<SearchProductsViewModel>(
        builder: (context, viewModel, child) {
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
                B14Text(text: viewModel.sort),
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

  Widget _categorySelection() {
    return Consumer<SearchProductsViewModel>(
        builder: (context, viewModel, child) {
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
              Icons.grid_view,
              size: screenSize.getSize(20.0),
              color: const Color(0xFF14142B),
            ),
          ));
    });
  }

  Widget _costRangeSection() {
    return Consumer<SearchProductsViewModel>(
        builder: (context, viewModel, child) {
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
    });
  }

  Widget _exchangeableOnlyCheckButton() {
    return Consumer<SearchProductsViewModel>(
        builder: (context, viewModel, child) {
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
                  Provider.of<SearchProductsViewModel>(context, listen: false)
                      .toggleCheckBox();
                },
                icon: Provider.of<SearchProductsViewModel>(context)
                        .onlyExchangeable
                    ? const Icon(Icons.check_box, color: navy)
                    : const Icon(Icons.check_box_outlined)),
          ),
          const Space(width: 3.0),
          R14Text(
              text: '교환 가능한 물품만 보기',
              textColor:
                  Provider.of<SearchProductsViewModel>(context).onlyExchangeable
                      ? navy
                      : grey153),
          const Expanded(child: SizedBox())
        ],
      );
    });
  }
}
