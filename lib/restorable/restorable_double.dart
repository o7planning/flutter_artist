import 'package:flutter_artist/restorable/restorable.dart';

class RestorableDouble extends Restorable<double?> {
  RestorableDouble(super.value);

  @override
  double? copy(double? value) {
    return value;
  }
}
