part of '../core.dart';

abstract class SortModel<ITEM extends Object> {
  late final Block block;

  Shelf get shelf => block.shelf;

  final SortingSide sortingSide;
  final bool multiOptionMode;

  bool get singleOptionMode => !multiOptionMode;

  final Map<String, SortDirection?> _originCriteriaMap;
  final List<SortCriterion> _criteria = [];
  final Map<String, SortCriterion> _criteriaMap = {};

  List<SortCriterion> get criteria => [..._criteria];

  SortCriterion? _selectedCriterion;

  SortCriterion? get selectedCriterion => _selectedCriterion;

  late final _SortUIComponents ui = _SortUIComponents(sortModel: this);

  ///
  /// ```dart
  /// List<String,SortDirection?> criteriaMap = {
  ///   "userName": SortDirection.asc,
  ///   "email": null,
  ///   "fullName": SortDirection.desc
  /// };
  ///
  /// var mySortModel = MySortModel(
  ///    criteriaMap: criteriaMap,
  /// );
  /// ```
  ///
  SortModel({
    this.multiOptionMode = false,
    required Map<String, SortDirection?> criteriaMap,
  })  : sortingSide = SortingSide.server,
        _originCriteriaMap = {...criteriaMap} {
    __init(criteriaMap);
  }

  SortModel._client({
    this.multiOptionMode = false,
    required Map<String, SortDirection?> criteriaMap,
  })  : sortingSide = SortingSide.client,
        _originCriteriaMap = {...criteriaMap} {
    __init(criteriaMap);
  }

