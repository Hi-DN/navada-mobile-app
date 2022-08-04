import 'package:navada_mobile_app/src/models/product/category/category_model.dart';

enum UserLevel { 
  LV1_OUTSIDER(1,'외지인'), 
  LV2_RESIDENT(2,'주민'), 
  LV3_NATIVE(3,'토박이'), 
  LV4_HEADMAN(4,'촌장'); 

  const UserLevel(this.level, this.label);

  final int level;
  final String label;

  static UserLevel strToEnum(String str) {
    return UserLevel.values.byName(str);
  }
}

enum ProductStatusCd {
  REGISTERED(0,'등록'),     
  TRADING(1,'거래중'),        
  TRADE_COMPLETED(2,'거래완료');

  const ProductStatusCd(this.code, this.label);

  final int code;
  final String label;

  static ProductStatusCd strToEnum(String str) {
    return ProductStatusCd.values.byName(str);
  }

  static ProductStatusCd intToEnum(int indexCode) {
    return ProductStatusCd.values[indexCode];
  }
}

enum ExchangeStatusCd {
  WAIT(0,'대기'),     
  ACCEPTED(1,'수락'),
  DENIED(2,'거절');
  
  const ExchangeStatusCd(this.code, this.label);

  final int code;
  final String label;

  static ExchangeStatusCd strToEnum(String str) {
    return ExchangeStatusCd.values.byName(str);
  }

  static ExchangeStatusCd intToEnum(int indexCode) {
    return ExchangeStatusCd.values[indexCode];
  }
}

enum Category {
  GIFTICON(1,'기프티콘'),
  ELECTRONIC_DEVICES(2,'전자기기'),
  FURNITURE(3,'가구'),
  BABY_STUFF(4,'유아용품'),
  SPORTS(5,'스포츠'),
  FOOD(6,'식품'),
  HOBBY(7,'취미용품'),
  BEAUTY(8,'미용'),
  FEMALE_CLOTHES(9,'여성의류'),
  MALE_CLOTHES(10,'남성의류'),
  PET_STUFF(11,'반려동물용품'),
  BOOKS(12,'도서'),
  TOYS(13,'장난감'),
  PLANT(14,'식물'),
  ETC(15,'기타용품');
  
  const Category(this.id, this.label);

  final int id;
  final String label;

  static Category idToEnum(int id) {
    return Category.values[id-1];
  }

  static Category objToEnum(CategoryModel categoryModel) {
    return Category.idToEnum(categoryModel.categoryId!);
  }

  static CategoryModel enumToObj(Category category) {
    return CategoryModel(categoryId: category.id, categoryName: category.label);
  }

  static String idToLabel(int id) {
    return Category.values[id-1].label;
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
