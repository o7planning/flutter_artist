part of '../core.dart';

abstract class SortModelTemplate<ITEM extends Object> {
  // Multi-sort criteria selection
  final bool clientMultiSortCriteriaSelection;
  final bool serverMultiSortCriteriaSelection;

  late final SortCriteriaStructure _structure;

  SortModelTemplate({
    this.clientMultiSortCriteriaSelection = false,
    this.serverMultiSortCriteriaSelection = false,
  }) {
    _structure = registerCriteriaStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  SortCriteriaStructure registerCriteriaStructure();

  // ***************************************************************************
  // ***************************************************************************

  String _getText({required String criterionName}) {
    SortCriterionDef? criterion = _structure._sortCriteriaMap[criterionName];
    if (criterion == null) {
      return criterionName;
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
        ? _ServerSideSortModel(
            sortModelTemplate: this,
          )
        : _ClientSideSortModel(
            sortModelTemplate: this,
          );
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
