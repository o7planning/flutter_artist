part of '../core.dart';

abstract class SortModel<ITEM extends Object> {
  late final Block block;
  final SortModelBuilder<ITEM>? sortModelBuilder;

  Shelf get shelf => block.shelf;

  final SortMode sortMode;

  final SortingSide sortingSide;
  final List<SortCriterion> _criteria = [];
  final Map<String, SortCriterion> _sortCriteriaMap = {};

  List<SortCriterion> get criteria => List.unmodifiable(_criteria);

  late final ui = _SortUiComponents(sortModel: this);

  SortCriterion? get firstOrNullCriterion => _criteria.firstOrNull;

  SortModel._({
    required this.sortModelBuilder,
    required this.sortingSide,
  }) : sortMode = sortingSide == SortingSide.server
            ? sortModelBuilder?.serverSideSortMode ?? SortMode.single
            : sortModelBuilder?.clientSideSortMode ?? SortMode.single {
    int optCount = 0;
    if (sortModelBuilder != null) {
      SortModelStructure structure =
          sortModelBuilder!.registerSortModelStructure();
      for (SortCriterionDef criterionDef in structure._sortCriteriaMap.values) {
        SortDirection? sortDirection = sortingSide == SortingSide.server
            ? criterionDef.serverSideConfig.initialSortDirection
            : criterionDef.clientSideConfig.initialSortDirection;
        String text = sortModelBuilder!._getText(
          criterionName: criterionDef.criterionName,
        );
        SortCriterion criterion = SortCriterion._(
          direction: sortDirection,
          criterionName: criterionDef.criterionName,
          directionalSelectionOnly: sortingSide == SortingSide.server
              ? criterionDef.serverSideConfig.directionalSelectionOnly
              : criterionDef.clientSideConfig.directionalSelectionOnly,
          translationKey: criterionDef.translationKey,
          text: text,
        );
        //
        if (criterion.direction != null) {
          optCount++;
          if (optCount > 1 && sortMode == SortMode.single) {
            criterion._direction = null;
          }
        }
        //
        if (!_sortCriteriaMap.containsKey(criterion.criterionName)) {
          _criteria.add(criterion);
          _sortCriteriaMap[criterion.criterionName] = criterion;
        }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  SortCriterion? findFirstCriterionHasDirection() {
    return _criteria.where((c) => c._direction != null).firstOrNull;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Returns the criteria used for sorting.
  ///
  SortableCriteria getSortableCriteria() {
    List<SortableCriterion> list = _criteria
        .where((sc) => sc.hasDirection())
        .map(
          (sc) => SortableCriterion._(
            direction: sc.direction!,
            criterionName: sc.criterionName,
          ),
        )
        .toList();
    //
    if (sortMode == SortMode.single) {
      if (list.isEmpty) {
        return SortableCriteria._([]);
      } else {
        return SortableCriteria._([list.first]);
      }
    } else {
      return SortableCriteria._(list);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasDirection() {
    for (SortCriterion criterion in _criteria) {
      if (criterion.hasDirection()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> moveCriterion({
    required String movingCriterionName,
    required String destCriterionName,
  }) async {
    SortCriterion? moving = _sortCriteriaMap[movingCriterionName];
    SortCriterion? dest = _sortCriteriaMap[destCriterionName];
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

  // ***************************************************************************
  // ***************************************************************************

  Future<void> updateSortingCriterionByName({
    required String criterionName,
    required SortDirection? direction,
    required bool moveToFirst, // TODO-XXX: Do it!!
  }) async {
    print("criterionName: $criterionName");
    SortCriterion? criterion = _sortCriteriaMap[criterionName];
    print("criterion: $criterion");
    if (criterion == null) {
      return;
    }
    if (sortMode == SortMode.single) {
      for (SortCriterion sc in _criteria) {
        if (sc._direction != null) {
          // Backup Direction.
          sc._lastUsedDirection = sc._direction;
        }
        sc._direction = null;
      }
    }
    print("direction: $direction");
    criterion._direction = direction;
    if (direction != null) {
      criterion._lastUsedDirection = direction;
    }
    //
    await __applyChanges();
  }

  // ***************************************************************************
  // ***************************************************************************

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
      SortCriterion? criterion = _sortCriteriaMap[criterionName];
      if (criterion == null) {
        continue;
      }
      //
      newArrangementCriteria.add(criterion);
      //
      if (criterion.direction != null) {
        optCount++;
        if (optCount > 1 && sortMode == SortMode.single) {
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
      block.ui.updateAllUiComponents(
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
    final List<SortCriterion> criteriaList = [..._criteria];
    //
    int criterionSortedCount = 0;
    for (SortCriterion sc in criteriaList) {
      if (sc.direction == null) {
        continue;
      }
      if (sortMode == SortMode.single && criterionSortedCount >= 1) {
        break;
      }
      criterionSortedCount++;
      final int directionValue = sc.direction == SortDirection.asc ? 1 : -1;
      //
      Comparable? aValue = getComparisonValue(
        item: a,
        criterionName: sc.criterionName,
      );
      Comparable? bValue = getComparisonValue(
        item: b,
        criterionName: sc.criterionName,
      );
      if (aValue != null) {
        int x = aValue.compareTo(bValue);
        if (x != 0) {
          return x * directionValue;
        }
      } else if (bValue != null) {
        int x = -bValue.compareTo(aValue);
        if (x != 0) {
          return x * directionValue;
        }
      }
    }
    return 0;
  }

  // ***************************************************************************
  // ***************************************************************************

  Comparable? getComparisonValue({
    required ITEM item,
    required String criterionName,
  }) {
    return sortModelBuilder?.getComparisonValue(
      item: item,
      criterionName: criterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  String toString() {
    return "sortMode: $sortMode ${_criteria.toString()}";
  }
}
