part of '../core.dart';

class _QBlock {
  _QShelf get xShelf => xFilterModel.xShelf;
  final Block block;

  late final _QBlock? parentXBlock;
  final List<_QBlock> childXBlocks = [];

  final _QFilterModel xFilterModel;
  final _QFormModel? xFormModel;

  String get name => block.name;

  // Options:

  QryHint __forceQuery = QryHint.none;
  bool __forceReloadItem = false;
  QueryType __queryType = QueryType.realQuery;
  QueryType get queryType => __queryType;

  ListBehavior? __listBehavior;
  SuggestedSelection? __suggestedSelection;
  PostQueryBehavior? __postQueryBehavior;
  PageableData? __pageable;

  // ***************************************************************************

  QryHint get forceQuery => __forceQuery;
  bool get forceReloadItem => __forceReloadItem;
  SuggestedSelection? get suggestedSelection => __suggestedSelection;
  PageableData? get pageable => __pageable;

  // ***************************************************************************
  // ***************************************************************************

  _QBlock({
    required this.block,
    required this.xFilterModel,
    required this.xFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  void setForceQuery(QryHint forceQuery) {
    __forceQuery = forceQuery;
  }

  void setForceReloadItem() {
    __forceReloadItem = true;
  }

  ListBehavior get listBehavior {
    // TODO: Xem lai gia tri mac dinh
    return __listBehavior ?? ListBehavior.replace;
  }

  set suggestedSelection(value) {
    __suggestedSelection = value;
  }

  PostQueryBehavior get postQueryBehavior {
    return __postQueryBehavior ?? FlutterArtist.defaultPostQueryBehavior;
  }

  void setOptions({
    required QueryType queryType,
    required ListBehavior? listBehavior,
    required SuggestedSelection? suggestedSelection,
    required PostQueryBehavior? postQueryBehavior,
    required PageableData? pageable,
  }) {
    __queryType = queryType;
    __listBehavior = listBehavior;
    __suggestedSelection = suggestedSelection;
    __postQueryBehavior = postQueryBehavior;
    __pageable = pageable;
  }
}
