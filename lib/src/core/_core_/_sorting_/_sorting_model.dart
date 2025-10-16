part of '../core.dart';

abstract class SortingModel<ITEM extends Object> {
  late final Block block;

  Shelf get shelf => block.shelf;

  final SortingSide sortingSide;
  final bool multiOptionMode;
  bool get singleOptionMode => !multiOptionMode;

  final List<String> _sortableCriterionNamesOrigin;
  final List<String> _nonSignedCriterionNames = [];
  final List<SortingCriterion> _criteria = [];
  final Map<String, SortingCriterion> _criteriaMap = {};

  List<SortingCriterion> get criteria => [..._criteria];

  SortingCriterion? _selectedCriterion;

  SortingCriterion? get selectedCriterion => _selectedCriterion;

  // TODO: SortingCriteria.
  SortingCriteria get sortingCriteria => SortingCriteria._(_criteria);

  late final _SortUIComponents ui = _SortUIComponents(sortingModel: this);

  ///
  /// ```dart
  /// List<String> sortableCriterionNames = ["userName", "+email", "-fullName"];
  ///
  /// var mySortingModel = MySortingModel(
  ///    sortableCriterionNames: sortableCriterionNames,
  /// );
  /// ```
  ///
  SortingModel({
    this.multiOptionMode = false,
    required List<String> sortableCriterionNames,
  })  : sortingSide = SortingSide.server,
        _sortableCriterionNamesOrigin = [...sortableCriterionNames] {
    __init(sortableCriterionNames);
  }

  SortingModel._client({
    this.multiOptionMode = false,
    required List<String> sortableCriterionNames,
  })  : sortingSide = SortingSide.client,
        _sortableCriterionNamesOrigin = [...sortableCriterionNames] {
    __init(sortableCriterionNames);
  }

  void __init(List<String> sortableCriterionNames) {
    int optCount = 0;
    for (String sortableCriterionName in sortableCriterionNames) {
      SortingCriterion criterion =
          SortingCriterion._parse(sortableCriterionName);
      criterion._text = _getText(criterionName: criterion.criterionName);
      //
      if (criterion.direction != SortingDirection.none) {
        optCount++;
        if (optCount > 1 && !multiOptionMode) {
          criterion._direction = SortingDirection.none;
        }
        _selectedCriterion ??= criterion;
      }
      //
      if (!_criteriaMap.containsKey(criterion.criterionName)) {
        _nonSignedCriterionNames.add(criterion.criterionName);
        _criteria.add(criterion);
        _criteriaMap[criterion.criterionName] = criterion;
      }
    }
  }

  void setSelectedCriterion(SortingCriterion? value) {
    if (singleOptionMode) {
      _selectedCriterion =
          value == null ? null : _criteriaMap[value.criterionName];
    }
  }

  bool hasDirection() {
    for (SortingCriterion criterion in _criteria) {
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
    SortingCriterion? moving = _criteriaMap[movingCriterionName];
    SortingCriterion? dest = _criteriaMap[destCriterionName];
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

  SortingCriterion? getFirstSortingCriterion() {
    return _criteria.firstOrNull;
  }

  Future<void> updateSortingCriterionByName({
    required String criterionName,
    required SortingDirection direction,
    required bool moveToFirst,
    required bool clearDirectionOfOtherCriteria,
  }) async {
    SortingCriterion? criterion = _criteriaMap[criterionName];
    if (criterion == null) {
      return;
    }
    if (clearDirectionOfOtherCriteria) {
      for (SortingCriterion sc in _criteria) {
        sc._direction = SortingDirection.none;
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
    List<SortingCriterion> newArrangementCriteria = [];
    //
    for (String criterionName in newArrangementCn) {
      SortingCriterion? criterion = _criteriaMap[criterionName];
      if (criterion == null) {
        continue;
      }
      //
      newArrangementCriteria.add(criterion);
      //
      if (criterion.direction != SortingDirection.none) {
        optCount++;
        if (optCount > 1 && !multiOptionMode) {
          criterion._direction = SortingDirection.none;
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
    for (SortingCriterion sc in _criteria) {
      sc._direction = SortingDirection.none;
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
    final List<SortingCriterion> criteriaList = [];
    if (singleOptionMode) {
      SortingCriterion? selected = _selectedCriterion;
      if (selected != null) {
        criteriaList.add(selected);
      } else {
        final String msg = _createFatalAppError(
          "SortingModel is singleOptionMode so you need to call: "
          "sortingModel.setSelectedCriterion()",
        );
        print(msg);
      }
    } else {
      criteriaList.addAll(_criteria);
    }
    for (SortingCriterion sc in criteriaList) {
      if (sc.direction == SortingDirection.none) {
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
            "Method SortingModel.getValue(item,criterionName) must be return int, double, bool, null or String");
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

  // @_ImportantMethodAnnotation("Called when SortingModel changed")
  // @_SortingModelChangedAnnotation()
  // Future<void> _onSortingModelChanged() async {
  //   // print("#~~~~~~~~~~~~~~~> _onSortingModelChanged");
  //   //
  //   await block.query();
  //   // final XShelf xShelf = _XShelfSortViewChange(sortingModel: this);
  //   //
  //   // final XFilterModel xFilterModel = xShelf.findXFilterModelByName(name)!;
  //   // _FilterViewChangeTaskUnit taskUnit = _FilterViewChangeTaskUnit(
  //   //   xFilterModel: xFilterModel,
  //   // );
  //   // xShelf._addTaskUnit(taskUnit: taskUnit);
  //   // FlutterArtist._rootQueue._addXShelf(xShelf);
  //   // await FlutterArtist.executor._executeTaskUnitQueue();
  // }

  @override
  String toString() {
    return "multiOptions: $multiOptionMode ${_criteria.toString()}";
  }
}
