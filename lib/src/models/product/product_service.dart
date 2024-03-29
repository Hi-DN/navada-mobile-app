import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:navada_mobile_app/src/models/api/http_client.dart';
import 'package:navada_mobile_app/src/models/product/product_list_model.dart';
import 'package:navada_mobile_app/src/models/product/product_model.dart';
import 'package:navada_mobile_app/src/models/product/product_search_page_model.dart';

HttpClient _httpClient = HttpClient();

class ProductService {
  // 상품 등록
  Future<ProductModel?> createProduct(
      int userId, ProductParams productParams, XFile? productImageFile) async {
    String uri = '${_httpClient.baseUrl}/user/$userId/product';
    return multipartRequest(uri, 'POST', productParams, productImageFile);
  }

  // 상품 수정
  Future<ProductModel?> modifyProduct(int productId,
      ProductParams productParams, XFile? productImageFile) async {
    String uri = '${_httpClient.baseUrl}/product/$productId';
    return multipartRequest(uri, 'PATCH', productParams, productImageFile);
  }

  Future<ProductModel?> multipartRequest(String uri, String method,
      ProductParams productParams, XFile? productImageFile) async {
    http.MultipartRequest request =
        http.MultipartRequest(method, Uri.parse(uri));

    try {
      request.headers['Authorization'] = HttpClient.accessToken;
      request.fields['productName'] = productParams.productName!;
      request.fields['productExplanation'] = productParams.productExplanation!;
      request.fields['categoryId'] = productParams.categoryId!.toString();
      request.fields['productCost'] = productParams.productCost!.toString();
      request.fields['exchangeCostRange'] =
          productParams.exchangeCostRange!.toString();
      request.fields['productImageUrl'] = (productParams.productImageUrl != null
          ? productParams.productImageUrl!.toString()
          : '');

      if (productImageFile != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
              'file', File(productImageFile.path).readAsBytesSync(),
              filename: productImageFile.name),
        );
      }

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 403) {
        await _httpClient.getNewAccessToken();

        request.headers['Authorization'] = HttpClient.accessToken;
        response = await http.Response.fromStream(await request.send());
      }

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      if (data['success']) {
        return ProductModel.fromJson(data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }

  // 상품 단건 조회
  Future<ProductDetailDto?> getProduct(int userId, int productId) async {
    Map<String, dynamic> data = await _httpClient
        .getRequest('/user/$userId/product/$productId', tokenYn: true);

    if (data['success']) {
      return ProductDetailDto.fromJson(data['data']);
    } else {
      return null;
    }
  }

  // 상품 삭제
  Future<bool> deleteProduct(int productId) async {
    Map<String, dynamic> data =
        await _httpClient.deleteRequest('/product/$productId', tokenYn: true);

    if (data['success']) {
      return true;
    } else {
      return false;
    }
  }

  // 사용자별 상품목록조회
  Future<ProductPageModel> getProductsByUser(int userId, int pageNum) async {
    Map<String, dynamic> data = await _httpClient
        .getRequest('/user/$userId/products?page=$pageNum', tokenYn: true);

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
        tokenYn: true);

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
        tokenYn: true);

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
        .getRequest('/user/$userId/products/search?$paramsStr', tokenYn: true);

    if (data['success']) {
      return ProductSearchPageModel.fromJson(data);
    } else {
      return null;
    }
  }
}
