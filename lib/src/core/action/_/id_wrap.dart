import 'package:flutter_artist_core/flutter_artist_core.dart';

//
class IdWrap<ID extends Object> {
  final ID? id;

  IdWrap(this.id);
}

class IntIdWrap extends IdWrap<int> {
  IntIdWrap(super.id);

  static IntIdWrap fromMap(Map<String, dynamic> map) {
    dynamic value = map["id"];
    if (value == null) {
      return IntIdWrap(null);
    }
    if (value is int) {
      return IntIdWrap(value);
    }
    throw ApiResult.error(errorMessage: "Convert error, $value is not int");
  }
}

class StringIdWrap extends IdWrap<String> {
  StringIdWrap(super.id);

  static StringIdWrap fromMap(Map<String, dynamic> map) {
    dynamic value = map["id"];
    if (value == null) {
      return StringIdWrap(null);
    }
    if (value is String) {
      return StringIdWrap(value);
    }
    throw ApiResult.error(errorMessage: "Convert error, $value is not String");
  }
}
