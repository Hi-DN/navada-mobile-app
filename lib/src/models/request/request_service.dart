import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/request/request_dto_model.dart';
import 'package:navada_mobile_app/src/models/request/request_model.dart';

import '../exchange/exchange_model.dart';

HttpClient _httpClient = HttpClient();

class RequestService {
  // 나에게 온 교환신청 리스트 조회
  Future<RequestPageResponse?> getRequestsForMe(int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/acceptor/$userId/exchange/requests?requestStatusCds=0&page=$pageNum',
        tokenYn: false);

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
        tokenYn: false);

    if (data['success']) {
      return RequestPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 특정 상품으로부터 받은 교환신청 목록 조회
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

  // 내가 신청한 교환 목록 조회
  Future<RequestPageResponse?> getRequestsThatIApplied(
      int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/requester/$userId/exchange/requests?&page=$pageNum',
        tokenYn: false);

    if (data['success']) {
      return RequestPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 교환 신청 취소
  Future<bool> deleteRequest(int requestId) async {
    Map<String, dynamic> data =
        await _httpClient.deleteRequest('/exchange/request/$requestId');

    if (data['success']) {
      return true;
    } else {
      throw Exception('교환신청취소 실패');
    }
  }

  // 거절한 신청내역 삭제
  Future<RequestModel?> deleteDeniedRequestByAcceptor(int requestId) async {
    Map<String, dynamic> data = await _httpClient.patchRequest(
        '/exchange/request/$requestId/delete?isAcceptor=true', {},
        tokenYn: false);

    if (data['success']) {
      return RequestModel.fromJson(data['data']);
    } else {
      return null;
    }
  }

  // 거절당한 신청내역 삭제
  Future<RequestModel?> deleteDeniedRequestByRequester(int requestId) async {
    Map<String, dynamic> data = await _httpClient.patchRequest(
        '/exchange/request/$requestId/delete?isAcceptor=false', {},
        tokenYn: false);

    if (data['success']) {
      return RequestModel.fromJson(data['data']);
    } else {
      return null;
    }
  }

  //교환 신청
  Future<RequestModel?> createRequest(
      int requesterProductId, int acceptorProductId) async {
    Map<String, dynamic> data = await _httpClient.postRequest(
        '/exchange/request/$requesterProductId/$acceptorProductId', {},
        tokenYn: false);

    if (data['success']) {
      return RequestModel.fromJson(data['data']);
    } else {
      return null;
    }
  }

  //교환 신청 수락
  Future<ExchangeModel?> acceptRequest(int requestId) async {
    Map<String, dynamic> data = await _httpClient
        .postRequest('/exchange/request/$requestId', {}, tokenYn: false);

    if (data['success']) {
      return ExchangeModel.fromJson(data);
    } else {
      return null;
    }
  }

  //교환 신청 거절
  Future<bool> rejectRequest(int requestId) async {
    Map<String, dynamic> data = await _httpClient
        .patchRequest('/exchange/request/$requestId/reject', {}, tokenYn: false);

    if (data['success']) {
      return true;
    } else {
      return false;
    }
  }
}
