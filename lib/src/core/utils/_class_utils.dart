String getClassName(Object? type) {
  return type.runtimeType.toString();
}

String getClassNameWithoutGenerics(Object? type) {
  String s = type.runtimeType.toString();
  return s.split('<')[0];
}
