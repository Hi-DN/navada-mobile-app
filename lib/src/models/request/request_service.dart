import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/request/request_dto_model.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';

HttpClient _httpClient = HttpClient();

// 나에게 온 교환신청 리스트 조회
Future<PageResponse?> getRequestsForMe(int userId, int pageNum) async {
  Map<String, dynamic> data = await _httpClient.getRequest(
      '/acceptor/$userId/exchange/requests?exchangeStatusCd=0&page=$pageNum',
      tokenYn: false);

  if (data['success']) {
    return PageResponse.fromJson(data);
  } else {
    return null;
  }
}

// 나에게 온 교환신청 리스트 조회(거절한 요청 포함)
Future<PageResponse?> getRequestsForMeIncludingDenied(
    int userId, int pageNum) async {
  Map<String, dynamic> data = await _httpClient.getRequest(
      '/acceptor/$userId/exchange/requests?exchangeStatusCd=0,2&page=$pageNum',
      tokenYn: false);

  if (data['success']) {
    return PageResponse.fromJson(data);
  } else {
    return null;
  }
}

//특정 상품으로부터 받은 교환신청 목록 조회
Future<RequestDtoModel> getRequestsByCertainProduct(
    int productId, int userId) async {
  Map<String, dynamic> data = await _httpClient.getRequest(
      '/product/$productId/exchange/request?userId=$userId',
      tokenYn: false);

  if (data['success']) {
    return RequestDtoModel.fromJson(data);
  } else {
    throw Exception('getRequestsByCertainProduct() fail!');
  }
}
