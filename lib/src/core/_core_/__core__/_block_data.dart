part of '../core.dart';

class _BlockData<
ID extends Comparable,
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>,
FILTER_INPUT extends FilterInput,
FILTER_CRITERIA extends FilterCriteria,
ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData,
FORM_INPUT extends FormInput> {
  ///
  /// Owner block
  ///
  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_INPUT,
      FILTER_CRITERIA,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> block;

  final List<ITEM> _items = [];
  final List<ITEM> _selectedItems = [];
  final List<ITEM> _checkedItems = [];

  final List<ITEM> __itemsManualArrangementBk = [];

  // ***************************************************************************

  Object? _parentBlockCurrentItemId;

  FilterCriteriaMappedValue<FILTER_CRITERIA>? _filterCriteriaMappedValue;

  PageData<ITEM>? _lastQueryResult;

  ActionResultState? _lastQueryResultState;

  ListUpdateStrategy? _lastForceListUpdateStrategy;

  late final Pageable? _initialPageable;

  late Pageable? _pageable;

  Pageable? get pageable => _pageable;

  ///
  /// The Pageable will be set for [_pageable] when [Block.queryEmpty()] is called.
  ///
  Pageable? get _emptyPageable => _initialPageable;

  late BlockNativeQueryMode _nativeQueryMode;

  BlockNativeQueryMode get nativeQueryMode => _nativeQueryMode;

  late PaginationInfo? _paginationInfo;

  _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL> __current = _BlockItem2Wrap.ofNull();

  _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL> get current => __current;

  late BlockDataState _blockDataState;

  BlockDataState _selectionDataState = BlockDataStatePending();

  // ***************************************************************************
  // ***************************************************************************

  void _updateStateAfterQueryError({
    required BlockDataState newBlockDataState,
  }) {
    _lastQueryResultState = ActionResultState.fail;
    _blockDataState = newBlockDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _backupManualArrangementBeforeQueryIfNeed() {
    if (block.effectiveConfig.clientSideSortStrategy == SortStrategy.manual) {
      __itemsManualArrangementBk
        ..clear()
        ..addAll(_items);
    }
  }

  void __restoreManualArrangementIfNeed() {
    if (block.effectiveConfig.clientSideSortStrategy == SortStrategy.manual) {
      // TODO...
    }
  }

  // ***************************************************************************

  List<ITEM> moveCurrentItemToEndOfList({
    required List<ITEM> itemList,
  }) {
    ITEM? currItem = __current._item;
    if (currItem == null) {
      return itemList;
    }
    //
    List<ITEM> newList = [...itemList];
    final itemCount = newList.length;
    newList.removeWhere(
          (it) =>
      block._getItemIdInternal(it) == block._getItemIdInternal(currItem),
    );
    if (itemCount > newList.length) {
      newList.add(currItem);
    }
    return newList;
  }

  // ***************************************************************************

  List<ITEM> getCheckedItems({
    required CurrentItemInclusion currentItemInclusion,
  }) {
    ITEM? currItem = __current._item;
    bool contains = isCurrentItemChecked;
    //
    //
    if (currItem != null) {
      List<ITEM> chkItems =
      _checkedItems.where((it) => it != currItem).toList();
      switch (currentItemInclusion) {
        case CurrentItemInclusion.exclude: // withoutCurrentItem
          break;
        case CurrentItemInclusion.ifMatch: // withCurrentIfChecked
          if (contains) {
            chkItems.add(currItem);
          }
        case CurrentItemInclusion.include: // withCurrentItem
          chkItems.add(currItem);
      }
      return chkItems;
    } else {
      return [..._checkedItems];
    }
  }

  //
  // ***************************************************************************

  List<ITEM> getSelectedItems({
    required CurrentItemInclusion currentItemInclusion,
  }) {
    ITEM? currItem = __current._item;
    bool contains = isCurrentItemSelected;
    //
    if (currItem != null) {
      List<ITEM> selItems =
      _selectedItems.where((it) => it != currItem).toList();
      switch (currentItemInclusion) {
        case CurrentItemInclusion.exclude: // withoutCurrentItem
          break;
        case CurrentItemInclusion.ifMatch: // withCurrentIfSelected
          if (contains) {
            selItems.add(currItem);
          }
        case CurrentItemInclusion.include: // withCurrentItem
          selItems.add(currItem);
      }
      return selItems;
    } else {
      return [..._selectedItems];
    }
  }

  // ***************************************************************************

  bool get isCurrentItemChecked {
    ITEM? currItem = __current._item;
    if (currItem == null) {
      return false;
    }
    return FaItemsUtils.isListContainItem(
      item: currItem,
      targetList: _checkedItems,
      getItemId: block._getItemIdInternal,
    );
  }

  // ***************************************************************************

  bool get isCurrentItemSelected {
    ITEM? currItem = __current._item;
    if (currItem == null) {
      return false;
    }
    return FaItemsUtils.isListContainItem(
      item: currItem,
      targetList: _selectedItems,
      getItemId: block._getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  _BlockData._({
    required this.block,
    required Pageable? pageable,
    required BlockNativeQueryMode nativeQueryMode,
  })
      : _pageable = pageable,
        _nativeQueryMode = nativeQueryMode,
        _initialPageable = pageable,
        _paginationInfo = PaginationInfo.empty() {
    _blockDataState =
    block.isRoot ? BlockDataStatePending() : BlockDataStateNone();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearItemsWithDataState({
    required BlockDataState blockDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
    required bool resetRefreshItemCondition,
  }) {
    _blockDataState = blockDataState;
    if (resetSyncSessionState) {
      block._resetSyncSessionState(executionTrace: null);
    }
    if (resetRefreshItemCondition) {
      // TODO:..
    }
    // TODO: OLD Code: _blockDataState == DataState.error
    final hasError = false;
    if (hasError) {
      _lastQueryResultState = ActionResultState.fail;
      //
      // Update FilterCriteria:
      //
      if (errorInFilter) {
        __setNewFilterCriteria(filterCriteriaMappedValue: null);
      }
    }
    //
    _items.clear();
    _selectedItems.clear();
    _checkedItems.clear();
    //
    _setCurrentItemOnly(
      id: null,
      refreshedItem: null,
      refreshedItemDetail: null,
    );
    // TODO: set _lastQueryResult null khi FilterCriteria thay doi?
    // _lastQueryResult = null;
    // _filterCriteria = filterCriteria;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isFilterCriteriaMappedValueChanged({
    required FilterCriteriaMappedValue<FILTER_CRITERIA>
    newFilterCriteriaMappedValue,
  }) {
    if (newFilterCriteriaMappedValue != _filterCriteriaMappedValue) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clientSideSortItems() {
    try {
      switch (block.effectiveConfig.clientSideSortStrategy) {
        case SortStrategy.none:
        // Do nothing
          break;
        case SortStrategy.modelBased:
          SortModel<ITEM>? sortModel = block.clientSideSortModel;
          if (sortModel != null) {
            _items.sort((a, b) => sortModel._compare(a, b));
          }
        case SortStrategy.manual:
        // TODO
          break;
      }
    } catch (e, _) {
      print("Sort Error: $e");
      rethrow;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setToPending() {
    _blockDataState = BlockDataStatePending();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Set item as current, and no more other actions (Insert, Update list).
  ///
  void _setCurrentItemOnly({
    required ID? id,
    required ITEM? refreshedItem,
    required ITEM_DETAIL? refreshedItemDetail,
  }) {
    final ID? oldId = __current._id;
    //
    __current = id == null
        ? _BlockItem2Wrap.ofNull()
        : _BlockItem2Wrap(
      id: id,
      item: refreshedItem!,
      itemDetail: refreshedItemDetail!,
    );
    //
    final bool changed = oldId != id;
    //
    if (changed) {
      block.debug._currentItemChangeCount++;
      if (block.formModel != null) {
        block.formModel!._triggerItemIdChanged();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeItem({
    required ITEM removeItem,
  }) {
    FaItemsUtils.removeItemFromList(
      targetList: _items,
      removeItem: removeItem,
      getItemId: block._getItemIdInternal,
    );
    FaItemsUtils.removeItemFromList(
      targetList: _checkedItems,
      removeItem: removeItem,
      getItemId: block._getItemIdInternal,
    );
    FaItemsUtils.removeItemFromList(
      targetList: _selectedItems,
      removeItem: removeItem,
      getItemId: block._getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _insertOrReplaceItem({
    required ITEM item,
    // required ITEM_DETAIL itemDetail,
  }) {
    FaItemsUtils.insertOrReplaceItemInList(
      targetList: _items,
      item: item,
      getItemId: block._getItemIdInternal,
    );
    //
    _clientSideSortItems();
    //
    FaItemsUtils.replaceItemInList(
      targetList: _checkedItems,
      replacementItem: item,
      getItemId: block._getItemIdInternal,
    );
    FaItemsUtils.replaceItemInList(
      targetList: _selectedItems,
      replacementItem: item,
      getItemId: block._getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateData({
    required ExecutionTrace executionTrace,
    required ListUpdateStrategy forceListUpdateStrategy,
    required _ProcessedQueryResult<ID, ITEM, FILTER_CRITERIA>
    processedQueryResult,
    required List<ID> removeItemIds,
  }) {
    _lastQueryResultState = processedQueryResult.queryResultState;
    _lastForceListUpdateStrategy = forceListUpdateStrategy;
    bool cleared = false;
    // Check if filterCriteria changed.
    if (forceListUpdateStrategy == ListUpdateStrategy.replace ||
        _parentBlockCurrentItemId !=
            processedQueryResult.parentBlockCurrentItemId ||
        _filterCriteriaMappedValue !=
            processedQueryResult.usedXFilterCriteria) {
      _items.clear();
      cleared = true;
    }
    //
    final PageData<ITEM>? lastQueriedPageData =
    processedQueryResult.queriedItemList == null
        ? null
        : PageData<ITEM>(
        items: processedQueryResult.queriedItemList!,
        paginationInfo: processedQueryResult.queriedPaginationInfo);

    final PageData<ITEM> ap = lastQueriedPageData ?? PageData<ITEM>.empty();
    _pageable = processedQueryResult.usedPageable?.copy();
    if (_parentBlockCurrentItemId !=
        processedQueryResult.parentBlockCurrentItemId ||
        _filterCriteriaMappedValue !=
            processedQueryResult.usedXFilterCriteria) {
      _paginationInfo = PaginationInfo.copy(ap.paginationInfo);
    } else {
      // Query Error:
      if (processedQueryResult.queryResultState == ActionResultState.fail) {
        // No change _pagination:
      } else {
        _paginationInfo = PaginationInfo.copy(ap.paginationInfo);
      }
    }
    //
    _parentBlockCurrentItemId = processedQueryResult.parentBlockCurrentItemId;
    _lastQueryResult = lastQueriedPageData;
    _blockDataState = processedQueryResult.newBlockDataState;
    //
    // Update FilterCriteria:
    //
    __setNewFilterCriteria(
      filterCriteriaMappedValue: processedQueryResult.usedXFilterCriteria,
    );
    //
    // Append to _items:
    //
    __appendQueriedItems(
      executionTrace: executionTrace,
      processedQueryResult: processedQueryResult,
      removeItemIds: removeItemIds,
    );
    // block.formModel?.data._formMode = FormMode.none;
    if (cleared) {
      __restoreManualArrangementIfNeed();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __appendQueriedItems({
    required ExecutionTrace executionTrace,
    required _ProcessedQueryResult<ID, ITEM, FILTER_CRITERIA>
    processedQueryResult,
    required List<ID> removeItemIds,
  }) {
    if (processedQueryResult.errorItems.isNotEmpty) {
      FaItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.errorItems,
        targetList: _items,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.errorItems,
        targetList: _selectedItems,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.errorItems,
        targetList: _checkedItems,
        getItemId: block._getItemIdInternal,
      );
    }
    //
    if (processedQueryResult.invalidItems.isNotEmpty) {
      FaItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.invalidItems,
        targetList: _items,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.invalidItems,
        targetList: _selectedItems,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.invalidItems,
        targetList: _checkedItems,
        getItemId: block._getItemIdInternal,
      );
    }
    //
    if (processedQueryResult.validItems.isNotEmpty) {
      FaItemsUtils.appendItemsToList(
        appendItems: processedQueryResult.validItems,
        targetList: _items,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.replaceItemsInList(
        replacementItems: processedQueryResult.validItems,
        targetList: _selectedItems,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.replaceItemsInList(
        replacementItems: processedQueryResult.validItems,
        targetList: _checkedItems,
        getItemId: block._getItemIdInternal,
      );
    }
    if (removeItemIds.isNotEmpty) {
      FaItemsUtils.removeItemsFromListByIds(
        removeItemIds: removeItemIds,
        targetList: _items,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.removeItemsFromListByIds(
        removeItemIds: removeItemIds,
        targetList: _selectedItems,
        getItemId: block._getItemIdInternal,
      );
      FaItemsUtils.removeItemsFromListByIds(
        removeItemIds: removeItemIds,
        targetList: _checkedItems,
        getItemId: block._getItemIdInternal,
      );
    }
    //
    _clientSideSortItems();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setNewFilterCriteria({
    required FilterCriteriaMappedValue<FILTER_CRITERIA>?
    filterCriteriaMappedValue,
  }) {
    final bool changed =
        _filterCriteriaMappedValue != filterCriteriaMappedValue;
    _filterCriteriaMappedValue = filterCriteriaMappedValue;
    if (changed) {
      block.debug._filterCriteriaChangeCount++;
      if (block.formModel != null) {
        block.formModel!._triggerFilterCriteriaChanged();
      }
    }
  }
}
