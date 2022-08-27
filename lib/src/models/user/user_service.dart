import 'package:navada_mobile_app/src/models/user/user_model.dart';

import '../api/http_client.dart';

HttpClient _httpClient = HttpClient();

Future<UserModel> getUserByProductId(int productId) async {
  Map<String, dynamic> data =
      await _httpClient.getRequest('/user?productId=$productId');

  if (data['success']) {
    return UserModel.fromJson(data);
  } else {
    throw Exception('getUserByProductId() fail!');
  }
}
