import 'package:flutter_artist/restorable/restorable.dart';

class RestorableObject<E> extends Restorable<E?> {
  E Function(E value) _copy;

  RestorableObject(
    super.value, {
    required E Function(E value) copy,
  }) : _copy = copy;

  @override
  E? copy(E? value) {
    if (value == null) {
      return null;
    }
    return _copy(value);
  }
}
