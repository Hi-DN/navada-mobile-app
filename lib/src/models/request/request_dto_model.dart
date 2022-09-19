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
    final data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    data['dataList'] = dataList.map((e) => e.toJson()).toList();
    return data;
  }
}

class RequestDtoContentModel {
  RequestDtoContentModel({
    required this.requestId,
    required this.requestStatusCd,
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
  late final int requestStatusCd;
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
    requestStatusCd = json['requestStatusCd'];
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
    final data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['requestStatusCd'] = requestStatusCd;
    data['acceptorNickname'] = acceptorNickname;
    data['requesterNickName'] = requesterNickName;
    data['acceptorProductName'] = acceptorProductName;
    data['requesterProductName'] = requesterProductName;
    data['acceptorProductCost'] = acceptorProductCost;
    data['requesterProductCost'] = requesterProductCost;
    data['acceptorProductCostRange'] = acceptorProductCostRange;
    data['requesterProductCostRange'] = requesterProductCostRange;
    return data;
  }
}
