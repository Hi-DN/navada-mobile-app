
class TokenDto {
  String? accessToken;
  String? refreshToken;
  int? userId;

  TokenDto({this.accessToken, this.refreshToken, this.userId});

  TokenDto.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['userId'] = userId;
    return data;
  }
}

class TokenParams {
  String? refreshToken;

  TokenParams({this.refreshToken});

  TokenParams.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refreshToken'] = refreshToken;
    return data;
  }
}
