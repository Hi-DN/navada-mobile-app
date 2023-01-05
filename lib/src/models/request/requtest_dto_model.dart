import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class RequestDto {
  int? requestId;
  RequestStatusCd? requestStatusCd;
  String? requestCreatedDt;
  ProductModel? requesterProduct;
  ProductModel? acceptorProduct;

  RequestDto(
      {this.requestId,
      this.requestStatusCd,
      this.requestCreatedDt,
      this.requesterProduct,
      this.acceptorProduct});

  RequestDto.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    requestStatusCd = RequestStatusCd.codeToEnum(json['requestStatusCd']);
    requestCreatedDt = json['requestCreatedDt'];
    requesterProduct = json['requesterProduct'] != null
        ? ProductModel.fromJson(json['requesterProduct'])
        : null;
    acceptorProduct = json['acceptorProduct'] != null
        ? ProductModel.fromJson(json['acceptorProduct'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['requestStatusCd'] = requestStatusCd!.code.toString();
    data['requestCreatedDt'] = requestCreatedDt;
    if (requesterProduct != null) {
      data['requesterProduct'] = requesterProduct!.toJson();
    }
    if (acceptorProduct != null) {
      data['acceptorProduct'] = acceptorProduct!.toJson();
    }
    return data;
  }
}
