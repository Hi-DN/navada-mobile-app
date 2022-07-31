import 'package:navada_mobile_app/src/business_logic/api/http_client.dart';
import 'package:navada_mobile_app/src/business_logic/product/product_model.dart';

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
