part of '../flutter_artist.dart';

class _InternalBlockData<
        ID extends Object,
        ITEM extends Object,
        ITEM_DETAIL extends Object,
        FILTER_INPUT extends FilterInput,
        FILTER_CRITERIA extends FilterCriteria,
        EXTRA_INPUT extends ExtraInput>
    extends BlockData<ID, ITEM, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA,
        EXTRA_INPUT> {
  bool __isTemporaryMode = false;

  DataState __dataStateBk = DataState.pending;

  _CurrentCoupleItem<ITEM, ITEM_DETAIL> __currentBk = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );

  final List<ITEM> __itemsBk = [];
  final List<ITEM> __checkedItemsBk = [];

  Object? __currentParentItemIdBk;

  FILTER_CRITERIA? __filterCriteriaBk;

  PageData<ITEM>? __lastQueryResultBk;

  PaginationData? __paginationBk;

  _InternalBlockData.empty(
    Block<ID, ITEM, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA, EXTRA_INPUT>
        block,
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
      __filterCriteriaBk = _filterCriteria;
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
      __filterCriteriaBk = null;
      __lastQueryResultBk = null;
      //
      block.blockForm?.data._applyNewState();
    }
  }

  @override
  void _restore() {
    if (__isTemporaryMode) {
      __current = __currentBk;
      _dataState = __dataStateBk;
      _items
        ..clear()
        ..addAll(__itemsBk);
      _checkedItems
        ..clear()
        ..addAll(__checkedItemsBk);
      _pagination = __paginationBk;
      _currentParentItemId = __currentParentItemIdBk;
      _filterCriteria = __filterCriteriaBk;
      _lastQueryResult = __lastQueryResultBk;
      //
      block.blockForm?.data._restore();
      //
      _applyNewState();
    }
  }
}
