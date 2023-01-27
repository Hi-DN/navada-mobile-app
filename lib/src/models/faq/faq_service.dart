import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/faq/faq_list_model.dart';

final HttpClient _httpClient = HttpClient();

class FAQService {
  // 전체 FAQ 조회
  Future<FAQListModel> getFAQList() async {
    Map<String, dynamic> data =
        await _httpClient.getRequest('/faqs', tokenYn: true);

    if (data['success']) {
      return FAQListModel.fromJson(data);
    } else {
      throw Exception('FAQs 조회 실패!');
    }
  }
}
