import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullBool extends Restorable<bool> {
  RestorableNotNullBool(super.value);

  @override
  bool copy(bool value) {
    return value;
  }
}
