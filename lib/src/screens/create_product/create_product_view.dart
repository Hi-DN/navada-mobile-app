
import 'package:flutter/material.dart';
import 'package:navada_mobile_app/src/providers/create_product_provicder.dart';
import 'package:navada_mobile_app/src/screens/create_product/create_product_view_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';
import 'package:navada_mobile_app/src/widgets/colors.dart';
import 'package:navada_mobile_app/src/widgets/custom_appbar.dart';
import 'package:navada_mobile_app/src/widgets/divider.dart';
import 'package:navada_mobile_app/src/widgets/long_circled_btn.dart';
import 'package:navada_mobile_app/src/widgets/screen_size.dart';
import 'package:navada_mobile_app/src/widgets/space.dart';
import 'package:navada_mobile_app/src/widgets/text_style.dart';
import 'package:provider/provider.dart';

class CreateProductView extends StatelessWidget {
  const CreateProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CreateProductViewModel()),
        ChangeNotifierProvider(create: (context) => CreateProductProvider()),
      ],
      child: Consumer<CreateProductViewModel>(builder: 
        (BuildContext context, CreateProductViewModel viewModel, Widget? _) {
        
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: CustomAppBar(
              titleText: "교환 물품 등록하기",
              leadingYn: true,
              onTap: () => Navigator.of(context).pop(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  _ProductInfoEnteringSection(),
                  CustomDivider(),
                  _SearchOtherProductSection(),
                  Space(height: 70),
                  _ConfirmBtn(),
                  Space(height: 30),
                ],
              ),
            ),
          ),
        );
      })
    );
  }
}

class _ProductInfoEnteringSection extends StatefulWidget {
  const _ProductInfoEnteringSection({Key? key}) : super(key: key);

  @override
  State<_ProductInfoEnteringSection> createState() => __ProductInfoEnteringSectionState();
}

class __ProductInfoEnteringSectionState extends State<_ProductInfoEnteringSection> {
  String? _productName;
  Category? _productCategory;
  int? _productPrice;
  int? _productExchangeCost;
  String? _productExplanation;

  FocusNode? _productNameFNode;
  FocusNode? _productCategoryFNode;
  FocusNode? _productPriceFNode;
  FocusNode? _productExchangeCostFNode;
  FocusNode? _productExplanationFNode;

  ScreenSize size = ScreenSize();

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(20)),
      child: Column(
        children: [
          const Space(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _productNameField(),
              _categoryMenu()]),
          const Space(height: 30),
          Row(children: [
            _productImageField(), 
            const Space(width: 15), 
            _productPriceSection()],
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
        focusNode: _productNameFNode,
        style: styleR.copyWith(fontSize: size.getSize(16)),
        onChanged: (value) {
          setState(() {
            _productName = value;
          });
          Provider.of<CreateProductProvider>(context, listen: false).setProductName(_productName!);
        },
        decoration: InputDecoration(
          hintText: '물품 이름을 입력해주세요',
          hintStyle: styleR.copyWith(fontSize: size.getSize(16), color: grey183),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(10.0),
            vertical: size.getSize(15.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: grey183)),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: green)),
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
          items: Category.values.map((category) => DropdownMenuItem(
            value: category.id,
            child: Text(category.label),
          )).toList(),
          hint: const Text("카테고리"),
          value: _productCategory?.id,
          onChanged: (value) {
            setState(() {
              _productCategory = Category.idToEnum(int.parse(value.toString()));
            });
            Provider.of<CreateProductProvider>(context, listen: false).setProductCategory(_productCategory!);
          }
        ),
      ),
    );
  }

  Widget _productImageField() {
    return Container(
      width: size.getSize(149),
      height: size.getSize(149),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: grey216
      ),
      child: const Icon(Icons.photo_library_outlined, color: grey153),
    );
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
          margin: EdgeInsets.only(left: size.getSize(10), right:  size.getSize(10), bottom: size.getSize(5)),
          width: size.getSize(100),
          child: TextFormField(
            focusNode: _productPriceFNode,
            textAlign: TextAlign.right,
            style: styleR.copyWith(fontSize: size.getSize(16)),
            onChanged: (value) {
              setState(() {
                _productPrice = int.parse(value);
              });
              Provider.of<CreateProductProvider>(context, listen: false).setProductPrice(_productPrice!);
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
                margin: EdgeInsets.only(left: size.getSize(10), right:  size.getSize(10), bottom: size.getSize(5)),
                width: size.getSize(130),
                child: TextFormField(
                  focusNode: _productExchangeCostFNode,
                  textAlign: TextAlign.right,
                  style: styleR.copyWith(fontSize: size.getSize(16)),
                  onChanged: (value) {
                    setState(() {
                      _productExchangeCost = int.parse(value);
                    });
                    Provider.of<CreateProductProvider>(context, listen: false).setProductExchangeCost(_productExchangeCost!);
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
          _productExplanation = value;
        });
        Provider.of<CreateProductProvider>(context, listen: false).setProductExplanation(_productExplanation!);
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
}

class _SearchOtherProductSection extends StatelessWidget {
  const _SearchOtherProductSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize size = ScreenSize();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getSize(20)),
      child: Column(
        children: [
          const Space(height: 30),
          _searchBtn(),
          const Space(height: 30),
        ],
      ),
    );
  }

  Widget _searchBtn() {
    ScreenSize size = ScreenSize();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.search, color: grey183, size: size.getSize(28),),
        const Space(width: 10),
        Container(
          padding: EdgeInsets.only(top: size.getSize(10), left: size.getSize(10), bottom: size.getSize(15), right: size.getSize(60)),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: grey183))
          ),
          child: const R16Text(text: "바로 교환할 물품을 검색해보세요!", textColor: grey183,))
      ],
    );
  }
}

class _ConfirmBtn extends StatelessWidget {
  const _ConfirmBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LongCircledBtn(text: "글 등록하기");
  }
}
