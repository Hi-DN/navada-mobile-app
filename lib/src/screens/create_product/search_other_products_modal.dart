
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/providers/create_product_provider.dart';
import 'package:navada_mobile_app/src/utilities/shortener.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

//TODO: 프로덕트 리스트 다시 불러올 때 아이디 확인해서 체크 표시하기 

class SearchOtherProductsModal extends StatefulWidget {
  const SearchOtherProductsModal({Key? key}) : super(key: key);

  @override
  State<SearchOtherProductsModal> createState() => _SearchOtherProductsModalState();
}

class _SearchOtherProductsModalState extends State<SearchOtherProductsModal> {
  ScreenSize size = ScreenSize();
  FocusNode? _searchFNode;

  String? searchWord;
  List<ProductSearchDtoModel> checkedProducts = [];
  List<ProductSearchDtoModel> searchedProducts =[];
  int pageNum = 0;
  bool firstLoaded = false;
  bool lastLoaded = false;

  @override
  void initState() {
    super.initState();
    _searchFNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductSearchPageModel>(
      future: Provider.of<CreateProductProvider>(context, listen: false).getProductsBySearchWord("", 0),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(!firstLoaded) {
            ProductSearchPageModel? pageResponse = snapshot.data;
            if(pageResponse!.last!) lastLoaded = true;
            searchedProducts.addAll(pageResponse.content!);
            firstLoaded = true;
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.all(size.getSize(15)),
              height: size.getSize(600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _greyStick(),
                  const Space(height: 15),
                  _searchSection(),
                  const Space(height: 15),
                  _checkedProductThumbnailList(),
                  const CustomDivider(),
                  const Space(height: 15),
                  _searchedProductListSection()
                ])),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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
      ])
    );
  }

  Widget _searchSection() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: grey183,
            size: size.getSize(28),
          ),
          const Space(width: 10),
          Expanded(child: _searchTextField()),
          const Space(width: 15),
        ],
      );
  }

  Widget _checkedProductThumbnailList() {
    return SizedBox(
      height: size.getSize(72),
      child: ListView.separated(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemCount: checkedProducts.length,
        itemBuilder: (context, index) {
          ProductSearchDtoModel product = checkedProducts[index];

          return _productThumbnail(product);
        },
        separatorBuilder: (context, index) {
          return const Space(width: 8);
        }),
    );
  }
  

  Widget _productThumbnail(ProductSearchDtoModel product) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size.getSize(5)),
          child: Image.asset(
            'assets/images/test.jpeg',
            width: size.getSize(60.0),
            height: size.getSize(60.0),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              checkedProducts.remove(product);
            });
          },
          child: Icon(Icons.remove_circle, color: grey183, size: size.getSize(18)))
      ],
    );
  }

  Widget _searchTextField() {
    return TextFormField(
      style: styleR.copyWith(fontSize: size.getSize(16)),
      onChanged: (value) async {
        setState(() {
          searchedProducts = [];
          lastLoaded=false;
        });
        ProductSearchPageModel? pageResponse;
          if(!lastLoaded) {
            pageResponse = await Provider.of<CreateProductProvider>(context, listen: false)
                .getProductsBySearchWord(value, pageNum);
          }
          setState(() {
            if(!lastLoaded) {
              if(pageResponse!.last!) lastLoaded = true;

              List<ProductSearchDtoModel> dataList = pageResponse.content!;
              searchedProducts.addAll(dataList);
            }
          });
        },
        maxLines: 1,
        decoration: InputDecoration(
          hintText: '바로 교환할 물품을 검색해보세요!',
          hintStyle:
              styleR.copyWith(fontSize: size.getSize(16), color: grey183),
          counterText: "",
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(10.0),
            vertical: size.getSize(15.0),
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: grey183)),
          focusedBorder:
              const UnderlineInputBorder(borderSide: BorderSide(color: green)),
        ),
    );
  }

  Widget _searchedProductListSection() {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: searchedProducts.length,
        itemBuilder: (context, index) {
          ProductSearchDtoModel product = searchedProducts[index];
          bool isChecked = checkedProducts.contains(product);

          return _searchProductTile(product, isChecked);
        },
        separatorBuilder: (context, index) {
          return const Space(height: 10);
        }),
    );
  }

  Widget _searchProductTile(ProductSearchDtoModel product, bool isChecked) {
    return Row(
      children: [
        _exampleImage(),
        const Space(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
          Row(
            children: [
              B12Text(text: Shortener.shortenStrTo(product.productName!, 15)),
              R12Text(
                text: ' | ${Shortener.shortenStrTo(product.userNickname!, 10)}',
                textColor: grey153)]),
          Row(
              children: [
                const B12Text(text: '원가 '),
                R12Text(text: product.productCost!.toString())
              ]),
          Row(
            
              children: [
                const B12Text(text: '희망가격 '),
                R12Text(text: "${product.productCost!-product.exchangeCostRange!} ~ ${product.productCost!+product.exchangeCostRange!}")
              ])
        ]),
        const Expanded(child:SizedBox()),
        _checkBtn(product, isChecked),
        const Space(width: 10),
      ],
    );
  }

  Widget _exampleImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size.getSize(5)),
      child: Image.asset(
        'assets/images/test.jpeg',
        width: size.getSize(70.0),
        height: size.getSize(70.0),
      )
    );
  }

  Widget _checkBtn(ProductSearchDtoModel product, bool isChecked) {
    ScreenSize size = ScreenSize();
    return GestureDetector(
      onTap: () {
        setState(() {
          if(isChecked) {
            checkedProducts.remove(product);
          } else {
            checkedProducts.add(product);
          }
        });
      },
      child: Container(
        height: size.getSize(24),
        width: size.getSize(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isChecked ? navy : green
        ),
        child: Icon(
          isChecked ? Icons.check : Icons.add,
          color: white,
        )
      ),
    );
  }
}
