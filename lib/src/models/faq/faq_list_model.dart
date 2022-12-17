class FAQListModel {
  FAQListModel({
    required this.success,
    required this.code,
    required this.message,
    required this.dataList,
  });
  late final bool success;
  late final int code;
  late final String message;
  late final List<FAQ> dataList;

  FAQListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    dataList = List.from(json['dataList']).map((e) => FAQ.fromJson(e)).toList();
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

class FAQ {
  FAQ({
    required this.faqId,
    required this.faqQuestion,
    required this.faqAnswer,
  });
  late final int faqId;
  late final String faqQuestion;
  late final String faqAnswer;

  FAQ.fromJson(Map<String, dynamic> json) {
    faqId = json['faqId'];
    faqQuestion = json['faqQuestion'];
    faqAnswer = json['faqAnswer'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['faqId'] = faqId;
    data['faqQuestion'] = faqQuestion;
    data['faqAnswer'] = faqAnswer;
    return data;
  }
}
