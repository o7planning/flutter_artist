part of '../core.dart';

class _BlockData<
    ID extends Object,
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria,
    FORM_RELATED_DATA extends FormRelatedData,
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
      FORM_RELATED_DATA> block;

  final List<ITEM> _items = [];
  final List<ITEM> _selectedItems = [];
  final List<ITEM> _checkedItems = [];

  final List<ITEM> __itemsManualArrangementBk = [];

  // ***************************************************************************

  void _backupManualArrangementBeforeQueryIfNeed() {
    if (block.config.clientSideSortMode == ClientSideSortMode.manualSorting) {
      __itemsManualArrangementBk
        ..clear()
        ..addAll(_items);
    }
  }

  void __restoreManualArrangementIfNeed() {
    if (block.config.clientSideSortMode == ClientSideSortMode.manualSorting) {
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
    required CurrentItemChkInclusion currentItemInclusion,
  }) {
    ITEM? currItem = __current._item;
    bool contains = isCurrentItemChecked;
    //
    //
    if (currItem != null) {
      List<ITEM> chkItems =
          _checkedItems.where((it) => it != currItem).toList();
      switch (currentItemInclusion) {
        case CurrentItemChkInclusion.withoutCurrentItem:
          break;
        case CurrentItemChkInclusion.withCurrentIfChecked:
          if (contains) {
            chkItems.add(currItem);
          }
        case CurrentItemChkInclusion.withCurrentItem:
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
    required CurrentItemSelInclusion currentItemInclusion,
  }) {
    ITEM? currItem = __current._item;
    bool contains = isCurrentItemSelected;
    //
    if (currItem != null) {
      List<ITEM> selItems =
          _selectedItems.where((it) => it != currItem).toList();
      switch (currentItemInclusion) {
        case CurrentItemSelInclusion.withoutCurrentItem:
          break;
        case CurrentItemSelInclusion.withCurrentIfSelected:
          if (contains) {
            selItems.add(currItem);
          }
        case CurrentItemSelInclusion.withCurrentItem:
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
    return ItemsUtils.isListContainItem(
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
    return ItemsUtils.isListContainItem(
      item: currItem,
      targetList: _selectedItems,
      getItemId: block._getItemIdInternal,
    );
  }

  // ***************************************************************************

  Object? _parentBlockCurrentItemId;

  FILTER_CRITERIA? _filterCriteria;

  int _filterCriteriaChangeCount = 0;

  PageData<ITEM>? _lastQueryResult;

  ActionResultState? _lastQueryResultState;

  late final Pageable? _initialPageable;

  late Pageable? _pageable;

  Pageable? get pageable => _pageable;

  ///
  /// The Pageable will be set for [_pageable] when [Block.queryEmpty()] is called.
  ///
  Pageable? get _emptyPageable => _initialPageable;

  late PaginationInfo? _paginationInfo;

  int _currentItemChangeCount = 0;

  _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL> __current = _BlockItem2Wrap.ofNull();

  _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL> get current => __current;

  late DataState _blockDataState;

  DataState _selectionDataState = DataState.pending;

  // ***************************************************************************
  // ***************************************************************************

  _BlockData._(
    this.block,
    Pageable? pageable,
  )   : _pageable = pageable,
        _initialPageable = pageable,
        _paginationInfo = PaginationInfo.empty() {
    _blockDataState = block.isRoot ? DataState.pending : DataState.none;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearItemsWithDataState({
    required DataState qryDataState,
    required bool errorInFilter,
  }) {
    _blockDataState = qryDataState;
    if (_blockDataState == DataState.error) {
      _lastQueryResultState = ActionResultState.fail;
      //
      // Update FilterCriteria:
      //
      if (errorInFilter) {
        __setNewFilterCriteria(null);
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

  bool _isParentOrFilterCriteriaChanged({
    required Object? newCurrentParentItemId,
    required FILTER_CRITERIA newFilterCriteria,
  }) {
    if (newCurrentParentItemId != _parentBlockCurrentItemId) {
      return true;
    }
    if (newFilterCriteria != _filterCriteria) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clientSideSortItems() {
    try {
      switch (block.config.clientSideSortMode) {
        case ClientSideSortMode.none:
          // Do nothing
          break;
        case ClientSideSortMode.modelBasedSorting:
          SortModel<ITEM>? sortModel = block.clientSideSortModel;
          if (sortModel != null) {
            _items.sort((a, b) => sortModel._compare(a, b));
          }
        case ClientSideSortMode.manualSorting:
          // TODO
          break;
      }
    } catch (e, stackTrace) {
      print("Sort Error: $e");
      print(stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setToPending() {
    _blockDataState = DataState.pending;
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
      _currentItemChangeCount++;
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
    ItemsUtils.removeItemFromList(
      targetList: _items,
      removeItem: removeItem,
      getItemId: block._getItemIdInternal,
    );
    ItemsUtils.removeItemFromList(
      targetList: _checkedItems,
      removeItem: removeItem,
      getItemId: block._getItemIdInternal,
    );
    ItemsUtils.removeItemFromList(
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
    ItemsUtils.insertOrReplaceItemInList(
      targetList: _items,
      item: item,
      getItemId: block._getItemIdInternal,
    );
    //
    _clientSideSortItems();
    //
    ItemsUtils.replaceItemInList(
      targetList: _checkedItems,
      replacementItem: item,
      getItemId: block._getItemIdInternal,
    );
    ItemsUtils.replaceItemInList(
      targetList: _selectedItems,
      replacementItem: item,
      getItemId: block._getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateData({
    required MasterFlowItem masterFlowItem,
    required ItemListMode forceItemListMode,
    required _ProcessedQueryResult<ID, ITEM, FILTER_CRITERIA>
        processedQueryResult,
  }) {
    _lastQueryResultState = processedQueryResult.queryResultState;
    bool cleared = false;
    // Check if filterCriteria changed.
    if (forceItemListMode == ItemListMode.replace ||
        _parentBlockCurrentItemId !=
            processedQueryResult.parentBlockCurrentItemId ||
        _filterCriteria != processedQueryResult.usedFilterCriteria) {
      _items.clear();
      cleared = true;
    }
    //
    final PageData<ITEM> ap =
        processedQueryResult.queriedPageData ?? DefaultPageData<ITEM>.empty();
    _pageable = processedQueryResult.usedPageable?.copy();
    if (_parentBlockCurrentItemId !=
            processedQueryResult.parentBlockCurrentItemId ||
        _filterCriteria != processedQueryResult.usedFilterCriteria) {
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
    _lastQueryResult = processedQueryResult.queriedPageData;
    _blockDataState = processedQueryResult.newBlockDataState;
    //
    // Update FilterCriteria:
    //
    __setNewFilterCriteria(processedQueryResult.usedFilterCriteria);
    //
    // Append to _items:
    //
    __appendQueriedItems(
      masterFlowItem: masterFlowItem,
      processedQueryResult: processedQueryResult,
    );
    // block.formModel?.data._formMode = FormMode.none;
    if (cleared) {
      __restoreManualArrangementIfNeed();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __appendQueriedItems({
    required MasterFlowItem masterFlowItem,
    required _ProcessedQueryResult<ID, ITEM, FILTER_CRITERIA>
        processedQueryResult,
  }) {
    if (processedQueryResult.errorItems.isNotEmpty) {
      ItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.errorItems,
        targetList: _items,
        getItemId: block._getItemIdInternal,
      );
      ItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.errorItems,
        targetList: _selectedItems,
        getItemId: block._getItemIdInternal,
      );
      ItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.errorItems,
        targetList: _checkedItems,
        getItemId: block._getItemIdInternal,
      );
    }
    //
    if (processedQueryResult.invalidItems.isNotEmpty) {
      ItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.invalidItems,
        targetList: _items,
        getItemId: block._getItemIdInternal,
      );
      ItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.invalidItems,
        targetList: _selectedItems,
        getItemId: block._getItemIdInternal,
      );
      ItemsUtils.removeItemsFromList(
        removeItems: processedQueryResult.invalidItems,
        targetList: _checkedItems,
        getItemId: block._getItemIdInternal,
      );
    }
    //
    if (processedQueryResult.validItems.isNotEmpty) {
      ItemsUtils.appendItemsToList(
        appendItems: processedQueryResult.validItems,
        targetList: _items,
        getItemId: block._getItemIdInternal,
      );
      ItemsUtils.replaceItemsInList(
        replacementItems: processedQueryResult.validItems,
        targetList: _selectedItems,
        getItemId: block._getItemIdInternal,
      );
      ItemsUtils.replaceItemsInList(
        replacementItems: processedQueryResult.validItems,
        targetList: _checkedItems,
        getItemId: block._getItemIdInternal,
      );
    }
    //
    _clientSideSortItems();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setNewFilterCriteria(FILTER_CRITERIA? newFilterCriteria) {
    final bool changed = _filterCriteria != newFilterCriteria;
    _filterCriteria = newFilterCriteria;
    if (changed) {
      _filterCriteriaChangeCount++;
      if (block.formModel != null) {
        block.formModel!._triggerFilterCriteriaChanged();
      }
    }
  }
}
