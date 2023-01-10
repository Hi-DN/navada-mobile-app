import 'package:navada_mobile_app/src/models/page_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';

class HeartListModel extends PageModel<HeartListContentModel> {
  HeartListModel.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    content = List.from(json['content'])
        .map((e) => HeartListContentModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['content'] = content?.map((e) => e.toJson()).toList();
    return data;
  }
}

class HeartListContentModel {
  HeartListContentModel({
    this.createdDate,
    this.modifiedDate,
    required this.heartId,
    required this.product,
  });
  late final dynamic createdDate;
  late final dynamic modifiedDate;
  late final int heartId;
  late final ProductModel product;

  HeartListContentModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    heartId = json['heartId'];
    product = ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['heartId'] = heartId;
    data['product'] = product.toJson();
    return data;
  }
}
