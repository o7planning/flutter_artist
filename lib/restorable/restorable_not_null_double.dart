import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullDouble extends Restorable<double> {
  RestorableNotNullDouble(super.value);

  @override
  double copy(double value) {
    return value;
  }
}
