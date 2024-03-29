import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/request/request_page_response.dart';
import 'package:navada_mobile_app/src/models/request/requtest_dto_model.dart';

import '../exchange/exchange_single_response.dart';
import 'request_list_response.dart';

HttpClient _httpClient = HttpClient();

class RequestService {
  // 나에게 온 교환신청 리스트 조회
  Future<RequestPageResponse?> getRequestsForMe(int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/acceptor/$userId/exchange/requests?requestStatusCds=0&page=$pageNum',
        tokenYn: true);

    if (data['success']) {
      return RequestPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 나에게 온 교환신청 리스트 조회(거절한 요청 포함)
  Future<RequestPageResponse?> getRequestsForMeIncludingDenied(
      int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/acceptor/$userId/exchange/requests?requestStatusCds=0,2&page=$pageNum',
        tokenYn: true);

    if (data['success']) {
      return RequestPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 특정 상품으로부터 받은 교환신청 목록 조회
  Future<RequestListResponse> getRequestsByCertainProduct(
      int productId, int userId) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/product/$productId/exchange/request?userId=$userId',
        tokenYn: true);

    if (data['success']) {
      return RequestListResponse.fromJson(data);
    } else {
      throw Exception('getRequestsByCertainProduct() fail!');
    }
  }

  // 특정 상품에게 온 교환신청 목록 조회
  Future<RequestPageResponse> getRequestsforCertainProduct(
      int productId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/exchange/request/product/$productId?page=$pageNum',
        tokenYn: true);

    if (data['success']) {
      return RequestPageResponse.fromJson(data);
    } else {
      throw Exception('getRequestsforCertainProduct() fail!');
    }
  }

  // 내가 신청한 교환 목록 조회
  Future<RequestPageResponse?> getRequestsThatIApplied(
      int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/requester/$userId/exchange/requests?&page=$pageNum',
        tokenYn: true);

    if (data['success']) {
      return RequestPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 교환 신청 취소
  Future<bool> deleteRequest(int requestId) async {
    Map<String, dynamic> data =
        await _httpClient.deleteRequest('/exchange/request/$requestId',
        tokenYn: true);

    if (data['success']) {
      return true;
    } else {
      throw Exception('교환신청취소 실패');
    }
  }

  // 거절한 신청내역 삭제
  Future<RequestDto?> deleteDeniedRequestByAcceptor(int requestId) async {
    Map<String, dynamic> data = await _httpClient.patchRequest(
        '/exchange/request/$requestId/delete?isAcceptor=true', {},
        tokenYn: true);

    if (data['success']) {
      return RequestDto.fromJson(data['data']);
    } else {
      return null;
    }
  }

  // 거절당한 신청내역 삭제
  Future<RequestDto?> deleteDeniedRequestByRequester(int requestId) async {
    Map<String, dynamic> data = await _httpClient.patchRequest(
        '/exchange/request/$requestId/delete?isAcceptor=false', {},
        tokenYn: true);

    if (data['success']) {
      return RequestDto.fromJson(data['data']);
    } else {
      return null;
    }
  }

  //교환 신청
  Future<RequestDto?> createRequest(
      int requesterProductId, int acceptorProductId) async {
    Map<String, dynamic> data = await _httpClient.postRequest(
        '/exchange/request/$requesterProductId/$acceptorProductId', {},
        tokenYn: true);

    if (data['success']) {
      return RequestDto.fromJson(data['data']);
    } else {
      return null;
    }
  }

  //교환 신청 수락
  Future<ExchangeSingleResponse?> acceptRequest(int requestId) async {
    Map<String, dynamic> data = await _httpClient
        .postRequest('/exchange/request/$requestId', {}, tokenYn: true);

    if (data['success']) {
      return ExchangeSingleResponse.fromJson(data);
    } else {
      return null;
    }
  }

  //교환 신청 거절
  Future<bool> rejectRequest(int requestId) async {
    Map<String, dynamic> data = await _httpClient
        .patchRequest('/exchange/request/$requestId/reject', {}, tokenYn: true);

    if (data['success']) {
      return true;
    } else {
      return false;
    }
  }
}
