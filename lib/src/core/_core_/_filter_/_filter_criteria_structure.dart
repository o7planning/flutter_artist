part of '../core.dart';

class FilterCriteriaStructure {
  final List<PlainFilterCriterionDef> plainCriterionDefs;
  final List<ManagedOptFilterCriterionDef> managedOptCriterionDefs;

  const FilterCriteriaStructure({
    required this.plainCriterionDefs,
    required this.managedOptCriterionDefs,
  });

  void _printDebug() {
    print("------------------------------------------------------------------");
    for (PlainFilterCriterionDef criterionDef in plainCriterionDefs) {
      criterionDef._printDebugTildeSuffixesCascade();
    }
    for (ManagedOptFilterCriterionDef rootOptDef in managedOptCriterionDefs) {
      rootOptDef._printDebugTildeSuffixesCascade();
    }
    print("------------------------------------------------------------------");
  }
}
