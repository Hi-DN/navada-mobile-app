class RequestDtoModel {
  RequestDtoModel({
    required this.success,
    required this.code,
    required this.message,
    required this.dataList,
  });
  late final bool success;
  late final int code;
  late final String message;
  late final List<RequestDtoContentModel> dataList;

  RequestDtoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    dataList = List.from(json['dataList'])
        .map((e) => RequestDtoContentModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['code'] = code;
    _data['message'] = message;
    _data['dataList'] = dataList.map((e) => e.toJson()).toList();
    return _data;
  }
}

class RequestDtoContentModel {
  RequestDtoContentModel({
    required this.requestId,
    required this.exchangeStatusCd,
    required this.acceptorNickname,
    required this.requesterNickName,
    required this.acceptorProductName,
    required this.requesterProductName,
    required this.acceptorProductCost,
    required this.requesterProductCost,
    required this.acceptorProductCostRange,
    required this.requesterProductCostRange,
  });
  late final int requestId;
  late final int exchangeStatusCd;
  late final String acceptorNickname;
  late final String requesterNickName;
  late final String acceptorProductName;
  late final String requesterProductName;
  late final int acceptorProductCost;
  late final int requesterProductCost;
  late final int acceptorProductCostRange;
  late final int requesterProductCostRange;

  RequestDtoContentModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    exchangeStatusCd = json['exchangeStatusCd'];
    acceptorNickname = json['acceptorNickname'];
    requesterNickName = json['requesterNickName'];
    acceptorProductName = json['acceptorProductName'];
    requesterProductName = json['requesterProductName'];
    acceptorProductCost = json['acceptorProductCost'];
    requesterProductCost = json['requesterProductCost'];
    acceptorProductCostRange = json['acceptorProductCostRange'];
    requesterProductCostRange = json['requesterProductCostRange'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['requestId'] = requestId;
    _data['exchangeStatusCd'] = exchangeStatusCd;
    _data['acceptorNickname'] = acceptorNickname;
    _data['requesterNickName'] = requesterNickName;
    _data['acceptorProductName'] = acceptorProductName;
    _data['requesterProductName'] = requesterProductName;
    _data['acceptorProductCost'] = acceptorProductCost;
    _data['requesterProductCost'] = requesterProductCost;
    _data['acceptorProductCostRange'] = acceptorProductCostRange;
    _data['requesterProductCostRange'] = requesterProductCostRange;
    return _data;
  }
}
