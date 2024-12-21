import 'package:flutter_artist/restorable/restorable.dart';

class RestorableNotNullMap<K, V> extends Restorable<Map<K, V>> {
  RestorableNotNullMap(super.value);

  @override
  Map<K, V> copy(Map<K, V> value) {
    return <K, V>{...value};
  }
}
