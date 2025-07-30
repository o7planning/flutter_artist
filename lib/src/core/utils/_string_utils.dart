class StrUtils {
  static String? trimStringToNullIfEmpty(String? s) {
    if (s == null) {
      return null;
    }
    String s1 = s.trim();
    return s1.isEmpty ? null : s1;
  }

  // -----------------------------------------------------------------------------

  static String? stringToNullIfEmpty(String? s) {
    if (s == null) {
      return null;
    }
    return s.isEmpty ? null : s;
  }
}
