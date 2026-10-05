part of '__utils.dart';

class TypeUtils {
  static bool isSubtype<CHILD, PARENT>() => <CHILD>[] is List<PARENT>;
}
