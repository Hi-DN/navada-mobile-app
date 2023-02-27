import 'package:navada_mobile_app/src/models/page_model.dart';

import '../../utilities/enums.dart';

class ProductSearchPageModel extends PageModel<ProductSearchDtoModel> {
  ProductSearchPageModel.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json['content'] != null) {
      content = <ProductSearchDtoModel>[];
      json['content'].forEach((v) {
        content!.add(ProductSearchDtoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductSearchDtoModel {
  int? productId;
  String? productImageUrl;
  String? productName;
  String? userNickname;
  int? productCost;
  int? exchangeCostRange;
  ProductExchangeStatusCd? productExchangeStatusCd;
  bool? like;

  ProductSearchDtoModel(
      {this.productId,
      this.productImageUrl,
      this.productName,
      this.userNickname,
      this.productCost,
      this.exchangeCostRange,
      this.productExchangeStatusCd,
      this.like});

  ProductSearchDtoModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productImageUrl = json['productImageUrl'];
    productName = json['productName'];
    userNickname = json['userNickname'];
    productCost = json['productCost'];
    exchangeCostRange = json['exchangeCostRange'];
    productExchangeStatusCd =
        ProductExchangeStatusCd.codeToEnum(json['productExchangeStatusCd']);
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = productId;
    data['productImageUrl'] = productImageUrl;
    data['productName'] = productName;
    data['userNickname'] = userNickname;
    data['productCost'] = productCost;
    data['exchangeCostRange'] = exchangeCostRange;
    data['productExchangeStatusCd'] = productExchangeStatusCd?.code;
    data['like'] = like;
    return data;
  }
}
