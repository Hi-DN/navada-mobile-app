import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/search_products_provider.dart';
import 'package:navada_mobile_app/src/screens/tab2_products/search_products/search_products_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/utilities/gcs_image.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/cost_range_badge.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/short_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/status_badge.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../../../models/product/product_search_page_model.dart';
import '../../../widgets/colors.dart';
import '../../../widgets/divider.dart';
import '../../product_detail/product_detail.dart';

class SearchProductsView extends StatelessWidget {
  SearchProductsView({Key? key}) : super(key: key);
  ScreenSize screenSize = ScreenSize();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: screenSize.getSize(327.0),
          padding: EdgeInsets.only(top: screenSize.getSize(5.0)),
          child: Column(
            children: [
              Flexible(flex: 2, child: _buildSearchField(context)),
              Flexible(flex: 3, child: _buildOptionSection(context)),
              Flexible(flex: 15, child: _buildListSection(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    SearchProductsViewModel viewModel =
        Provider.of<SearchProductsViewModel>(context, listen: false);
    SearchProductsProvider provider =
        Provider.of<SearchProductsProvider>(context, listen: false);

    return Center(
        child: InkWell(
      onTap: () async {
        String? value = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) {
          return SearchProductsInputProductName(
              initialValue: viewModel.searchValue);
        }));
        viewModel.setSearchValue(value);
        provider.getSearchedProducts(viewModel);
      },
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
              Space(width: screenSize.getSize(8.0)),
              Expanded(
                child:
                    Provider.of<SearchProductsViewModel>(context).searchValue ==
                            null
                        ? Container()
                        : Container(
                            child: Text(viewModel.searchValue!),
                          ),
              )
            ],
          )),
    ));
  }

  Widget _buildOptionSection(BuildContext context) {
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
              _categorySelection(context),
              Space(width: screenSize.getSize(5.0)),
              _costRangeSelection(context)
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
        .getSearchedProducts(viewModel);

    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        Provider.of<SearchProductsProvider>(context, listen: false)
            .fetchMoreData(viewModel);
      }
    });

    return Consumer<SearchProductsProvider>(
        builder: (context, provider, widget) {
      if (provider.productSearchPageModel != null) {
        return RefreshIndicator(
          color: green,
          onRefresh: () async {
            await Provider.of<SearchProductsProvider>(context, listen: false)
                .refresh(viewModel);
          },
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              itemBuilder: (context, index) {
                ProductSearchDtoModel product =
                    provider.productSearchDtoList![index];
                return InkWell(
                  child: _buildListItem(context, product),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ProductDetail(productId: product.productId!);
                    })).then((value) => Provider.of<SearchProductsProvider>(
                                context,
                                listen: false)
                            .getSearchedProducts(viewModel));
                  },
                );
              },
              itemCount: provider.productSearchDtoList!.length),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildListItem(BuildContext context, ProductSearchDtoModel product) {
    return Column(
      children: [
        SizedBox(
          height: screenSize.getSize(8.0),
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: SizedBox(
                width: screenSize.getSize(65.0),
                height: screenSize.getSize(65.0),
                child: getGcsImage(product.productImageUrl),
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
                            onPressed: () {
                              Provider.of<SearchProductsProvider>(context,
                                      listen: false)
                                  .onHeartButtonTapped(product);
                            },
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

  Widget _totalElementsText() {
    return Consumer<SearchProductsProvider>(
        builder: (context, provider, child) {
      return SizedBox(
        child: R16Text(
          text: '${provider.totalElements}개의 물품',
        ),
      );
    });
  }

  Widget _sortSelection() {
    return Consumer2<SearchProductsProvider, SearchProductsViewModel>(
        builder: (context, provider, viewModel, child) {
      return SizedBox(
        height: screenSize.getSize(35.0),
        child: ElevatedButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                        title: const Text('정렬 기준'),
                        actions: [
                          _buildSortActionItem(
                              '최신순', provider, viewModel, context),
                          _buildSortActionItem(
                              '좋아요순', provider, viewModel, context),
                        ],
                      ));
            },
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

  _buildSortActionItem(String sortValue, SearchProductsProvider provider,
      SearchProductsViewModel viewModel, BuildContext context) {
    return CupertinoActionSheetAction(
        onPressed: () {
          viewModel.setSortValue(sortValue);
          provider.getSearchedProducts(viewModel);
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Space(width: 20.0),
            Text(sortValue, style: const TextStyle(color: Colors.black)),
            const Space(width: 20.0),
            viewModel.sort == sortValue ? const Icon(Icons.check) : Container()
          ],
        ));
  }

  Widget _categorySelection(BuildContext context) {
    SearchProductsViewModel viewModel =
        Provider.of<SearchProductsViewModel>(context, listen: false);
    SearchProductsProvider provider =
        Provider.of<SearchProductsProvider>(context, listen: false);

    return SizedBox(
        width: screenSize.getSize(35.0),
        height: screenSize.getSize(35.0),
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                builder: (context) {
                  return ChangeNotifierProvider.value(
                      value: viewModel,
                      child: _showCategoryModal(context, provider));
                });
          },
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
  }

  Widget _costRangeSelection(BuildContext context) {
    SearchProductsViewModel viewModel =
        Provider.of<SearchProductsViewModel>(context, listen: false);
    SearchProductsProvider provider =
        Provider.of<SearchProductsProvider>(context, listen: false);
    return SizedBox(
        width: screenSize.getSize(35.0),
        height: screenSize.getSize(35.0),
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))),
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: ChangeNotifierProvider.value(
                        value: viewModel,
                        child: _showCostRangeModal(context, provider)),
                  );
                });
          },
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
    return Consumer2<SearchProductsProvider, SearchProductsViewModel>(
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
                  Provider.of<SearchProductsViewModel>(context, listen: false)
                      .toggleCheckBox();
                  provider.getSearchedProducts(viewModel);
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

  Widget _showCategoryModal(
      BuildContext context, SearchProductsProvider provider) {
    ScrollController categoryScrollController = ScrollController();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              controller: categoryScrollController,
              itemBuilder: (context, index) {
                int categoryId = index + 1;
                return Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Space(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('  ${Category.idToLabel(categoryId)}'),
                          IconButton(
                            icon: Provider.of<SearchProductsViewModel>(context)
                                    .categoryIds
                                    .contains(categoryId)
                                ? const Icon(Icons.radio_button_checked)
                                : const Icon(Icons.radio_button_unchecked),
                            color: green,
                            onPressed: () {
                              Provider.of<SearchProductsViewModel>(context,
                                      listen: false)
                                  .setCategoryIds(categoryId);
                            },
                          )
                        ],
                      ),
                      const Space(height: 5.0),
                      Container(
                          width: double.infinity,
                          height: 1.0,
                          color: Colors.grey),
                    ],
                  ),
                );
              },
              itemCount: Category.values.length),
        ),
        Consumer<SearchProductsViewModel>(builder: (context, viewModel, child) {
          return SizedBox(
              height: 70.0,
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    backgroundColor: green),
                onPressed: () {
                  provider.getSearchedProducts(viewModel);
                  Navigator.of(context).pop();
                },
                child: const R20Text(text: '적용하기', textColor: Colors.white),
              ));
        })
      ],
    );
  }

  Widget _showCostRangeModal(
      BuildContext context, SearchProductsProvider provider) {
    return Consumer<SearchProductsViewModel>(
        builder: (context, viewModel, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              height: screenSize.getSize(300.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const B14Text(
                    text: '물품의 가격 범위를 지정해보세요 :D',
                    textColor: Colors.black38,
                  ),
                  const Space(height: 80.0),
                  _costRangeTextField(viewModel),
                  const Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShortCircledBtn(
                        text: '취소',
                        backgroundColor: navy,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ShortCircledBtn(
                        text: '적용',
                        onTap: () {
                          viewModel.applyCostBound();
                          provider.getSearchedProducts(viewModel);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _costRangeTextField(SearchProductsViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: screenSize.getSize(80.0),
          height: screenSize.getSize(30.0),
          child: TextField(
            controller: viewModel.lowerCostController,
            cursorColor: green,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: green),
              ),
            ),
          ),
        ),
        const B14Text(text: '원'),
        const B14Text(text: ' ~ '),
        SizedBox(
          width: screenSize.getSize(80.0),
          height: screenSize.getSize(30.0),
          child: TextField(
            controller: viewModel.upperCostController,
          ),
        ),
        const B14Text(text: '원'),
        _refreshCostBtn(viewModel),
      ],
    );
  }

  Widget _refreshCostBtn(SearchProductsViewModel viewModel) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          viewModel.resetCostBound();
        },
        icon: const Icon(
          Icons.refresh,
          color: Colors.black38,
        ));
  }
}

class SearchProductsInputProductName extends StatelessWidget {
  SearchProductsInputProductName({Key? key, required this.initialValue})
      : super(key: key);

  String? initialValue;
  ScreenSize screenSize = ScreenSize();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) _controller.text = initialValue!;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
              height: screenSize.getSize(600.0),
              alignment: Alignment.topCenter,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back, color: Colors.black54),
                  iconSize: screenSize.getSize(30.0),
                ),
                Expanded(
                  child: SizedBox(
                    height: screenSize.getSize(40.0),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (value) => Navigator.of(context).pop(
                          _controller.value.text.isNotEmpty
                              ? _controller.value.text
                              : null),
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: screenSize.getSize(15.0)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _controller.clear();
                          },
                          icon: const Icon(Icons.cancel, color: Colors.black38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.0),
                        ),
                      ),
                      cursorColor: Colors.black12,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(
                      _controller.value.text.isNotEmpty
                          ? _controller.value.text
                          : null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.search, color: Colors.black54),
                  iconSize: screenSize.getSize(30.0),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
