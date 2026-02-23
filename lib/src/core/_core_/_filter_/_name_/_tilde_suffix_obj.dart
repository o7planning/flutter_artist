part of '../../core.dart';

class TildeSuffixObj {
  final String tildeSuffix;
  late final String suffixWithoutTilde;

  TildeSuffixObj.parse({required this.tildeSuffix}) {
    if (!NameUtils.isValidTildeSuffix(tildeSuffix)) {
      throw TildeFilterCriterionSuffixInvalidError(tildeSuffix: tildeSuffix);
    }
    List<String> ss = tildeSuffix.split(tildeSymbol);
    suffixWithoutTilde = ss[1];
  }
}
