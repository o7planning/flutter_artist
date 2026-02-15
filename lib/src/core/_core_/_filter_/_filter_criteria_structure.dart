part of '../core.dart';

class FilterCriteriaStructure {
  final List<SimpleFilterCriterionDef> simpleCriterionDefs;
  final List<MultiOptFilterCriterionDef> multiOptCriterionDefs;

  const FilterCriteriaStructure({
    required this.simpleCriterionDefs,
    required this.multiOptCriterionDefs,
  });

  void _printDebug() {
    print("------------------------------------------------------------------");
    for (SimpleFilterCriterionDef criterionDef in simpleCriterionDefs) {
      criterionDef._printDebugTildeSuffixesCascade();
    }
    for (MultiOptFilterCriterionDef rootOptDef in multiOptCriterionDefs) {
      rootOptDef._printDebugTildeSuffixesCascade();
    }
    print("------------------------------------------------------------------");
  }
}
