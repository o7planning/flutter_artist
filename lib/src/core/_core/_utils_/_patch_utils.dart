part of '../../_fa_core.dart';

class PatchUtils {
  static Map<String, dynamic> getMinPatchValues({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> patchValues,
  }) {
    Map<String, dynamic> ret = {};
    for (String key in patchValues.keys) {
      dynamic v1 = patchValues[key];
      dynamic v = currentValues[key];
      if (!identical(v1, v)) {
        ret[key] = v1;
      }
    }
    return ret;
  }
}
