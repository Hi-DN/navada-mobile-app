import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/product/product_list_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';

HttpClient _httpClient = HttpClient();

// 상품 등록
Future<ProductModel?> createProduct(
    int userId, ProductParams productParams) async {
  Map<String, dynamic> data = await _httpClient.postRequest(
      '/user/$userId/product', productParams.toJson(),
      tokenYn: false);

  if (data['success']) {
    return ProductModel.fromJson(data['data']);
  } else {
    return null;
  }
}

// 상품 단건 조회
Future<ProductModel?> getProduct(int productId) async {
  Map<String, dynamic> data =
      await _httpClient.getRequest('/product/$productId', tokenYn: false);

  if (data['success']) {
    return ProductModel.fromJson(data['data']);
  } else {
    return null;
  }
}

// 상품 수정
Future<ProductModel?> modifyProduct(
    int productId, ProductParams productParams) async {
  Map<String, dynamic> data = await _httpClient.patchRequest(
      '/product/$productId', productParams.toJson(),
      tokenYn: false);

  if (data['success']) {
    return ProductModel.fromJson(data['data']);
  } else {
    return null;
  }
}

// 특정 상품에 교환신청 가능한 내 상품 목록
Future<ProductPageModel> getProductsForRequest(
    int userId, int acceptorProductId) async {
  Map<String, dynamic> data = await _httpClient.getRequest(
      '/user/$userId/products/request?acceptorProductId=$acceptorProductId',
      tokenYn: false);

  if (data['success']) {
    return ProductPageModel.fromJson(data);
  } else {
    throw Exception('getProductsForRequest() fail!');
  }
}
