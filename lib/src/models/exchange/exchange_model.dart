import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/utilities/enums.dart';

class Exchange {
  String? createdDate;
  String? modifiedDate;
  int? exchangeId;
  ProductModel? acceptorProduct;
  ProductModel? requesterProduct;
  bool? acceptorConfirmYn;
  bool? requesterConfirmYn;
  ExchangeStatusCd? exchangeStatusCd;
  String? exchangeCompleteDt;
  double? acceptorRating;
  double? requesterRating;
  bool? acceptorHistoryDeleteYn;
  bool? requesterHistoryDeleteYn;

  Exchange(
      {this.createdDate,
      this.modifiedDate,
      this.exchangeId,
      this.acceptorProduct,
      this.requesterProduct,
      this.acceptorConfirmYn,
      this.requesterConfirmYn,
      this.exchangeStatusCd,
      this.exchangeCompleteDt,
      this.acceptorRating,
      this.requesterRating,
      this.acceptorHistoryDeleteYn,
      this.requesterHistoryDeleteYn});

  Exchange.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    exchangeId = json['exchangeId'];
    acceptorProduct = json['acceptorProduct'] != null
        ? ProductModel.fromJson(json['acceptorProduct'])
        : null;
    requesterProduct = json['requesterProduct'] != null
        ? ProductModel.fromJson(json['requesterProduct'])
        : null;
    acceptorConfirmYn = json['acceptorConfirmYn'];
    requesterConfirmYn = json['requesterConfirmYn'];
    exchangeStatusCd = ExchangeStatusCd.codeToEnum(json['exchangeStatusCd']);
    exchangeCompleteDt = json['exchangeCompleteDt'];
    acceptorRating = json['acceptorRating'];
    requesterRating = json['requesterRating'];
    acceptorHistoryDeleteYn = json['acceptorHistoryDeleteYn'];
    requesterHistoryDeleteYn = json['requesterHistoryDeleteYn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['exchangeId'] = exchangeId;
    if (acceptorProduct != null) {
      data['acceptorProduct'] = acceptorProduct!.toJson();
    }
    if (requesterProduct != null) {
      data['requesterProduct'] = requesterProduct!.toJson();
    }
    data['acceptorConfirmYn'] = acceptorConfirmYn;
    data['requesterConfirmYn'] = requesterConfirmYn;
    data['exchangeCompleteDt'] = exchangeCompleteDt;
    data['exchangeStatusCd'] = exchangeStatusCd!.code.toString();
    data['acceptorRating'] = acceptorRating;
    data['requesterRating'] = requesterRating;
    data['acceptorHistoryDeleteYn'] = acceptorHistoryDeleteYn;
    data['requesterHistoryDeleteYn'] = requesterHistoryDeleteYn;

    return data;
  }
}
