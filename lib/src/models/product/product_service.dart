import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/product/product_list_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';

HttpClient _httpClient = HttpClient();

class ProductService {
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
}

Future<ProductSearchPageModel?> searchProducts(
    int? userId,
    String? productName,
    List<int>? categoryIds,
    int? lowerCostBound,
    int? upperCostBound,
    String? sort) async {
  String productNameOpt =
      productName != null ? '&productName=$productName' : '';
  String categoryOpt = categoryIds != null ? '&categoryIds=$categoryIds' : '';
  String lowerCostOpt =
      lowerCostBound != null ? '&lowerCostBound=$lowerCostBound' : '';
  String upperCostOpt =
      upperCostBound != null ? '&upperCostBound=$upperCostBound' : '';

  Map<String, dynamic> data = await _httpClient.getRequest(
      '/user/$userId/products/search?$productNameOpt$categoryOpt$lowerCostOpt$upperCostOpt&sort=$sort',
      tokenYn: false);

  if (data['success']) {
    return ProductSearchPageModel.fromJson(data);
  } else {
    return null;
  }
}
