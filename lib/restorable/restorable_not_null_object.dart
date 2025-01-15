import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullObject<E> extends Restorable<E> {
  E Function(E value) _copy;

  RestorableNotNullObject(
    super.value, {
    required E Function(E value) copy,
  }) : _copy = copy;

  @override
  E copy(E value) {
    return _copy(value);
  }
}
