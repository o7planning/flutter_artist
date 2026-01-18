part of '../core.dart';

class SortCriteriaStructure {
  late final Map<String, SortCriterionDef> _sortCriteriaMap;

  Map<String, SortCriterionDef> get sortCriteriaMap => {..._sortCriteriaMap};

  SortCriteriaStructure({
    required List<SortCriterionDef> sortCriteriaDef,
  }) {
    _sortCriteriaMap = {for (var e in sortCriteriaDef) e.criterionNameX: e};
  }
}
