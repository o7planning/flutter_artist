part of '../core.dart';

class SortModelStructure {
  late final Map<String, SortCriterionDef> _sortCriteriaMap;

  Map<String, SortCriterionDef> get sortCriteriaMap => {..._sortCriteriaMap};

  SortModelStructure({
    required List<SortCriterionDef> sortCriterionDefs,
  }) {
    _sortCriteriaMap = {for (var e in sortCriterionDefs) e.criterionName: e};
  }
}
