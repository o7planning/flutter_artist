import 'package:flutter_artist/restorable/restorable.dart';

class RestorableList<E> extends Restorable<List<E>?> {
  RestorableList(super.value);

  @override
  List<E>? copy(List<E>? value) {
    if (value == null) {
      return null;
    }
    return <E>[...value];
  }
}
