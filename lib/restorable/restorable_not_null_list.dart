import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullList<E> extends Restorable<List<E>> {
  RestorableNotNullList(super.value);

  @override
  List<E> copy(List<E> value) {
    return <E>[...value];
  }
}
