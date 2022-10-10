import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/search_products_provider.dart';
import 'package:navada_mobile_app/src/screens/search_products/search_products_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/cost_range_badge.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/status_badge.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import '../../models/product/product_search_page_model.dart';
import '../../widgets/colors.dart';
import '../../widgets/divider.dart';
import '../product_detail/product_detail.dart';

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
            Flexible(flex: 3, child: _buildOptionSection(context)),
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
        .getSearchedProducts(viewModel);

    return Consumer<SearchProductsProvider>(
        builder: (context, provider, widget) {
      if (provider.productSearchPageModel != null) {
        print('list rebuild!');
        return ListView.builder(
            itemBuilder: (context, index) {
              ProductSearchDtoModel product =
                  provider.productSearchDtoList![index];
              return InkWell(
                child: _buildListItem(context, product),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ProductDetail(
                        productId: product.productId!, like: product.like!);
                  })).then((value) => Provider.of<SearchProductsProvider>(
                              context,
                              listen: false)
                          .getSearchedProducts(viewModel));
                },
              );
            },
            itemCount: provider.productSearchDtoList!.length);
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
                        StatusBadge_new(
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
          text: '${provider.totalElements}개의 검색결과',
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

  Widget _categorySelection() {
    return Consumer2<SearchProductsProvider, SearchProductsViewModel>(
        builder: (context, provider, viewModel, child) {
      return SizedBox(
          width: screenSize.getSize(35.0),
          height: screenSize.getSize(35.0),
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  builder: (context) {
                    return _showCategoryModal(context, provider, viewModel);
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

  Widget _showCategoryModal(BuildContext context,
      SearchProductsProvider provider, SearchProductsViewModel viewModel) {
    ScrollController scrollController = ScrollController();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              controller: scrollController,
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
                            icon: viewModel.categoryIds.contains(categoryId)
                                ? const Icon(Icons.radio_button_checked)
                                : const Icon(Icons.radio_button_unchecked),
                            color: green,
                            onPressed: () =>
                                viewModel.setCategoryIds(categoryId),
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
        SizedBox(
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
            ))
      ],
    );
  }
}

// class CategoryBottomSheet extends StatelessWidget {
//   SearchProductsProvider provider;
//   SearchProductsViewModel viewModel;
//
//   CategoryBottomSheet(
//       {Key? key, required this.provider, required this.viewModel})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(providers: [
//       ChangeNotifierProvider(create: (context) => SearchProductsViewModel()),
//     ], child: _categoryListView(provider, viewModel));
//   }
//
//   Widget _categoryListView(
//       SearchProductsProvider provider, SearchProductsViewModel viewModel) {
//     ScrollController scrollController = ScrollController();
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//               controller: scrollController,
//               itemBuilder: (context, index) {
//
//                 int categoryId = index + 1;
//                 return Container(
//                   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Space(height: 6.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('  ${Category.idToLabel(categoryId)}'),
//                           IconButton(
//                             icon: viewModel.categoryIds.contains(categoryId)
//                                 ? const Icon(Icons.radio_button_checked)
//                                 : const Icon(Icons.radio_button_unchecked),
//                             color: green,
//                             onPressed: () {
//                               // Provider.of<SearchProductsViewModel>(context,
//                               //         listen: false)
//                               //     .setCategoryIds(categoryId);
//                               viewModel.setCategoryIds(categoryId);
//                             },
//                           )
//                         ],
//                       ),
//                       const Space(height: 5.0),
//                       Container(
//                           width: double.infinity,
//                           height: 1.0,
//                           color: Colors.grey),
//                     ],
//                   ),
//                 );
//               },
//               itemCount: Category.values.length),
//         ),
//         Consumer<SearchProductsViewModel>(
//             builder: (context, viewModel2, child) {
//           return SizedBox(
//               height: 70.0,
//               width: double.infinity,
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(20.0),
//                         bottomRight: Radius.circular(20.0),
//                       ),
//                     ),
//                     backgroundColor: green),
//                 onPressed: () {
//                   provider.getSearchedProducts(UserProvider.userId, viewModel);
//                   Navigator.of(context).pop();
//                 },
//                 child: const R20Text(text: '적용하기', textColor: Colors.white),
//               ));
//         }),
//       ],
//     );
//   }
// }
