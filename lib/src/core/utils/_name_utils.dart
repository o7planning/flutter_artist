class NameUtils {
  static final _nameRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_-]*$');
  static final filterCriterionName = _nameRegex;
  static final filterFieldName = _nameRegex;
  static final formPropNameRegex = _nameRegex;

  //
  static final filterCriterionNameTildeRegex =
      RegExp(r'^[a-zA-Z_][a-zA-Z0-9_-]*~[a-zA-Z0-9]*$');
  static final tildeSuffixRegex = RegExp(r'~[a-zA-Z0-9]*$');

  static bool isValidFilterCriterionName(String name) {
    return filterCriterionName.hasMatch(name);
  }

  static bool isValidFilterFieldName(String name) {
    return filterFieldName.hasMatch(name);
  }

  static bool isValidTildeSuffix(String suffix) {
    return tildeSuffixRegex.hasMatch(suffix);
  }

  static bool isValidFilterCriterionNameTilde(String name) {
    return filterCriterionNameTildeRegex.hasMatch(name);
  }

  static bool isValidFormPropName(String name) {
    return formPropNameRegex.hasMatch(name);
  }
}
