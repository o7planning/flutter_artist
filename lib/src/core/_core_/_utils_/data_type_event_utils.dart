import '../core.dart';

class DataTypeEventUtils {
  /// Evaluates whether at least one common [Type] exists across all three provided sets (3-way intersection).
  static bool hasIntersection3(Set<Type> events1,
      Set<Type> events2,
      Set<Type> events3,) {
    if (events1.isEmpty || events2.isEmpty || events3.isEmpty) {
      return false;
    }

    // Identify the smallest set to minimize lookup iterations
    Set<Type> smallest = events1;
    Set<Type> other1 = events2;
    Set<Type> other2 = events3;

    if (events2.length < smallest.length) {
      smallest = events2;
      other1 = events1;
      other2 = events3;
    }
    if (events3.length < smallest.length) {
      smallest = events3;
      other1 = events1;
      other2 = events2;
    }

    for (final Type type in smallest) {
      if (other1.contains(type) && other2.contains(type)) {
        return true;
      }
    }
    return false;
  }

  /// Evaluates whether at least one common [Type] exists between two sets (O(N) via hash lookup).
  static bool hasIntersection(Set<Type> events1, Set<Type> events2) {
    if (events1.isEmpty || events2.isEmpty) {
      return false;
    }

    final smaller = events1.length < events2.length ? events1 : events2;
    final larger = events1.length < events2.length ? events2 : events1;

    for (final Type type in smaller) {
      if (larger.contains(type)) {
        return true;
      }
    }
    return false;
  }

  static Set<Type> getProjectionsDataTypes(Iterable<Type> dataTypes) {
    final Set<Type> allEffectiveTypes = {...dataTypes};
    for (var family in FlutterArtist.appConfig.projectionFamilies) {
      if (dataTypes.any((type) => family.members.contains(type))) {
        allEffectiveTypes.addAll(family.members);
      }
    }
    return allEffectiveTypes;
  }
}
