class UserModel {
  int? userId;
  String? userName;
  String? userNickname;
  String? userEmail;
  String? userPassword;
  String? userPhoneNum;
  String? userAddress;
  String? userLevel;
  double? userRating;
  int? userTradeCount;
  int? userRatingCount;

  UserModel(
      this.userId,
      this.userName,
      this.userNickname,
      this.userEmail,
      this.userPassword,
      this.userPhoneNum,
      this.userAddress,
      this.userLevel,
      this.userRating,
      this.userTradeCount,
      this.userRatingCount);

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['username'];
    userNickname = json['userNickname'];
    userEmail = json['userEmail'];
    userPassword = json['userPassword'];
    userPhoneNum = json['userPhoneNum'];
    userAddress = json['userAddress'];
    userLevel = json['userLevel'];
    userTradeCount = json['userTradeCount'];
    userRatingCount = json['userRatingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['userNickname'] = userNickname;
    data['userEmail'] = userEmail;
    data['userPassword'] = userPassword;
    data['userPhoneNum'] = userPhoneNum;
    data['userAddress'] = userAddress;
    data['userLevel'] = userLevel;
    data['userTradeCount'] = userTradeCount;
    data['userRatingCount'] = userRatingCount;
    return data;
  }

  @override
  String toString() {
    return 'User{userId: $userId, userNickname: $userNickname}';
  }
}
