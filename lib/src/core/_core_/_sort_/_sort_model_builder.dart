part of '../core.dart';

abstract class SortModelBuilder<ITEM extends Object> {
  final SortMode clientSideSortMode;
  final SortMode serverSideSortMode;

  late final SortModelStructure _structure;

  SortModelBuilder({
    required this.clientSideSortMode,
    required this.serverSideSortMode,
  }) {
    _structure = defineSortModelStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  SortModelStructure defineSortModelStructure();

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
  /// The return type must be int, double, bool, null, String or Comparable.
  ///
  Comparable? getComparisonValue({
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
