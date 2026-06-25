part of '../../core.dart';

class TildeCriterionConfig {
  final String suffix;
  final String parentMatchSuffix;
  final DefaultSettingPolicy defaultSettingPolicy;

  late final String afterTildeSuffix;
  late final String parentMatchAfterTildeSuffix;

  TildeCriterionConfig({
    required this.suffix,
    String? parentMatchSuffix,
    this.defaultSettingPolicy = DefaultSettingPolicy.onInitialOnly,
  }) : parentMatchSuffix = parentMatchSuffix ?? suffix {
    TildeSuffixObj tsObj = TildeSuffixObj.parse(tildeSuffix: suffix);
    afterTildeSuffix = tsObj.suffixWithoutTilde;
    //
    TildeSuffixObj ptsObj =
        TildeSuffixObj.parse(tildeSuffix: this.parentMatchSuffix);
    parentMatchAfterTildeSuffix = ptsObj.suffixWithoutTilde;
  }
}
