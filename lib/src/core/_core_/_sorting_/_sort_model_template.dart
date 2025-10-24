part of '../core.dart';

abstract class SortModelTemplate<ITEM extends Object> {
  // Multi-sort criteria selection
  final bool clientMultiSortCriteriaSelection;
  final bool serverMultiSortCriteriaSelection;

  SortModelTemplate({
    this.clientMultiSortCriteriaSelection = false,
    this.serverMultiSortCriteriaSelection = false,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  SortCriteriaStructure registerCriteriaStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The return type must be int, double, bool, null or String.
  ///
  dynamic getValue({required ITEM item, required String criterionName});

  String? getText({required String criterionName});
}
