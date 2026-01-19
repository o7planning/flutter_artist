part of '../core.dart';

abstract class SortModelBuilder<ITEM extends Object> {
  // Multi-sort criteria selection
  final bool clientSideMultiSort;
  final bool serverSideMultiSort;

  late final SortCriteriaStructure _structure;

  SortModelBuilder({
    required this.clientSideMultiSort,
    required this.serverSideMultiSort,
  }) {
    _structure = registerCriteriaStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  SortCriteriaStructure registerCriteriaStructure();

  // ***************************************************************************
  // ***************************************************************************

  String _getText({required String criterionNameX}) {
    SortCriterionDef? criterion = _structure._sortCriteriaMap[criterionNameX];
    if (criterion == null) {
      return criterionNameX;
    }
    String? translationKey = criterion.translationKey;
    if (translationKey == null) {
      return criterion.text;
    }
    return getTranslationText(translationKey: translationKey) ?? criterion.text;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The return type must be int, double, bool, null or String.
  ///
  dynamic getCriterionValueForClientSideSorting({
    required ITEM item,
    required String criterionName,
  });

  String? getTranslationText({required String translationKey});

  // ***************************************************************************
  // ***************************************************************************

  SortModel<ITEM> createSortModel({required SortingSide sortingSide}) {
    return sortingSide == SortingSide.server
        ? _ServerSideSortModel(sortModelBuilder: this)
        : _ClientSideSortModel(sortModelBuilder: this);
  }

  // ***************************************************************************
  // ***************************************************************************

  SortModel<ITEM> createServerSideSortModel() {
    return createSortModel(sortingSide: SortingSide.server);
  }

  // ***************************************************************************
  // ***************************************************************************

  SortModel<ITEM> createClientSideSortModel() {
    return createSortModel(sortingSide: SortingSide.client);
  }
}
