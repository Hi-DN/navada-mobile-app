import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class ExchangeDtoModel {
  int? exchangeId;
  int? requesterId;
  int? acceptorId;
  bool? requesterConfirmYn;
  bool? acceptorConfirmYn;
  double? requesterRating;
  double? acceptorRating;
  ProductModel? acceptorProduct;
  ProductModel? requesterProduct;
  ExchangeStatusCd? exchangeStatusCd;
  DateTime? exchangeCompleteDt;

  ExchangeDtoModel(
      {this.exchangeId,
      this.requesterId,
      this.acceptorId,
      this.requesterConfirmYn,
      this.acceptorConfirmYn,
      this.acceptorProduct,
      this.requesterProduct,
      this.exchangeStatusCd,
      this.exchangeCompleteDt});

  ExchangeDtoModel.fromJson(Map<String, dynamic> json) {
    exchangeId = json['exchangeId'];
    requesterId = json['requesterId'];
    acceptorId = json['acceptorId'];
    requesterConfirmYn = json['requesterConfirmYn'];
    acceptorConfirmYn = json['acceptorConfirmYn'];
    requesterRating = json['requesterRating'];
    acceptorRating = json['acceptorRating'];
    acceptorProduct = json['acceptorProduct'] != null
        ? ProductModel.fromJson(json['acceptorProduct'])
        : null;
    requesterProduct = json['requesterProduct'] != null
        ? ProductModel.fromJson(json['requesterProduct'])
        : null;
    exchangeStatusCd = ExchangeStatusCd.codeToEnum(json['exchangeStatusCd']);
    exchangeCompleteDt = json['exchangeCompleteDt'] != null
        ? DateTime.parse(json['exchangeCompleteDt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exchangeId'] = exchangeId;
    data['requesterId'] = requesterId;
    data['acceptorId'] = acceptorId;
    data['requesterConfirmYn'] = requesterConfirmYn;
    data['acceptorConfirmYn'] = acceptorConfirmYn;
    data['requesterRating'] = requesterConfirmYn;
    data['acceptorRating'] = acceptorRating;
    if (acceptorProduct != null) {
      data['acceptorProduct'] = acceptorProduct!.toJson();
    }
    if (requesterProduct != null) {
      data['requesterProduct'] = requesterProduct!.toJson();
    }
    data['exchangeStatusCd'] = exchangeStatusCd!.code.toString();
    data['exchangeCompleteDt'] = exchangeCompleteDt;
    return data;
  }
}
