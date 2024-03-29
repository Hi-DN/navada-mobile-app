import 'package:navada_mobile_app/src/models/product/category/category_model.dart';

enum UserLevel {
  LV1_OUTSIDER(1, '외지인'),
  LV2_RESIDENT(2, '주민'),
  LV3_NATIVE(3, '토박이'),
  LV4_HEADMAN(4, '촌장');

  const UserLevel(this.level, this.label);

  final int level;
  final String label;

  static UserLevel strToEnum(String str) {
    return UserLevel.values.byName(str);
  }
}

enum ProductExchangeStatusCd {
  REGISTERED('0', '교환대기'),
  TRADING('1', '교환중'),
  COMPLETED('2', '교환완료');

  const ProductExchangeStatusCd(this.code, this.label);

  final String code;
  final String label;

  static ProductExchangeStatusCd strToEnum(String str) {
    return ProductExchangeStatusCd.values.byName(str);
  }

  static ProductExchangeStatusCd codeToEnum(String code) {
    return ProductExchangeStatusCd.values[int.parse(code)];
  }
}

enum RequestStatusCd {
  WAIT('0', '대기'),
  ACCEPTED('1', '수락'),
  DENIED('2', '거절');

  const RequestStatusCd(this.code, this.label);

  final String code;
  final String label;

  static RequestStatusCd strToEnum(String str) {
    return RequestStatusCd.values.byName(str);
  }

  static RequestStatusCd codeToEnum(String code) {
    return RequestStatusCd.values[int.parse(code)];
  }
}

enum ExchangeStatusCd {
  TRADING('1', '교환중'),
  COMPLETED('2', '교환완료'),
  CANCELED('3', '교환취소');

  const ExchangeStatusCd(this.code, this.label);

  final String code;
  final String label;

  static ExchangeStatusCd strToEnum(String str) {
    return ExchangeStatusCd.values.byName(str);
  }

  static ExchangeStatusCd codeToEnum(String code) {
    return ExchangeStatusCd.values[int.parse(code) - 1];
  }
}

enum Category {
  GIFTICON(1, '기프티콘'),
  ELECTRONIC_DEVICES(2, '전자기기'),
  FURNITURE(3, '가구'),
  BABY_STUFF(4, '유아용품'),
  SPORTS(5, '스포츠'),
  FOOD(6, '식품'),
  HOBBY(7, '취미용품'),
  BEAUTY(8, '미용'),
  FEMALE_CLOTHES(9, '여성의류'),
  MALE_CLOTHES(10, '남성의류'),
  PET_STUFF(11, '반려동물'),
  BOOKS(12, '도서'),
  TOYS(13, '장난감'),
  PLANT(14, '식물'),
  ETC(15, '기타');

  const Category(this.id, this.label);

  final int id;
  final String label;

  static Category idToEnum(int id) {
    return Category.values[id - 1];
  }

  static Category objToEnum(CategoryModel categoryModel) {
    return Category.idToEnum(categoryModel.categoryId!);
  }

  static CategoryModel enumToObj(Category category) {
    return CategoryModel(categoryId: category.id, categoryName: category.label);
  }

  static String idToLabel(int id) {
    return Category.values[id - 1].label;
  }

  static int labelToId(String label) {
    return Category.values.firstWhere((c) => c.label == label).id;
  }
}

enum DataState {
  UNINITIALIZED,
  REFRESHING,
  INITIAL_FETCHING,
  MORE_FETCHING,
  FETCHED,
  NO_MORE_DATA,
  ERROR
}

enum SignInPlatform {
  KAKAO,
  GOOGLE,
  NAVER,
  NONE;

  static SignInPlatform strToEnum(String str) {
    return SignInPlatform.values.byName(str);
  }
}

enum NotificationType {
  ACCEPTED_NOTI('교환 수락 알림'),
  DENIED_NOTI('교환 거절 알림'),
  COMPLETE_NOTI('교환 완료 알림'),
  PERIODIC_COMPLETE_NOTI('교환 완료 요청'),
  PRODUCT_DELETION_NOTI('요청 취소 알림'),
  EXCHANGE_CANCELED_NOTI('교환 취소 알림');

  const NotificationType(this.label);
  final String label;

  static NotificationType strToEnum(String str) {
    return NotificationType.values.byName(str);
  }
}
