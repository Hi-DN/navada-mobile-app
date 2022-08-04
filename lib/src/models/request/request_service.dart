import 'package:navada_mobile_app/src/models/request/request_model.dart';
import 'package:navada_mobile_app/src/models/api/http_client.dart';

HttpClient _httpClient = HttpClient();

// 나에게 온 교환신청 리스트 조회
Future<PageResponse?> getRequestsForMe(int userId, int pageNum) async {
  Map<String, dynamic> data =
      await _httpClient.getRequest('/acceptor/$userId/exchange/requests?exchangeStatusCd=0&page=$pageNum', tokenYn: false);

  if (data['success']) {
    return PageResponse.fromJson(data);
  } else {
    return null;
  }
}

// 나에게 온 교환신청 리스트 조회(거절한 요청 포함)
Future<PageResponse?> getRequestsForMeIncludingDenied(int userId, int pageNum) async {
  Map<String, dynamic> data =
      await _httpClient.getRequest('/acceptor/$userId/exchange/requests?exchangeStatusCd=0,2&page=$pageNum', tokenYn: false);

  if (data['success']) {
    return PageResponse.fromJson(data);
  } else {
    return null;
  }
}
