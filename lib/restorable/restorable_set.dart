import 'package:flutter_artist/restorable/restorable.dart';

class RestorableSet<E> extends Restorable<Set<E>?> {
  RestorableSet(super.value);

  @override
  Set<E>? copy(Set<E>? value) {
    if (value == null) {
      return null;
    }
    return <E>{...value};
  }
}
