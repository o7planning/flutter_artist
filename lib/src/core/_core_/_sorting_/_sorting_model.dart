part of '../core.dart';

abstract class SortingModel<ITEM extends Object> {
  late final Block block;

  Shelf get shelf => block.shelf;

  final SortingSide sortingSide;
  final bool multiOptions;
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
    this.multiOptions = false,
    required List<String> sortableCriterionNames,
  })  : sortingSide = SortingSide.server,
        _sortableCriterionNamesOrigin = [...sortableCriterionNames] {
    __init(sortableCriterionNames);
  }

  SortingModel._client({
    this.multiOptions = false,
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
        if (optCount > 1 && !multiOptions) {
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
    _selectedCriterion =
        value == null ? null : _criteriaMap[value.criterionName];
  }

  void moveCriterion({
    required SortingCriterion movingCriterion,
    required SortingCriterion destCriterion,
  }) {
    SortingCriterion? moving = _criteriaMap[movingCriterion.criterionName];
    SortingCriterion? dest = _criteriaMap[destCriterion.criterionName];
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
    block.clientSideSort(refresh: false);
    block.ui.updateAllUIComponents(
      withoutFilters: false,
      force: true,
    );
  }

  SortingCriterion? getFirstSortingCriterion() {
    return _criteria.firstOrNull;
  }

  SortingCriterion? getCopyOfSortingCriterion({required String criterionName}) {
    SortingCriterion? criterion = _criteriaMap[criterionName];
    return criterion?.copy();
  }

  List<SortingCriterion> getCopyOfSortingCriteria({
    required bool clearAllDirections,
    required SortingCriterion? appliedCriterion,
  }) {
    return _criteria.map((criterion) {
      SortingCriterion copy = criterion.copy();
      if (clearAllDirections) {
        copy._direction = SortingDirection.none;
      }
      if (copy.criterionName == appliedCriterion?.criterionName) {
        copy._direction = appliedCriterion!.direction;
      }
      return copy;
    }).toList();
  }

  void updateSortingCriterionByName({
    required String criterionName,
    required SortingDirection direction,
    required bool moveToFirst,
    required bool clearDirectionOfOtherCriteria,
  }) {
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
    block.clientSideSort(refresh: false);
    block.ui.updateAllUIComponents(
      withoutFilters: true,
      force: true,
    );
  }

  void rearrangeSortingCriteria({
    required List<String> newArrangementCriterionNames,
  }) {
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
        if (optCount > 1 && !multiOptions) {
          criterion._direction = SortingDirection.none;
        }
      }
    }
    //
    _criteria
      ..clear()
      ..addAll(newArrangementCriteria);
    //
    block.clientSideSort(refresh: false);
    block.ui.updateAllUIComponents(
      withoutFilters: true,
      force: true,
    );
  }

  int _compare(ITEM a, ITEM b) {
    for (SortingCriterion criterion in _criteria) {
      if (criterion.direction == SortingDirection.none) {
        continue;
      }
      dynamic aValue =
          getValue(item: a, criterionName: criterion.criterionName);
      dynamic bValue =
          getValue(item: b, criterionName: criterion.criterionName);
      //
      if (aValue == null && bValue == null) {
        continue;
      } else if (aValue != null && bValue == null) {
        return criterion.isAscending() ? -1 : 1;
      } else if (aValue == null && bValue != null) {
        return criterion.isAscending() ? 1 : -1;
      }
      // num value
      if (aValue is num) {
        bValue as num;
        //
        int x = aValue - bValue > 0 ? 1 : -1;
        if (x == 0) {
          continue;
        }
        return criterion.isAscending() ? x : -x;
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
        return criterion.isAscending() ? x : -x;
      }
      // String value
      else if (aValue is String) {
        bValue as String;
        int x = aValue.compareTo(bValue);
        if (x == 0) {
          continue;
        }
        return criterion.isAscending() ? x : -x;
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

  // Change Event from GUI.
  @_ImportantMethodAnnotation(
      "Called when the user makes a change on the SortView")
  @_SortViewChangeAnnotation()
  Future<void> _onChangeFromSortView() async {
    print("#~~~~~~~~~~~~~~~> _onChangeFromSortView");
    //
    final XShelf xShelf = _XShelfSortViewChange(sortingModel: this);
    //
    // final XFilterModel xFilterModel = xShelf.findXFilterModelByName(name)!;
    // _FilterViewChangeTaskUnit taskUnit = _FilterViewChangeTaskUnit(
    //   xFilterModel: xFilterModel,
    // );
    // xShelf._addTaskUnit(taskUnit: taskUnit);
    // FlutterArtist._rootQueue._addXShelf(xShelf);
    // await FlutterArtist.executor._executeTaskUnitQueue();
  }

  @override
  String toString() {
    return "multiOptions: $multiOptions ${_criteria.toString()}";
  }
}
