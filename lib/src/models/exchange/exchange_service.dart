import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_model.dart';

HttpClient _httpClient = HttpClient();

// 교환중/교환완료인 교환 조회
Future<ExchangePageResponse?> getExchangeList(int userId, int pageNum) async {
  Map<String, dynamic> data = await _httpClient.getRequest(
      '/user/$userId/exchanges?page=$pageNum',
      tokenYn: false);

  if (data['success']) {
    return ExchangePageResponse.fromJson(data);
  } else {
    return null;
  }
}