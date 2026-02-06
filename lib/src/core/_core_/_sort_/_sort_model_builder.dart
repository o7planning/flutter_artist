part of '../core.dart';

abstract class SortModelBuilder<ITEM extends Object> {
  // Multi-sort criteria selection
  final bool clientSideMultiSort;
  final bool serverSideMultiSort;

  late final SortModelStructure _structure;

  SortModelBuilder({
    required this.clientSideMultiSort,
    required this.serverSideMultiSort,
  }) {
    _structure = registerSortModelStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  SortModelStructure registerSortModelStructure();

  // ***************************************************************************
  // ***************************************************************************

  String _getText({required String tildeCriterionName}) {
    SortCriterionDef? criterion =
        _structure._sortCriteriaMap[tildeCriterionName];
    if (criterion == null) {
      return tildeCriterionName;
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
