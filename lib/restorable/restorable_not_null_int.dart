import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullInt extends Restorable<int> {
  RestorableNotNullInt(super.value);

  @override
  int copy(int value) {
    return value;
  }
}
