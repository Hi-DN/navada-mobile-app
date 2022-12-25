import 'package:navada_mobile_app/src/utilities/enums.dart';

class UserModel {
  UserModel({
    required this.success,
    required this.code,
    required this.message,
    required this.user,
  });
  late final bool success;
  late final int code;
  late final String message;
  late final User user;

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    user = User.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    data['data'] = user.toJson();
    return data;
  }
}

class User {
  User({
    this.createdDate,
    this.modifiedDate,
    this.userId,
    this.userName,
    this.userNickname,
    this.userEmail,
    this.userPhoneNum,
    this.userAddress,
    this.userLevel,
    this.userRating,
    this.userTradeCount,
    this.userRatingCount,
    this.signinPlatform,
  });
  late String? createdDate;
  late String? modifiedDate;
  late int? userId;
  late String? userName;
  late String? userNickname;
  late String? userEmail;
  late String? userPhoneNum;
  late String? userAddress;
  late UserLevel? userLevel;
  late double? userRating;
  late int? userTradeCount;
  late int? userRatingCount;
  late SigninPlatform? signinPlatform;

  User.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    userId = json['userId'];
    userName = json['userName'];
    userNickname = json['userNickname'];
    userPhoneNum = json['userPhoneNum'];
    userAddress = json['userAddress'];
    userLevel = UserLevel.strToEnum(json['userLevel']);
    userRating = json['userRating'];
    userTradeCount = json['userTradeCount'];
    userRatingCount = json['userRatingCount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['userId'] = userId;
    data['userName'] = userName;
    data['userNickname'] = userNickname;
    data['userPhoneNum'] = userPhoneNum;
    data['userAddress'] = userAddress;
    data['userLevel'] = userLevel!.name;
    data['userRating'] = userRating;
    data['userTradeCount'] = userTradeCount;
    data['userRatingCount'] = userRatingCount;
    return data;
  }
}

class UserDto {
  UserDto({
    required this.userId,
    required this.userName,
    required this.userNickname,
    required this.userPhoneNum,
    required this.userAddress,
    required this.userLevel,
    required this.userRating,
    required this.userTradeCount,
    required this.userRatingCount,
  });
  late final int userId;
  late final String userName;
  late final String userNickname;
  late final String userPhoneNum;
  late final String userAddress;
  late final UserLevel userLevel;
  late final double userRating;
  late final int userTradeCount;
  late final int userRatingCount;

  UserDto.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userNickname = json['userNickname'];
    userPhoneNum = json['userPhoneNum'];
    userAddress = json['userAddress'];
    userLevel = UserLevel.strToEnum(json['userLevel']);
    userRating = json['userRating'];
    userTradeCount = json['userTradeCount'];
    userRatingCount = json['userRatingCount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['userNickname'] = userNickname;
    data['userPhoneNum'] = userPhoneNum;
    data['userAddress'] = userAddress;
    data['userLevel'] = userLevel.name;
    data['userRating'] = userRating;
    data['userTradeCount'] = userTradeCount;
    data['userRatingCount'] = userRatingCount;
    return data;
  }
}

class UserParams {
  UserParams({
    required this.userName,
    required this.userNickname,
    required this.userPhoneNum,
    required this.userAddress,
    required this.userEmail,
    required this.signinPlatform
  });
  late final String userName;
  late final String userNickname;
  late final String userEmail;
  late final String userPhoneNum;
  late final String userAddress;
  late final SigninPlatform signinPlatform;

  UserParams.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userNickname = json['userNickname'];
    userEmail = json['userEmail'];
    userPhoneNum = json['userPhoneNum'];
    userAddress = json['userAddress'];
    signinPlatform = SigninPlatform.strToEnum(json['signinPlatform']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userName'] = userName;
    data['userNickname'] = userNickname;
    data['userEmail'] = userEmail;
    data['userPhoneNum'] = userPhoneNum;
    data['userAddress'] = userAddress;
    data['signinPlatform'] = signinPlatform.name;
    return data;
  }
}
