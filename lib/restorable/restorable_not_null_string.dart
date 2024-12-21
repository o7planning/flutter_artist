import 'package:flutter_artist/restorable/restorable.dart';

class RestorableString extends Restorable<String> {
  RestorableString(super.value);

  @override
  String copy(String value) {
    return value;
  }
}
