part of '../../core.dart';

class CriterionTildeDef {
  final String suffix;
  final String parentMatchSuffix;
  final DefaultSettingPolicy defaultSettingPolicy;

  late final String afterTildeSuffix;
  late final String parentMatchAfterTildeSuffix;

  CriterionTildeDef({
    required this.suffix,
    String? parentMatchSuffix,
    this.defaultSettingPolicy = DefaultSettingPolicy.onInitialOnly,
  }) : parentMatchSuffix = parentMatchSuffix ?? suffix {
    TildeSuffix tsObj = TildeSuffix.parse(tildeSuffix: suffix);
    afterTildeSuffix = tsObj.suffixWithoutTilde;
    //
    TildeSuffix ptsObj = TildeSuffix.parse(tildeSuffix: this.parentMatchSuffix);
    parentMatchAfterTildeSuffix = ptsObj.suffixWithoutTilde;
  }
}
