import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';
import 'package:navada_mobile_app/src/providers/create_product_provider.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail.dart';
import 'package:navada_mobile_app/src/screens/tab3_create/create_product/search_other_products_modal.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

import 'create_product_view_model.dart';

class CreateProductView extends StatelessWidget {
  const CreateProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CreateProductViewModel()),
      ChangeNotifierProvider(create: (context) => CreateProductProvider()),
    ], child: const MaterialApp(home: CreateProductScreen()));
  }
}

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  ScreenSize size = ScreenSize();
  var _scrollController;
  FocusNode? _productNameFNode;
  FocusNode? _productCategoryFNode;
  FocusNode? _productPriceFNode;
  FocusNode? _productExchangeCostFNode;
  FocusNode? _productExplanationFNode;

  Category? _productCategory;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _productNameFNode = FocusNode();
    _productCategoryFNode = FocusNode();
    _productPriceFNode = FocusNode();
    _productExchangeCostFNode = FocusNode();
    _productExplanationFNode = FocusNode();
  }

  @override
  void dispose() {
    _productNameFNode?.dispose();
    _productCategoryFNode?.dispose();
    _productPriceFNode?.dispose();
    _productExchangeCostFNode?.dispose();
    _productExplanationFNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController = PrimaryScrollController.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
            titleText: "교환 물품 등록하기",
            leadingYn: true,
            onTap: () =>
                Navigator.of(context, rootNavigator: true).pop(context)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _productInfoEnteringSection(),
              const CustomDivider(),
              _SearchOtherProductSection(),
              const Space(height: 20),
              _confirmBtn(context),
              const Space(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productInfoEnteringSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(20)),
      child: Column(
        children: [
          const Space(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_productNameField(), _categoryMenu()]),
          const Space(height: 30),
          Row(
            children: [
              _productImageField(),
              const Space(width: 15),
              _productPriceSection()
            ],
          ),
          const Space(height: 30),
          _productExplanationField(),
          const Space(height: 40),
        ],
      ),
    );
  }

  Widget _productNameField() {
    return SizedBox(
      width: size.getSize(200),
      child: TextFormField(
        maxLength: 20,
        focusNode: _productNameFNode,
        style: styleR.copyWith(fontSize: size.getSize(16)),
        onChanged: (value) {
          setState(() {
            Provider.of<CreateProductProvider>(context, listen: false)
                .setProductName(value);
          });
        },
        decoration: InputDecoration(
          hintText: '물품 이름을 입력해주세요',
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
      ),
    );
  }

  Widget _categoryMenu() {
    return Container(
      width: size.getSize(120),
      height: size.getSize(48),
      padding: EdgeInsets.all(size.getSize(5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: grey183, width: 1.0),
      ),
      alignment: Alignment.centerRight,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            focusNode: _productCategoryFNode,
            isDense: true,
            items: Category.values
                .map((category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(category.label),
                    ))
                .toList(),
            hint: const Text("카테고리"),
            value: _productCategory?.id,
            onChanged: (value) {
              setState(() {
                _productCategory =
                    Category.idToEnum(int.parse(value.toString()));
                Provider.of<CreateProductProvider>(context, listen: false)
                    .setProductCategory(_productCategory!);
              });
            }),
      ),
    );
  }

  Widget _productImageField() {
    return InkWell(onTap: () async {
      XFile? productImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (productImage != null) {
        setState(() {
          Provider.of<CreateProductProvider>(context, listen: false)
              .setProductImage(productImage);
        });
      }
    }, child: Consumer<CreateProductProvider>(
      builder: (context, provider, widget) {
        return SizedBox(
          width: size.getSize(149),
          height: size.getSize(149),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      width: size.getSize(139),
                      height: size.getSize(139),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: grey216,
                      ),
                      child: provider.productImage != null
                          ? Image.file(
                              File(provider.productImage!.path),
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.photo_library_outlined,
                              color: grey153))),
              provider.productImage != null
                  ? Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          provider.setProductImage(null);
                        },
                        icon: Icon(
                          Icons.cancel,
                          size: size.getSize(20.0),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    )
                  : Container()
            ],
          ),
        );
      },
    ));
  }

  Widget _productPriceSection() {
    return SizedBox(
      height: size.getSize(149),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productPriceField(),
          _productExchangeCostField(),
        ],
      ),
    );
  }

  Widget _productPriceField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const B16Text(text: "원가"),
        Container(
          margin: EdgeInsets.only(
              left: size.getSize(10),
              right: size.getSize(10),
              bottom: size.getSize(5)),
          width: size.getSize(100),
          child: TextFormField(
            focusNode: _productPriceFNode,
            textAlign: TextAlign.right,
            style: styleR.copyWith(fontSize: size.getSize(16)),
            onChanged: (value) {
              setState(() {
                Provider.of<CreateProductProvider>(context, listen: false)
                    .setProductPrice(int.parse(value));
              });
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: size.getSize(10.0),
              ),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: grey183)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: green)),
            ),
          ),
        ),
        const R16Text(text: "원"),
      ],
    );
  }

  Widget _productExchangeCostField() {
    return Padding(
      padding: EdgeInsets.only(bottom: size.getSize(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const B16Text(text: "희망교환가격범위"),
          const Space(height: 2),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: size.getSize(10),
                    right: size.getSize(10),
                    bottom: size.getSize(5)),
                width: size.getSize(130),
                child: TextFormField(
                  focusNode: _productExchangeCostFNode,
                  textAlign: TextAlign.right,
                  style: styleR.copyWith(fontSize: size.getSize(16)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onChanged: (value) {
                    setState(() {
                      Provider.of<CreateProductProvider>(context, listen: false)
                          .setProductExchangeCost(int.parse(value));
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: size.getSize(10.0),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: grey183)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: green)),
                  ),
                ),
              ),
              const R16Text(text: "원"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productExplanationField() {
    return TextFormField(
      focusNode: _productExplanationFNode,
      style: styleR.copyWith(fontSize: size.getSize(16)),
      onChanged: (value) {
        setState(() {
          Provider.of<CreateProductProvider>(context, listen: false)
              .setProductExplanation(value);
        });
      },
      maxLength: 200,
      maxLines: 7,
      decoration: InputDecoration(
        hintText: '설명을 입력해주세요',
        hintStyle: styleR.copyWith(fontSize: size.getSize(16), color: grey183),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.getSize(10.0),
          vertical: size.getSize(15.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.getSize(5.0)),
            borderSide: const BorderSide(color: grey183, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.getSize(5.0)),
            borderSide: const BorderSide(color: green, width: 1.0)),
      ),
    );
  }

  Widget _confirmBtn(BuildContext context) {
    return Consumer<CreateProductProvider>(builder:
        (BuildContext context, CreateProductProvider provider, Widget? _) {
      return LongCircledBtn(
          text: "등록하기",
          onTap: () async {
            if (!provider.checkValidProductName()) {
              _checkField(_productNameFNode!, "물품명을 확인해주세요!");
            } else if (!provider.checkValidProductCategory()) {
              _checkField(_productCategoryFNode!, "카테고리를 확인해주세요!");
            } else if (!provider.checkValidProductPrice()) {
              _checkField(_productPriceFNode!, "가격을 확인해주세요!");
            } else if (!provider.checkValidProductExchangeCost()) {
              _checkField(
                  _productExchangeCostFNode!, "희망가격범위를 확인해주세요! (원가 이하)");
            } else if (!provider.checkValidProductExplanation()) {
              _checkField(_productExplanationFNode!, "물품 설명을 확인해주세요!");
            } else {
              ProductModel? product = await Provider.of<CreateProductProvider>(
                      context,
                      listen: false)
                  .createProduct();
              if (product != null) {
                // ignore: use_build_context_synchronously
                bool isRequestingToOtherProducts =
                    !(Provider.of<CreateProductProvider>(context, listen: false)
                        .isOtherProductsEmpty);
                if (isRequestingToOtherProducts) {
                  // ignore: use_build_context_synchronously
                  await Provider.of<CreateProductProvider>(context,
                          listen: false)
                      .requestToOtherProducts(product.productId!);
                }
                _showSnackBarDurationForSec("글이 등록되었습니다🥰");
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProductDetail(productId: product.productId!)));
              } else {
                _showSnackBarDurationForSec("물품 등록에 실패했습니다ㅠㅠ");
              }
            }
          });
    });
  }

  _checkField(FocusNode fnode, String snackBarText) {
    FocusScope.of(context).requestFocus(fnode);
    _scrollController.jumpTo(0.0);
    _showSnackBarDurationForSec(snackBarText);
  }

  _showSnackBarDurationForSec(String snackBarText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: R16Text(text: snackBarText, textColor: white),
    ));
  }
}

