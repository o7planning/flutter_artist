part of '../core.dart';

abstract class SortModelTemplate<ITEM extends Object> {
  // final SortingSide sortingSide;

  final bool multiOptionMode;

  bool get singleOptionMode => !multiOptionMode;

  final List<SortCriterionDef> _sortCriteria;

  // final Map<String, SortDirection?> _originCriteriaMap;
  // final List<SortCriterion> _criteria = [];
  // final Map<String, SortCriterion> _criteriaMap = {};
  //
  // List<SortCriterion> get criteria => [..._criteria];
  //
  // SortCriterion? _selectedCriterion;
  //
  // SortCriterion? get selectedCriterion => _selectedCriterion;
  //
  // late final _SortUIComponents ui = _SortUIComponents(sortModel: this);

  SortModelTemplate({
    this.multiOptionMode = false,
    required List<SortCriterionDef> sortCriteria,
  }) : _sortCriteria = sortCriteria {
    // __init(criteriaMap);
  }

  // void __init(Map<String, SortDirection?> criteriaMap) {
  //   int optCount = 0;
  //   for (String criterionName in criteriaMap.keys) {
  //     SortDirection? sortDirection = criteriaMap[criterionName];
  //     String text = _getText(criterionName: criterionName);
  //     SortCriterion criterion = SortCriterion._(
  //       direction: sortDirection,
  //       criterionName: criterionName,
  //       text: text,
  //     );
  //     //
  //     if (criterion.direction != null) {
  //       optCount++;
  //       if (optCount > 1 && !multiOptionMode) {
  //         criterion._direction = null;
  //       }
  //       _selectedCriterion ??= criterion;
  //     }
  //     //
  //     if (!_criteriaMap.containsKey(criterion.criterionName)) {
  //       _criteria.add(criterion);
  //       _criteriaMap[criterion.criterionName] = criterion;
  //     }
  //   }
  // }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  SortCriteriaStructure registerCriteriaStructure();

  // ***************************************************************************
  // ***************************************************************************

  // int _compare(ITEM a, ITEM b) {
  //   final List<SortCriterion> criteriaList = [];
  //   // Logic: #0006
  //   if (singleOptionMode) {
  //     SortCriterion? selected = _selectedCriterion;
  //     if (selected != null) {
  //       criteriaList.add(selected);
  //     } else {
  //       final String msg = _createFatalAppError(
  //         "SortModel is singleOptionMode so you need to call: "
  //         "sortModel.setSelectedCriterion()",
  //       );
  //       print(msg);
  //     }
  //   } else {
  //     criteriaList.addAll(_criteria);
  //   }
  //   for (SortCriterion sc in criteriaList) {
  //     if (sc.direction == null) {
  //       continue;
  //     }
  //     dynamic aValue = getValue(item: a, criterionName: sc.criterionName);
  //     dynamic bValue = getValue(item: b, criterionName: sc.criterionName);
  //     //
  //     if (aValue == null && bValue == null) {
  //       continue;
  //     } else if (aValue != null && bValue == null) {
  //       return sc.isAscending() ? -1 : 1;
  //     } else if (aValue == null && bValue != null) {
  //       return sc.isAscending() ? 1 : -1;
  //     }
  //     // num value
  //     if (aValue is num) {
  //       bValue as num;
  //       //
  //       num v = aValue - bValue;
  //       if (v == 0) {
  //         continue;
  //       }
  //       int x = v > 0 ? 1 : -1;
  //       return sc.isAscending() ? x : -x;
  //     }
  //     // bool value
  //     else if (aValue is bool) {
  //       bValue as bool;
  //       //
  //       int va = aValue ? 1 : 0;
  //       int vb = bValue ? 1 : 0;
  //       int x = va - vb;
  //       if (x == 0) {
  //         continue;
  //       }
  //       return sc.isAscending() ? x : -x;
  //     }
  //     // String value
  //     else if (aValue is String) {
  //       bValue as String;
  //       int x = aValue.compareTo(bValue);
  //       if (x == 0) {
  //         continue;
  //       }
  //       return sc.isAscending() ? x : -x;
  //     } else {
  //       throw Exception(
  //           "Method SortModel.getValue(item,criterionName) must be return int, double, bool, null or String");
  //     }
  //   }
  //   return 0;
  // }

  String _getText({required String criterionName}) {
    return getText(criterionName: criterionName) ?? criterionName;
  }

  ///
  /// The return type must be int, double, bool, null or String.
  ///
  dynamic getValue({required ITEM item, required String criterionName});

  String? getText({required String criterionName});

  // ***************************************************************************
  // ***************************************************************************

  @override
  String toString() {
    return "multiOptions: $multiOptionMode ${_sortCriteria.toString()}";
  }
}
