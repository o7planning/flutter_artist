part of '../core.dart';

class SortModelStructure {
  late final Map<String, SortCriterionModel> _sortCriterionModelMap;

  Map<String, SortCriterionModel> get sortCriterionModelMap =>
      {..._sortCriterionModelMap};

  SortModelStructure({
    required List<SortCriterionModel> sortCriterionModels,
  }) {
    _sortCriterionModelMap = {
      for (var e in sortCriterionModels) e.criterionName: e
    };
  }
}
