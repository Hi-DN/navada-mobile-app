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
  Future<ProductDetailDto?> getProduct(int userId, int productId) async {
    Map<String, dynamic> data = await _httpClient
        .getRequest('/user/$userId/product/$productId', tokenYn: false);

    if (data['success']) {
      return ProductDetailDto.fromJson(data['data']);
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

  // 상품 삭제
  Future<bool> deleteProduct(int productId) async {
    Map<String, dynamic> data =
        await _httpClient.deleteRequest('/product/$productId', tokenYn: false);

    if (data['success']) {
      return true;
    } else {
      return false;
    }
  }

  // 사용자별 상품목록조회
  Future<ProductPageModel> getProductsByUser(int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient
        .getRequest('/user/$userId/products?page=$pageNum', tokenYn: false);

    if (data['success']) {
      return ProductPageModel.fromJson(data);
    } else {
      throw Exception('getProductsForRequest() fail!');
    }
  }

  // 사용자별 상품목록조회
  Future<ProductPageModel> getProductsByUserWithStatusCd(
      int userId, int statusCd, int pageNum) async {
    Map<String, dynamic> data = await _httpClient.getRequest(
        '/user/$userId/products?page=$pageNum&productExchangeStatusCds=$statusCd',
        tokenYn: false);

    if (data['success']) {
      return ProductPageModel.fromJson(data);
    } else {
      throw Exception('getProductsForRequest() fail!');
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

  // 상품검색
  Future<ProductSearchPageModel?> searchProducts(
      int? userId,
      String? productName,
      List<int> categoryIds,
      int? lowerCostBound,
      int? upperCostBound,
      bool? isMyProductIncluded,
      List<int> productExchangeStatusCds,
      String? sort,
      int? pageNum) async {
    String productNameStr =
        productName != null ? '&productName=$productName' : '';
    String categoryStr = categoryIds.isNotEmpty
        ? '&categoryIds=${categoryIds.toString().substring(1, categoryIds.toString().length - 1).replaceAll(' ', '')}'
        : '';
    String lowerCostStr =
        lowerCostBound != null ? '&lowerCostBound=$lowerCostBound' : '';
    String upperCostStr =
        upperCostBound != null ? '&upperCostBound=$upperCostBound' : '';
    String myProductIncludedStr = isMyProductIncluded != null
        ? '&isMyProductIncluded=$isMyProductIncluded'
        : '&isMyProductIncluded=true';
    String exchangeStatusCdStr = productExchangeStatusCds.isNotEmpty
        ? '&productExchangeStatusCds=${productExchangeStatusCds.toString().substring(1, productExchangeStatusCds.toString().length - 1).replaceAll(' ', '')}'
        : '';
    String sortStr = sort != null ? '&sort=$sort' : '';
    pageNum ??= 0;

    String paramsStr =
        '$productNameStr$categoryStr$lowerCostStr$upperCostStr$myProductIncludedStr$exchangeStatusCdStr$sortStr&page=$pageNum';

    Map<String, dynamic> data = await _httpClient
        .getRequest('/user/$userId/products/search?$paramsStr', tokenYn: false);

    if (data['success']) {
      return ProductSearchPageModel.fromJson(data);
    } else {
      return null;
    }
  }
}
