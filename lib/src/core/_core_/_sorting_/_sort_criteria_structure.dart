part of '../core.dart';

class SortCriterionDef {
  final String criterionName;
  final String text;
  final String? translationKey;
  final SortDirection? serverDirection;
  final SortDirection? clientDirection;

  SortCriterionDef({
    required this.criterionName,
    required this.text,
    this.translationKey,
    required this.serverDirection,
    this.clientDirection,
  });
}

class SortCriteriaStructure {
  late final Map<String, SortCriterionDef> _sortCriteriaMap;

  Map<String, SortCriterionDef> get sortCriteriaMap => {..._sortCriteriaMap};

  SortCriteriaStructure({
    required List<SortCriterionDef> sortCriteria,
  }) {
    _sortCriteriaMap = {for (var e in sortCriteria) e.criterionName: e};
  }
}
