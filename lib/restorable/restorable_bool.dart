import 'package:flutter_artist/restorable/restorable.dart';

class RestorableBool extends Restorable<bool?> {
  RestorableBool(super.value);

  @override
  bool? copy(bool? value) {
    return value;
  }
}
