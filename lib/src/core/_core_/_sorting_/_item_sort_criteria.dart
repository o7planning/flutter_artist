part of '../core.dart';

abstract class ItemSortCriteria<ITEM extends Object> {
  late final Block block;
  final bool multiOptions;
  final List<String> _nonSignedCriterionNames = [];
  final List<SortCriterion> _criteria = [];
  final Map<String, SortCriterion> _criteriaMap = {};

  List<SortCriterion> get criteria => [..._criteria];

  SortCriterion? _selectedCriterion;

  SortCriterion? get selectedCriterion => _selectedCriterion;

  ///
  /// ```dart
  /// List<String> sortableCriterionNames = ["userName", "+email", "-fullName"];
  ///
  /// var myItemSortCriteria = MyItemSortCriteria(
  ///    sortableCriterionNames: sortableCriterionNames,
  /// );
  /// ```
  ///
  ItemSortCriteria({
    this.multiOptions = false,
    required List<String> sortableCriterionNames,
  }) {
    if (sortableCriterionNames.isEmpty) {
      throw Exception("Invalid sortableCriterionNames. Not Allow Empty");
    }
    int optCount = 0;
    for (String sortableCriterionName in sortableCriterionNames) {
      SortCriterion criterion = SortCriterion._parse(sortableCriterionName);
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

  void setSelectedCriterion(SortCriterion? value) {
    _selectedCriterion =
        value == null ? null : _criteriaMap[value.criterionName];
  }

  void moveCriterion({
    required SortCriterion movingCriterion,
    required SortCriterion destCriterion,
  }) {
    SortCriterion? moving = _criteriaMap[movingCriterion.criterionName];
    SortCriterion? dest = _criteriaMap[destCriterion.criterionName];
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
    block.sort(refresh: false);
    block.ui.updateAllUIComponents(
      withoutFilters: false,
      force: true,
    );
  }

  SortCriterion? getFirstSortCriterion() {
    return _criteria.firstOrNull;
  }

  SortCriterion? getCopyOfSortCriterion({required String criterionName}) {
    SortCriterion? criterion = _criteriaMap[criterionName];
    return criterion?.copy();
  }

  List<SortCriterion> getCopyOfSortCriteria({
    required bool clearAllDirections,
    required SortCriterion? appliedCriterion,
  }) {
    return _criteria.map((criterion) {
      SortCriterion copy = criterion.copy();
      if (clearAllDirections) {
        copy._direction = SortingDirection.none;
      }
      if (copy.criterionName == appliedCriterion?.criterionName) {
        copy._direction = appliedCriterion!.direction;
      }
      return copy;
    }).toList();
  }

  void updateSortCriterionByCriterionName({
    required String criterionName,
    required SortingDirection direction,
    required bool moveToFirst,
  }) {
    SortCriterion? criterion = _criteriaMap[criterionName];
    if (criterion == null) {
      return;
    }
    SortCriterion updateCriterion = criterion.copyWith(direction: direction);
    updateSortCriterion(
      updateCriterion: updateCriterion,
      moveToFirst: moveToFirst,
    );
  }

  void updateSortCriterion({
    required SortCriterion updateCriterion,
    required bool moveToFirst,
  }) {
    var updateCriteria = [updateCriterion];
    updateSortCriteria(
      updateCriteria: updateCriteria,
      rearrangeCriteria: false,
    );
  }

  void updateSortCriteria({
    required List<SortCriterion> updateCriteria,
    required bool rearrangeCriteria,
  }) {
    final Map<String, SortCriterion> copyMap = {..._criteriaMap};
    //
    int optCount = 0;
    List<SortCriterion> newArrangedCriteria = [];
    //
    for (SortCriterion updateCriterion in updateCriteria) {
      String criterionName = updateCriterion.criterionName;
      SortCriterion? currentCriterion = copyMap.remove(criterionName);
      if (currentCriterion == null) {
        continue;
      }
      //
      newArrangedCriteria.add(currentCriterion);
      //
      if (updateCriterion.direction != SortingDirection.none) {
        optCount++;
        if (optCount > 1 && !multiOptions) {
          currentCriterion._direction = SortingDirection.none;
        } else {
          currentCriterion._direction = updateCriterion.direction;
        }
      } else {
        currentCriterion._direction = updateCriterion.direction;
      }
    }
    //
    for (SortCriterion criterion in copyMap.values) {
      if (optCount >= 1 && !multiOptions) {
        criterion._direction = SortingDirection.none;
      }
      newArrangedCriteria.add(criterion);
    }
    //
    if (rearrangeCriteria) {
      _criteria
        ..clear()
        ..addAll(newArrangedCriteria);
    }
    //
    block.sort(refresh: false);
    block.ui.updateAllUIComponents(
      withoutFilters: true,
      force: true,
    );
  }

  ///
  /// ```dart
  /// myItemSortCriteria.updateSortCriteria(
  ///   shuffledSortableCriterionNames: ['email', '+userName','-fullName'],
  /// );
  /// ```
  ///
  @Deprecated("Delete It?")
  void __updateSortCriteriaString({
    required List<String> shuffledSortableCriterionNames,
  }) {
    if (shuffledSortableCriterionNames.length !=
        _nonSignedCriterionNames.length) {
      throw Exception(
          "Invalid shuffledSignedCriterionNames. Length must be ${_nonSignedCriterionNames.length}");
    }
    //
    final List<SortCriterion> updateCriteria = [];
    for (String sortableCriterionName in shuffledSortableCriterionNames) {
      SortCriterion criterion = SortCriterion._parse(sortableCriterionName);
      criterion._text = _getText(criterionName: criterion.criterionName);
      //
      if (!_nonSignedCriterionNames.contains(criterion.criterionName)) {
        throw Exception(
            "Invalid criterionName '${criterion.criterionName}' (Must be in $_nonSignedCriterionNames)");
      }
      updateCriteria.add(criterion);
    }
    //
    updateSortCriteria(
      updateCriteria: updateCriteria,
      rearrangeCriteria: false,
    );
  }

  int _compare(ITEM a, ITEM b) {
    for (SortCriterion criterion in _criteria) {
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
      // int value
      if (aValue is int) {
        bValue as int;
        //
        int x = aValue - bValue;
        if (x == 0) {
          continue;
        }
        return criterion.isAscending() ? x : -x;
      }
      // double value
      else if (aValue is double) {
        bValue as double;
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
            "Method ItemSortCriteria.getValue(item,criterionName) must be return int, double, bool, null or String");
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

  @override
  String toString() {
    return "multiOptions: $multiOptions ${_criteria.toString()}";
  }
}
