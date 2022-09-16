import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_dto_model.dart';
import 'package:navada_mobile_app/src/models/exchange/exchange_model.dart';

HttpClient _httpClient = HttpClient();

class ExchangeService {
  // 교환중/교환완료인 교환 조회
  Future<ExchangeDtoPageResponse?> getExchangeList(int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/user/$userId/exchanges?page=$pageNum',
        tokenYn: false);

    if (data['success']) {
      return ExchangeDtoPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 교환중/교환완료인 교환 조회(내가 신청한것만 보기)
  Future<ExchangeDtoPageResponse?> getExchangeListViewOnlySent(int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/user/$userId/exchanges?viewOnlySentElseGot=true&page=$pageNum',
        tokenYn: false);

    if (data['success']) {
      return ExchangeDtoPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 교환중/교환완료인 교환 조회(신청받은것만 보기)
  Future<ExchangeDtoPageResponse?> getExchangeListViewOnlyGot(int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/user/$userId/exchanges?viewOnlySentElseGot=false&page=$pageNum',
        tokenYn: false);

    if (data['success']) {
      return ExchangeDtoPageResponse.fromJson(data);
    } else {
      return null;
    }
  }

  // 교환완료내역 삭제
  Future<ExchangeModel?> deleteCompletedExchange(int exchangeId, bool isAcceptor) async {
    Map<String, dynamic> data = await _httpClient.patchRequest(
        '/exchange/$exchangeId/delete?isAcceptor=$isAcceptor', {}, tokenYn: false);

    if (data['success']) {
      return ExchangeModel.fromJson(data['data']);
    } else {
      return null;
    }
  }

  // 별점부여
  Future<ExchangeModel?> rateExchange(int exchangeId, bool isAcceptor, double rating) async {
    Map<String, dynamic> data = await _httpClient.patchRequest(
        '/exchange/$exchangeId/rate?isAcceptor=$isAcceptor&rating=$rating', {}, tokenYn: false);

    if (data['success']) {
      return ExchangeModel.fromJson(data['data']);
    } else {
      return null;
    }
  }

  // 교환완료
  Future<ExchangeModel?> completeExchange(int exchangeId, bool isAcceptor) async {
    Map<String, dynamic> data = await _httpClient.patchRequest(
        '/exchange/$exchangeId?isAcceptor=$isAcceptor', {}, tokenYn: false);

    if (data['success']) {
      return ExchangeModel.fromJson(data['data']);
    } else {
      return null;
    }
  }
}

