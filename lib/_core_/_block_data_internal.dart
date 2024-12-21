part of '../flutter_artist.dart';

class _InternalBlockData<I extends Object, D extends Object,
    S extends FilterSnapshot> extends BlockData<I, D, S> {
  bool __isTemporaryMode = false;

  DataState __dataStateBk = DataState.pending;

  _CurrentCoupleItem<I, D> __currentBk = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );

  final List<I> __itemsBk = [];
  final List<I> __checkedItemsBk = [];

  String? __currentParentItemIdBk;

  S? __currentFilterSnapshotBk;

  PageData<I>? __lastQueryResultBk;

  PaginationData? __paginationBk;

  _InternalBlockData.empty(
    Block<I, D, S> block,
    PageableData? pageable,
  ) : super(
          block: block,
          items: [],
          pageable: pageable,
          pagination: PaginationData.empty(),
        );

  @override
  void _backup() {
    if (!__isTemporaryMode) {
      __isTemporaryMode = true;
      __dataStateBk = _dataState;
      __currentBk = __current;
      __itemsBk
        ..clear()
        ..addAll(_items);
      __checkedItemsBk
        ..clear()
        ..addAll(_checkedItems);
      __paginationBk = PaginationData.copy(_pagination);
      __currentParentItemIdBk = _currentParentItemId;
      __currentFilterSnapshotBk = _currentFilterSnapshot;
      __lastQueryResultBk = _lastQueryResult;
      //
      block.blockForm?.data._backup();
    }
  }

  @override
  void _applyNewState() {
    if (__isTemporaryMode) {
      __isTemporaryMode = false;
      __currentBk = _CurrentCoupleItem(item: null, itemDetail: null);
      __dataStateBk = DataState.pending; // TODO: Xem lai. ???
      __itemsBk.clear();
      __checkedItemsBk.clear();
      __paginationBk = null;
      __currentParentItemIdBk = null;
      __currentFilterSnapshotBk = null;
      __lastQueryResultBk = null;
      //
      block.blockForm?.data._applyNewState();
    }
  }

  @override
  void _restore() {
    if (__isTemporaryMode) {
      __current = __currentBk;
      // __currentItem = __currentItemBk;
      // __currentItemDetail = __currentItemDetailBk;
      _dataState = __dataStateBk;
      _items
        ..clear()
        ..addAll(__itemsBk);
      _checkedItems
        ..clear()
        ..addAll(__checkedItemsBk);
      _pagination = __paginationBk;
      _currentParentItemId = __currentParentItemIdBk;
      _currentFilterSnapshot = __currentFilterSnapshotBk;
      _lastQueryResult = __lastQueryResultBk;
      //
      block.blockForm?.data._restore();
      //
      _applyNewState();
    }
  }
}
