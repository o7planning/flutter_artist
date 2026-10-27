part of '../core.dart';

abstract interface class ClassDefViewable {
  Map<String, Type> getGenericsInfoMap();
}

extension ClassDefViewableExt on ClassDefViewable {
  String debugClassParametersDefinition() {
    Map<String, Type> map = getGenericsInfoMap();
    return "<${map.entries.map((entry) => getTypeNameWithoutGenerics(entry.value)).join(', ')}>";
  }
}
