import 'package:flutter_artist/restorable/restorable.dart';

class RestorableMap<K, V> extends Restorable<Map<K, V>?> {
  RestorableMap(super.value);

  @override
  Map<K, V>? copy(Map<K, V>? value) {
    if (value == null) {
      return null;
    }
    return <K, V>{...value};
  }
}
