import 'package:navada_mobile_app/src/models/page_model.dart';

import 'exchange_dto_model.dart';

class ExchangeDtoPageResponse extends PageModel<ExchangeDtoModel> {
  ExchangeDtoPageResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json['content'] != null) {
      content = <ExchangeDtoModel>[];
      json['content'].forEach((v) {
        content!.add(ExchangeDtoModel.fromJson(v));
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