class _SearchOtherProductSection extends StatelessWidget {
  _SearchOtherProductSection({Key? key}) : super(key: key);

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    _context = context;
    bool isRequestingToOtherProducts =
        !(Provider.of<CreateProductProvider>(context, listen: false)
            .isOtherProductsEmpty);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Space(height: 30),
          _searchBtn(),
          const Space(height: 30),
          _selectedOtherProductListSection(),
          isRequestingToOtherProducts ? const Space(height: 70) : Container(),
          isRequestingToOtherProducts ? _warnings() : Container()
        ],
      ),
    );
  }

  Widget _searchBtn() {
    ScreenSize size = ScreenSize();
    return GestureDetector(
      onTap: () => _showSearchOtherProductsModal(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: grey183,
            size: size.getSize(28),
          ),
          const Space(width: 10),
          Container(
              padding: EdgeInsets.only(
                  top: size.getSize(10),
                  left: size.getSize(10),
                  bottom: size.getSize(15),
                  right: size.getSize(60)),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: grey183))),
              child: const R16Text(
                text: "바로 교환할 물품을 검색해보세요!",
                textColor: grey183,
              ))
        ],
      ),
    );
  }

  _showSearchOtherProductsModal() {
    ScreenSize size = ScreenSize();
    final provider =
        Provider.of<CreateProductProvider>(_context, listen: false);

    showModalBottomSheet(
      context: _context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.getSize(30)),
            topRight: Radius.circular(size.getSize(30))),
      ),
      builder: (context) {
        return ChangeNotifierProvider.value(
            value: provider, child: const SearchOtherProductsModal());
      },
    );
  }

  Widget _selectedOtherProductListSection() {
    List<ProductSearchDtoModel> products =
        Provider.of<CreateProductProvider>(_context).otherProducts;
    return ListView.separated(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          ProductSearchDtoModel product = products[index];

          return _selectedOtherProductTile(product);
        },
        separatorBuilder: (context, index) {
          return const Space(height: 10);
        });
  }

  Widget _selectedOtherProductTile(ProductSearchDtoModel product) {
    ScreenSize size = ScreenSize();
    return Container(
      padding: EdgeInsets.all(size.getSize(14)),
      decoration: BoxDecoration(
          color: grey239,
          borderRadius: BorderRadius.circular(size.getSize(10))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _exampleImage(),
              const Space(width: 15),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    B14Text(text: product.productName),
                    Row(
                      children: [
                        const B14Text(text: "교환상대 "),
                        R14Text(text: product.userNickname)
                      ],
                    ),
                    Row(
                      children: [
                        const B14Text(text: "원가 "),
                        R14Text(text: "${product.productCost}원")
                      ],
                    ),
                  ]),
            ],
          ),
          const Expanded(child: SizedBox()),
          _deleteProductBtn(product.productId!),
        ],
      ),
    );
  }

  Widget _exampleImage() {
    ScreenSize size = ScreenSize();
    return ClipRRect(
        borderRadius: BorderRadius.circular(size.getSize(5)),
        child: Image.asset(
          'assets/images/test.jpeg',
          width: size.getSize(65.0),
          height: size.getSize(65.0),
        ));
  }

  Widget _deleteProductBtn(int productId) {
    ScreenSize size = ScreenSize();
    return GestureDetector(
        onTap: () {
          Provider.of<CreateProductProvider>(_context, listen: false)
              .removeFromOtherProducts(productId);
        },
        child:
            Icon(Icons.remove_circle, color: grey183, size: size.getSize(22)));
  }

  Widget _warnings() {
    return const R12Text(
      text:
          "  ※ 바로 교환 신청하는 경우, 교환 상품이 자동으로 등록됩니다.\n  ※ 여러 상품에 교환 신청하는 경우,\n    가장 먼저 수락되는 상품과 자동으로 교환이 이루어집니다.",
      textColor: grey153,
    );
  }
}
