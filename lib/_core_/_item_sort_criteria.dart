part of '../flutter_artist.dart';

abstract class ItemSortCriteria<ITEM extends Object> {
  late final Block block;
  final bool multiOptions;
  final List<String> _nonSignedPropNames = [];
  final List<SortCriterion> _sortCriteria = [];
  final Map<String, SortCriterion> _sortCriteriaMap = {};

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
      //
      if (criterion.direction != SortingDirection.none) {
        optCount++;
        if (optCount > 1 && !multiOptions) {
          criterion._setToNone();
        }
      }
      //
      _nonSignedPropNames.add(criterion.propName);
      _sortCriteria.add(criterion);
      _sortCriteriaMap[criterion.propName] = criterion;
    }
  }

  void clearOptions() {
    for (var criterion in _sortCriteria) {
      criterion._setToNone();
    }
  }

  void movePropName({
    required String movingPropName,
    required String destPropName,
  }) {
    SortCriterion? moving = _sortCriteriaMap[movingPropName];
    SortCriterion? dest = _sortCriteriaMap[destPropName];
    if (moving == null || dest == null) {
      return;
    }
    int movingIdx = _sortCriteria.indexOf(moving);
    int destIdx = _sortCriteria.indexOf(dest);
    if (movingIdx > destIdx) {
      _sortCriteria.remove(moving);
      _sortCriteria.insert(destIdx, moving);
    } else {
      _sortCriteria.remove(moving);
      _sortCriteria.insert(destIdx, moving);
    }
  }

  SortCriterion? getCopyOfSortCriterion({required String propName}) {
    SortCriterion? criterion = _sortCriteriaMap[propName];
    return criterion?.copy();
  }

  List<SortCriterion> getCopyOfSortCriteria() {
    return _sortCriteria.map((criterion) => criterion.copy()).toList();
  }

  void updateSortCriterion({
    required String propName,
    required SortingDirection direction,
  }) {
    SortCriterion? criterion = _sortCriteriaMap[propName];
    if (criterion == null) {
      return;
    }
    SortCriterion updateCriterion = criterion.copyWith(direction);
    __updateSortCriterion(updateCriterion: updateCriterion);
  }

  void __updateSortCriterion({required SortCriterion updateCriterion}) {
    var updateCriteria = [updateCriterion];
    __updateSortCriteria(updateCriteria: updateCriteria);
  }

  void __updateSortCriteria({required List<SortCriterion> updateCriteria}) {
    final Map<String, SortCriterion> copyMap = {..._sortCriteriaMap};
    //
    int optCount = 0;
    for (SortCriterion updateCriterion in updateCriteria) {
      String propName = updateCriterion.propName;
      SortCriterion? currentCriterion = copyMap.remove(propName);
      if (currentCriterion == null) {
        continue;
      }
      //
      if (updateCriterion.direction != SortingDirection.none) {
        optCount++;
        if (optCount > 1 && !multiOptions) {
          currentCriterion._setToNone();
        } else {
          currentCriterion.direction = updateCriterion.direction;
        }
      } else {
        currentCriterion.direction = updateCriterion.direction;
      }
      //
      if (optCount >= 1 && !multiOptions) {
        for (SortCriterion criterion in copyMap.values) {
          criterion._setToNone();
        }
      }
    }
    //
    block.data.sort();
    block.updateAllUIComponents(withoutFilters: true);
  }

  ///
  /// ```dart
  /// myItemSortCriteria.updateSortCriteria(
  ///   shuffledSortablePropNames: ['email', '+userName','-fullName'],
  /// );
  /// ```
  ///
  void updateSortCriteria({
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
      //
      if (!_nonSignedPropNames.contains(criterion.propName)) {
        throw Exception(
            "Invalid propName '${criterion.propName}' (Must be in $_nonSignedPropNames)");
      }
      updateCriteria.add(criterion);
    }
    //
    __updateSortCriteria(updateCriteria: updateCriteria);
  }

  int _compare(ITEM a, ITEM b) {
    for (SortCriterion criterion in _sortCriteria) {
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

  ///
  /// The return type must be int, double, bool, null or String.
  ///
  dynamic getValue({required ITEM item, required String propName});

  @override
  String toString() {
    return "multiOptions: $multiOptions ${_sortCriteria.toString()}";
  }
}
