import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullNum extends Restorable<num> {
  RestorableNotNullNum(super.value);

  @override
  num copy(num value) {
    return value;
  }
}
