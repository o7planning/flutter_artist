part of '../code.dart';

abstract class ItemSortCriteria<ITEM extends Object> {
  late final Block block;
  final bool multiOptions;
  final List<String> _nonSignedPropNames = [];
  final List<SortCriterion> _criteria = [];
  final Map<String, SortCriterion> _criteriaMap = {};

  List<SortCriterion> get criteria => [..._criteria];

  SortCriterion? _selectedCriterion;

  SortCriterion? get selectedCriterion => _selectedCriterion;

  ///
  /// ```dart
  /// List<String> sortablePropNames = ["userName", "+email", "-fullName"];
  ///
  /// var myItemSortCriteria = MyItemSortCriteria(
  ///    sortablePropNames: sortablePropNames,
  /// );
  /// ```
  ///
  ItemSortCriteria({
    this.multiOptions = false,
    required List<String> sortablePropNames,
  }) {
    if (sortablePropNames.isEmpty) {
      throw Exception("Invalid sortablePropNames. Not Allow Empty");
    }
    int optCount = 0;
    for (String sortablePropName in sortablePropNames) {
      SortCriterion criterion = SortCriterion._parse(sortablePropName);
      criterion._text = _getText(propName: criterion.propName);
      //
      if (criterion.direction != SortingDirection.none) {
        optCount++;
        if (optCount > 1 && !multiOptions) {
          criterion._direction = SortingDirection.none;
        }
        _selectedCriterion ??= criterion;
      }
      //
      if (!_criteriaMap.containsKey(criterion.propName)) {
        _nonSignedPropNames.add(criterion.propName);
        _criteria.add(criterion);
        _criteriaMap[criterion.propName] = criterion;
      }
    }
  }

  void setSelectedCriterion(SortCriterion? value) {
    _selectedCriterion = value == null ? null : _criteriaMap[value.propName];
  }

  void moveCriterion({
    required SortCriterion movingCriterion,
    required SortCriterion destCriterion,
  }) {
    SortCriterion? moving = _criteriaMap[movingCriterion.propName];
    SortCriterion? dest = _criteriaMap[destCriterion.propName];
    if (moving == null || dest == null) {
      return;
    } else if (moving.propName == dest.propName) {
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
    block.updateAllUIComponents(
      withoutFilters: false,
      force: true,
    );
  }

  SortCriterion? getFirstSortCriterion() {
    return _criteria.firstOrNull;
  }

  SortCriterion? getCopyOfSortCriterion({required String propName}) {
    SortCriterion? criterion = _criteriaMap[propName];
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
      if (copy.propName == appliedCriterion?.propName) {
        copy._direction = appliedCriterion!.direction;
      }
      return copy;
    }).toList();
  }

  void updateSortCriterionByPropName({
    required String propName,
    required SortingDirection direction,
    required bool moveToFirst,
  }) {
    SortCriterion? criterion = _criteriaMap[propName];
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
      String propName = updateCriterion.propName;
      SortCriterion? currentCriterion = copyMap.remove(propName);
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
    block.updateAllUIComponents(
      withoutFilters: true,
      force: true,
    );
  }

  ///
  /// ```dart
  /// myItemSortCriteria.updateSortCriteria(
  ///   shuffledSortablePropNames: ['email', '+userName','-fullName'],
  /// );
  /// ```
  ///
  @Deprecated("Delete It?")
  void __updateSortCriteriaString({
    required List<String> shuffledSortablePropNames,
  }) {
    if (shuffledSortablePropNames.length != _nonSignedPropNames.length) {
      throw Exception(
          "Invalid shuffledSignedPropNames. Length must be ${_nonSignedPropNames.length}");
    }
    //
    final List<SortCriterion> updateCriteria = [];
    for (String sortablePropName in shuffledSortablePropNames) {
      SortCriterion criterion = SortCriterion._parse(sortablePropName);
      criterion._text = _getText(propName: criterion.propName);
      //
      if (!_nonSignedPropNames.contains(criterion.propName)) {
        throw Exception(
            "Invalid propName '${criterion.propName}' (Must be in $_nonSignedPropNames)");
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
      dynamic aValue = getValue(item: a, propName: criterion.propName);
      dynamic bValue = getValue(item: b, propName: criterion.propName);
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
            "Method ItemSortCriteria.getValue(item,propName) must be return int, double, bool, null or String");
      }
    }
    return 0;
  }

  String _getText({required String propName}) {
    return getText(propName: propName) ?? propName;
  }

  ///
  /// The return type must be int, double, bool, null or String.
  ///
  dynamic getValue({required ITEM item, required String propName});

  String? getText({required String propName});

  @override
  String toString() {
    return "multiOptions: $multiOptions ${_criteria.toString()}";
  }
}
