import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:navada_mobile_app/main.dart';
import 'package:navada_mobile_app/src/models/api/token/token_dto.dart';
import 'package:navada_mobile_app/src/screens/signin/signin.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  // final String baseUrl = 'http://localhost:8080/v1';

  final String baseUrl = 'http://172.30.1.49:8080/v1';

  static String accessToken = '';
  static String refreshToken = '';

  static void setAccessToken(String token) {
    accessToken = token;
  }

  static void setRefreshToken(String token) {
    refreshToken = token;
  }

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal();

  Future<Map<String, dynamic>> getRequest(String url,
      {bool tokenYn = false}) async {
    http.Response response;
    try {
      if (tokenYn) {
        var headers = {"Authorization": accessToken};
        response = await http.get(Uri.parse(baseUrl + url), headers: headers);
      } else {
        response = await http.get(Uri.parse(baseUrl + url));
      }
      _printResponseToApiRequest(response, url);

      if (response.statusCode == 403) {
        await getNewAccessToken();
        var headers = {"Authorization": accessToken};
        response = await http.get(Uri.parse(baseUrl + url), headers: headers);
      }

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body,
      {bool tokenYn = false}) async {
    http.Response response;
    Map<String, String> headers;

    try {
      if (tokenYn) {
        headers = {
          'Content-Type': 'application/json',
          'Authorization': accessToken
        };
      } else {
        headers = {'Content-Type': 'application/json'};
      }
      response = await http.post(Uri.parse(baseUrl + url),
          body: jsonEncode(body), headers: headers);

      _printResponseToApiRequest(response, url);

      if (response.statusCode == 403) {
        await getNewAccessToken();

        var headers = {"Authorization": accessToken};
        response = await http.post(Uri.parse(baseUrl + url),
            body: jsonEncode(body), headers: headers);
      }

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> putRequest(String url, Map<String, dynamic> body,
      {bool tokenYn = false}) async {
    http.Response response;
    Map<String, String> headers;
    try {
      if (tokenYn) {
        headers = {
          'Content-Type': 'application/json',
          'Authorization': accessToken
        };
      } else {
        headers = {'Content-Type': 'application/json'};
      }
      response = await http.put(Uri.parse(baseUrl + url),
          headers: headers, body: jsonEncode(body));

      _printResponseToApiRequest(response, url);

      if (response.statusCode == 403) {
        await getNewAccessToken();

        var headers = {"Authorization": accessToken};
        response = await http.put(Uri.parse(baseUrl + url),
            headers: headers, body: jsonEncode(body));
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> deleteRequest(String url,
      {bool tokenYn = false}) async {
    http.Response response;
    Map<String, String> headers;

    try {
      if (tokenYn) {
        headers = {
          'Content-Type': 'application/json',
          'Authorization': accessToken
        };
      } else {
        headers = {'Content-Type': 'application/json'};
      }
      response = await http.delete(Uri.parse(baseUrl + url), headers: headers);

      _printResponseToApiRequest(response, url);

      if (response.statusCode == 403) {
        await getNewAccessToken();

        var headers = {"Authorization": accessToken};
        response =
            await http.delete(Uri.parse(baseUrl + url), headers: headers);
      }

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> patchRequest(
      String url, Map<String, dynamic> body,
      {bool tokenYn = false}) async {
    http.Response response;
    Map<String, String> headers;

    try {
      if (tokenYn) {
        headers = {
          'Content-Type': 'application/json',
          'Authorization': accessToken
        };
      } else {
        headers = {'Content-Type': 'application/json'};
      }
      response = await http.patch(Uri.parse(baseUrl + url),
          headers: headers, body: jsonEncode(body));

      _printResponseToApiRequest(response, url);

      if (response.statusCode == 403) {
        await getNewAccessToken();

        var headers = {"Authorization": accessToken};
        response = await http.patch(Uri.parse(baseUrl + url),
            headers: headers, body: jsonEncode(body));
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> getNewAccessToken() async {
    try {
      Map<String, dynamic> data =
          await postRequest("/refresh", {"refreshToken": refreshToken});
      TokenDto token = TokenDto.fromJson(data['data']);
      setAccessToken(token.accessToken!);
    } catch (e) {
      //Refresh Token Timed Out => 로그인 요청
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(SignIn.routeName, (route) => false);
    }
  }

  void _printResponseToApiRequest(http.Response response, String url) {
    debugPrint('url : ${baseUrl + url}');
    debugPrint('statusCode : ${response.statusCode}');
    printJson(utf8.decode(response.bodyBytes));
  }

  static void printJson(String input) {
    var decoded = const JsonDecoder().convert(input);
    var reformatted = const JsonEncoder.withIndent(' ').convert(decoded);
    debugPrint('response body : $reformatted');
  }
}
