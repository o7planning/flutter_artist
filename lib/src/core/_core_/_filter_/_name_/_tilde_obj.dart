part of '../../core.dart';

const String tildeSymbol = "~";

class TildeObj {
  final String tildeCriterionName;
  late final String criterionName;
  late final String afterTildeSuffix;
  late final String tildeSuffix;

  TildeObj.parse({required this.tildeCriterionName}) {
    if (!NameUtils.isValidTildeFilterCriterionName(tildeCriterionName)) {
      throw TildeFilterCriterionNameInvalidError(
          tildeCriterionName: tildeCriterionName);
    }
    List<String> ss = tildeCriterionName.split(tildeSymbol);
    criterionName = ss[0];
    afterTildeSuffix = ss[1];
    tildeSuffix = tildeSymbol + ss[1];
  }

  static String getNameTilde({
    required String baseName,
    required String afterTildeSuffix,
  }) {
    return "$baseName$tildeSymbol$afterTildeSuffix";
  }

  static String createNameTilde({
    required String baseName,
    required String tildeSuffix,
  }) {
    return "$baseName$tildeSuffix";
  }
}
