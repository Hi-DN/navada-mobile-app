import 'package:navada_mobile_app/src/models/product/product_model.dart';

class ExchangeModel {
  bool? success;
  int? code;
  String? message;
  Exchange? data;

  ExchangeModel({this.success, this.code, this.message, this.data});

  ExchangeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Exchange.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Exchange {
  String? createdDate;
  String? modifiedDate;
  int? exchangeId;
  ProductModel? acceptorProduct;
  ProductModel? requesterProduct;
  bool? acceptorConfirmYn;
  bool? requesterConfirmYn;
  bool? exchangeCompleteYn;
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
      this.exchangeCompleteYn,
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
    exchangeCompleteYn = json['exchangeCompleteYn'];
    exchangeCompleteDt = json['exchangeCompleteDt'];
    acceptorRating = json['acceptorRating'];
    requesterRating = json['requesterRating'];
    acceptorHistoryDeleteYn = json['acceptorHistoryDeleteYn'];
    requesterHistoryDeleteYn = json['requesterHistoryDeleteYn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['exchangeCompleteYn'] = exchangeCompleteYn;
    data['exchangeCompleteDt'] = exchangeCompleteDt;
    data['acceptorRating'] = acceptorRating;
    data['requesterRating'] = requesterRating;
    data['acceptorHistoryDeleteYn'] = acceptorHistoryDeleteYn;
    data['requesterHistoryDeleteYn'] = requesterHistoryDeleteYn;

    return data;
  }
}
