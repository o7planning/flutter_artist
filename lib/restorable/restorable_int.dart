import 'package:flutter_artist/restorable/restorable.dart';

class RestorableInt extends Restorable<int?> {
  RestorableInt(super.value);

  @override
  int? copy(int? value) {
    return value;
  }
}
