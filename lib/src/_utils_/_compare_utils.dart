part of '../../flutter_artist.dart';

///
/// This function is used to check for "dirty" in a form.
///
bool _compareDynamicAndDynamic(dynamic value, dynamic other) {
  if (value is Iterable) {
    return _compareIterableAndDynamic(value, other);
  } else if (other is Iterable) {
    return _compareIterableAndDynamic(other, value);
  } else if (value is Map) {
    return _compareMapAndDynamic(value, other);
  } else if (other is Map) {
    return _compareMapAndDynamic(other, value);
  } else {
    return value == other;
  }
}

///
/// This function is used to check for "dirty" in a form.
///
bool _compareMapAndMap(Map map, Map other) {
  Set<dynamic> keys = {}
    ..addAll(map.keys)
    ..addAll(other.keys);

  for (dynamic key in keys) {
    dynamic v1 = map[key];
    dynamic v2 = other[key];
    if (v1 != v2) {
      return false;
    }
  }
  return true;
}

///
/// This function is used to check for "dirty" in a form.
///
bool _compareIterableAndIterable(Iterable iterable, Iterable other) {
  if (iterable.length != other.length) {
    return false;
  }
  List list1 = [...iterable];
  List list2 = [...other];
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }
  return true;
}

///
/// This function is used to check for "dirty" in a form.
///
bool _compareIterableAndDynamic(Iterable iterable, dynamic other) {
  if (iterable.isEmpty) {
    if (other == null) {
      return true;
    } else if (other is Iterable) {
      if (other.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  // iterable is not empty:
  else {
    if (other == null) {
      return false;
    } else if (other is Iterable) {
      if (other.isEmpty) {
        return false;
      } else {
        return _compareIterableAndIterable(iterable, other);
      }
    } else {
      return false;
    }
  }
}

///
/// This function is used to check for "dirty" in a form.
///
bool _compareMapAndDynamic(Map map, dynamic other) {
  if (map.isEmpty) {
    if (other == null) {
      return true;
    } else if (other is Map) {
      if (other.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  // map is not empty:
  else {
    if (other == null) {
      return false;
    } else if (other is Map) {
      if (other.isEmpty) {
        return false;
      } else {
        return _compareMapAndMap(map, other);
      }
    } else {
      return false;
    }
  }
}
