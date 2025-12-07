class TypeUtils {
  static bool isSubtype<CHILD, PARENT>() => <CHILD>[] is List<PARENT>;
}
