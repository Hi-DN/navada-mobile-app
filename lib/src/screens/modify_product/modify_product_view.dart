import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/providers/modify_product_provider.dart';
import 'package:navada_mobile_app/src/screens/modify_product/modify_product_view_model.dart';
import 'package:navada_mobile_app/src/screens/product_detail/product_detail.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class ModifyProductView extends StatelessWidget {
  const ModifyProductView({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ModifyProductProvider()),
      ChangeNotifierProvider(create: (context) => ModifyProductViewModel(product.productName, product.category, product.productCost, product.exchangeCostRange, product.productExplanation)),
    ], child: MaterialApp(home: ModifyProductScreen()));
  }
}

class ModifyProductScreen extends StatelessWidget {
  ModifyProductScreen({Key? key, this.product}) : super(key: key);

  final ProductModel? product;

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
            titleText: "교환 물품 수정하기",
            leadingYn: true,
            onTap: () => Navigator.of(context, rootNavigator: true).pop(context)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _productInfoEnteringSection(),
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
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(20)),
      child: Column(
        children: [
          const Space(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_productNameField(), _categoryMenu()]),
          const Space(height: 30),
          Row(children: [
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
    ScreenSize size = ScreenSize();
    return SizedBox(
      width: size.getSize(200),
      child: TextFormField(
        controller: Provider.of<ModifyProductViewModel>(_context!, listen: false).productNameController,
        // initialValue: Provider.of<ModifyProductViewModel>(_context!, listen: false).productName,
        maxLength: 20,
        focusNode: Provider.of<ModifyProductViewModel>(_context!, listen: false).productNameFNode,
        style: styleR.copyWith(fontSize: size.getSize(16)),
        onChanged: (value) {
          Provider.of<ModifyProductViewModel>(_context!, listen: false).setProductName(value);
        },
        decoration: InputDecoration(
          hintText: '물품 이름을 입력해주세요',
          hintStyle:styleR.copyWith(fontSize: size.getSize(16), color: grey183),
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
    ScreenSize size = ScreenSize();
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
            focusNode: Provider.of<ModifyProductViewModel>(_context!, listen: false).productCategoryFNode,
            isDense: true,
            items: Category.values
                .map((category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(category.label),
                    ))
                .toList(),
            hint: const Text("카테고리"),
            value: Provider.of<ModifyProductViewModel>(_context!, listen: false).productCategory!.id,
            onChanged: (value) {
              Provider.of<ModifyProductViewModel>(_context!, listen: false).setProductCategory(Category.idToEnum(int.parse(value.toString())));
            }
      ),
    ));
  }

  Widget _productImageField() {
    ScreenSize size = ScreenSize();
    return Container(
      width: size.getSize(149),
      height: size.getSize(149),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey216),
      child: const Icon(Icons.photo_library_outlined, color: grey153),
    );
  }

  Widget _productPriceSection() {
    ScreenSize size = ScreenSize();
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
    ScreenSize size = ScreenSize();
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
            controller: Provider.of<ModifyProductViewModel>(_context!, listen: false).productPriceController,
            // initialValue: Provider.of<ModifyProductViewModel>(_context!, listen: false).productPrice.toString(),
            focusNode: Provider.of<ModifyProductViewModel>(_context!, listen: false).productPriceFNode,
            textAlign: TextAlign.right,
            style: styleR.copyWith(fontSize: size.getSize(16)),
            onChanged: (value) {
              Provider.of<ModifyProductViewModel>(_context!, listen: false).setProductPrice(int.parse(value));
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
    ScreenSize size = ScreenSize();
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
                  controller: Provider.of<ModifyProductViewModel>(_context!, listen: false).productExchangeCostController,
                  // initialValue: Provider.of<ModifyProductViewModel>(_context!, listen: false).productExchangeCost.toString(),
                  focusNode: Provider.of<ModifyProductViewModel>(_context!, listen: false).productExchangeCostFNode,
                  textAlign: TextAlign.right,
                  style: styleR.copyWith(fontSize: size.getSize(16)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onChanged: (value) {
                    Provider.of<ModifyProductViewModel>(_context!, listen: false).setProductExchangeCost(int.parse(value));
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
    ScreenSize size = ScreenSize();
    return TextFormField(
      controller: Provider.of<ModifyProductViewModel>(_context!, listen: false).productExplanationController,
      // initialValue: Provider.of<ModifyProductViewModel>(_context!, listen: false).productExplanation,
      focusNode: Provider.of<ModifyProductViewModel>(_context!, listen: false).productExplanationFNode,
      style: styleR.copyWith(fontSize: size.getSize(16)),
      onChanged: (value) {
        Provider.of<ModifyProductViewModel>(_context!, listen: false).setProductExplanation(value);
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
    return Consumer<ModifyProductViewModel>(builder:
        (BuildContext context, ModifyProductViewModel viewModel, Widget? _) {
      return LongCircledBtn(
          text: "수정하기",
          onTap: () async {
            if (!viewModel.checkValidProductName()) {
              _checkField(viewModel.productNameFNode, "물품명을 확인해주세요!");
            } else if (!viewModel.checkValidProductCategory()) {
              _checkField(viewModel.productCategoryFNode, "카테고리를 확인해주세요!");
            } else if (!viewModel.checkValidProductPrice()) {
              _checkField(viewModel.productPriceFNode, "가격을 확인해주세요!");
            } else if (!viewModel.checkValidProductExchangeCost()) {
              _checkField(
                  viewModel.productExchangeCostFNode, "희망가격범위를 확인해주세요! (원가 이하)");
            } else if (!viewModel.checkValidProductExplanation()) {
              _checkField(viewModel.productExplanationFNode, "물품 설명을 확인해주세요!");
            } else {
              ProductModel? product = await Provider.of<ModifyProductProvider>(context,listen: false)
                  .modifyProduct(
                    ProductParams(
                      productName: viewModel.productName,
                      categoryId: viewModel.productCategory?.id,
                      productCost: viewModel.productPrice,
                      exchangeCostRange: viewModel.productExchangeCost,
                      productExplanation: viewModel.productExplanation
                    )
                  );
              if (product != null) {
                _showSnackBarDurationForSec("글이 수정되었습니다🥰");
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProductDetail(
                            productId: product.productId!, like: false)));
              } else {
                _showSnackBarDurationForSec("물품 수정을 실패했습니다ㅠㅠ");
              }
            }
          });
    });
  }

  _checkField(FocusNode fnode, String snackBarText) {
    FocusScope.of(_context!).requestFocus(fnode);
    _showSnackBarDurationForSec(snackBarText);
  }

  _showSnackBarDurationForSec(String snackBarText) {
    ScaffoldMessenger.of(_context!).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: R16Text(text: snackBarText, textColor: white),
    ));
  }
}