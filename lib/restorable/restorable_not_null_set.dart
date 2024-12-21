import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullSet<E> extends Restorable<Set<E>> {
  RestorableNotNullSet(super.value);

  @override
  Set<E> copy(Set<E> value) {
    return <E>{...value};
  }
}