  void __init(Map<String, SortDirection?> criteriaMap) {
    int optCount = 0;
    for (String criterionName in criteriaMap.keys) {
      SortDirection? sortDirection = criteriaMap[criterionName];
      String text = _getText(criterionName: criterionName);
      SortCriterion criterion = SortCriterion._(
        direction: sortDirection,
        criterionName: criterionName,
        text: text,
      );
      //
      if (criterion.direction != null) {
        optCount++;
        if (optCount > 1 && !multiOptionMode) {
          criterion._direction = null;
        }
        _selectedCriterion ??= criterion;
      }
      //
      if (!_criteriaMap.containsKey(criterion.criterionName)) {
        _criteria.add(criterion);
        _criteriaMap[criterion.criterionName] = criterion;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Returns the criteria used for sorting.
  ///
  SortableCriteria getSortableCriteria() {
    // Logic: #0006
    if (singleOptionMode) {
      return _selectedCriterion == null || _selectedCriterion!.direction == null
          ? SortableCriteria._([])
          : SortableCriteria._(
              [
                SortableCriterion._(
                  direction: _selectedCriterion!.direction!,
                  criterionName: _selectedCriterion!.criterionName,
                )
              ],
            );
    } else {
      List<SortableCriterion> list = _criteria
          .where((sc) => sc.hasDirection())
          .map(
            (sc) => SortableCriterion._(
              direction: sc.direction!,
              criterionName: sc.criterionName,
            ),
          )
          .toList();
      return SortableCriteria._(list);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedCriterion(SortCriterion? value) {
    if (singleOptionMode) {
      _selectedCriterion =
          value == null ? null : _criteriaMap[value.criterionName];
    }
  }

  bool hasDirection() {
    for (SortCriterion criterion in _criteria) {
      if (criterion.hasDirection()) {
        return true;
      }
    }
    return false;
  }

  Future<void> moveCriterion({
    required String movingCriterionName,
    required String destCriterionName,
  }) async {
    SortCriterion? moving = _criteriaMap[movingCriterionName];
    SortCriterion? dest = _criteriaMap[destCriterionName];
    if (moving == null || dest == null) {
      return;
    } else if (moving.criterionName == dest.criterionName) {
      return;
    }
    int movingIdx = _criteria.indexOf(moving);
    int destIdx = _criteria.indexOf(dest);
    if (movingIdx > destIdx) {
      _criteria.remove(moving);
      _criteria.insert(destIdx, moving);
    } else {
      _criteria.remove(moving);
      _criteria.insert(destIdx, moving);
    }
    //
    await __applyChanges();
  }

  SortCriterion? getFirstSortingCriterion() {
    return _criteria.firstOrNull;
  }

  Future<void> updateSortingCriterionByName({
    required String criterionName,
    required SortDirection? direction,
    required bool moveToFirst,
    required bool clearDirectionOfOtherCriteria,
  }) async {
    SortCriterion? criterion = _criteriaMap[criterionName];
    if (criterion == null) {
      return;
    }
    if (clearDirectionOfOtherCriteria) {
      for (SortCriterion sc in _criteria) {
        sc._direction = null;
      }
    }
    criterion._direction = direction;
    //
    await __applyChanges();
  }

  Future<void> rearrangeSortingCriteria({
    required List<String> newArrangementCriterionNames,
  }) async {
    final List<String> oldArrangementCn =
        _criteria.map((c) => c.criterionName).toList();
    //
    final List<String> newArrangementCn = [
      ...{...newArrangementCriterionNames, ...oldArrangementCn}
    ]..retainWhere((cn) => oldArrangementCn.contains(cn));
    //
    bool arrangementChanged = !listEquals(oldArrangementCn, newArrangementCn);
    if (!arrangementChanged) {
      return;
    }
    //
    int optCount = 0;
    List<SortCriterion> newArrangementCriteria = [];
    //
    for (String criterionName in newArrangementCn) {
      SortCriterion? criterion = _criteriaMap[criterionName];
      if (criterion == null) {
        continue;
      }
      //
      newArrangementCriteria.add(criterion);
      //
      if (criterion.direction != null) {
        optCount++;
        if (optCount > 1 && !multiOptionMode) {
          criterion._direction = null;
        }
      }
    }
    //
    _criteria
      ..clear()
      ..addAll(newArrangementCriteria);
    //
    await __applyChanges();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> clearAllSorts() async {
    if (!hasDirection()) {
      return;
    }
    for (SortCriterion sc in _criteria) {
      sc._direction = null;
    }
    await __applyChanges();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __applyChanges() async {
    if (sortingSide == SortingSide.client) {
      block.clientSideSort(refresh: false);
      block.ui.updateAllUIComponents(
        withoutFilters: true,
        force: true,
      );
    } else {
      await block.query();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  int _compare(ITEM a, ITEM b) {
    final List<SortCriterion> criteriaList = [];
    // Logic: #0006
    if (singleOptionMode) {
      SortCriterion? selected = _selectedCriterion;
      if (selected != null) {
        criteriaList.add(selected);
      } else {
        final String msg = _createFatalAppError(
          "SortModel is singleOptionMode so you need to call: "
          "sortModel.setSelectedCriterion()",
        );
        print(msg);
      }
    } else {
      criteriaList.addAll(_criteria);
    }
    for (SortCriterion sc in criteriaList) {
      if (sc.direction == null) {
        continue;
      }
      dynamic aValue = getValue(item: a, criterionName: sc.criterionName);
      dynamic bValue = getValue(item: b, criterionName: sc.criterionName);
      //
      if (aValue == null && bValue == null) {
        continue;
      } else if (aValue != null && bValue == null) {
        return sc.isAscending() ? -1 : 1;
      } else if (aValue == null && bValue != null) {
        return sc.isAscending() ? 1 : -1;
      }
      // num value
      if (aValue is num) {
        bValue as num;
        //
        num v = aValue - bValue;
        if (v == 0) {
          continue;
        }
        int x = v > 0 ? 1 : -1;
        return sc.isAscending() ? x : -x;
      }
      // bool value
      else if (aValue is bool) {
        bValue as bool;
        //
        int va = aValue ? 1 : 0;
        int vb = bValue ? 1 : 0;
        int x = va - vb;
        if (x == 0) {
          continue;
        }
        return sc.isAscending() ? x : -x;
      }
      // String value
      else if (aValue is String) {
        bValue as String;
        int x = aValue.compareTo(bValue);
        if (x == 0) {
          continue;
        }
        return sc.isAscending() ? x : -x;
      } else {
        throw Exception(
            "Method SortModel.getValue(item,criterionName) must be return int, double, bool, null or String");
      }
    }
    return 0;
  }

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
    return "multiOptions: $multiOptionMode ${_criteria.toString()}";
  }
}
