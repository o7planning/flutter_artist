import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNum extends Restorable<num?> {
  RestorableNum(super.value);

  @override
  num? copy(num? value) {
    return value;
  }
}
