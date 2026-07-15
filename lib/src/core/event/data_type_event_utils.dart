import '../_core_/core.dart';

class DataTypeEventUtils {
  static bool hasIntersection(Set<Type> events1, Set<Type> events2) {
    for (Type e1 in events1) {
      for (Type e2 in events2) {
        if (e1 == e2) {
          return true;
        }
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
