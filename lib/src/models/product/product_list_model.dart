import 'package:navada_mobile_app/src/models/page_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';

class ProductPageModel extends PageModel<ProductModel> {
  ProductPageModel.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json['content'] != null) {
      content = <ProductModel>[];
      json['content'].forEach((v) {
        content!.add(ProductModel.fromJson(v));
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
