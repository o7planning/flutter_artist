part of '../flutter_artist.dart';

class BlockData<
    ID extends Object,
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> {
  ///
  /// Owner block
  ///
  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_INPUT,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  final List<ITEM> _items = [];
  final List<ITEM> _selectedItems = [];
  final List<ITEM> _checkedItems = [];

  // ***************************************************************************

  List<ITEM> moveCurrentItemToEndOfList({
    required List<ITEM> itemList,
  }) {
    ITEM? currItem = this.__currentItem;
    if (currItem == null) {
      return itemList;
    }
    //
    List<ITEM> newList = [...itemList];
    final itemCount = newList.length;
    newList.removeWhere(
      (it) => block.getItemId(it) == block.getItemId(currItem),
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
    ITEM? currItem = this.__currentItem;
    bool contains = this.isCurrentItemChecked;
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
    ITEM? currItem = this.__currentItem;
    bool contains = this.isCurrentItemSelected;
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
      return [..._checkedItems];
    }
  }

  // ***************************************************************************

  bool get isCurrentItemChecked {
    ITEM? currentItem = this.__currentItem;
    if (currentItem == null) {
      return false;
    }
    return ItemsUtils.isListContainItem(
      item: currentItem,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************

  bool get isCurrentItemSelected {
    ITEM? currentItem = this.__currentItem;
    if (currentItem == null) {
      return false;
    }
    return ItemsUtils.isListContainItem(
      item: currentItem,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************

  Object? _currentParentItemId;

  FILTER_CRITERIA? _filterCriteria;

  int _filterCriteriaChangeCount = 0;

  PageData<ITEM>? _lastQueryResult;

  ActionResultState? _lastQueryResultState;

  late PageableData? _pageable;

  PageableData? get pageable => _pageable;

  late PaginationData? _pagination;

  _CurrentCoupleItem<ITEM, ITEM_DETAIL> __current = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );

  _CurrentCoupleItem<ITEM, ITEM_DETAIL> get current => __current;

  ITEM? get __currentItem => __current._item;

  ITEM_DETAIL? get __currentItemDetail => __current._itemDetail;

  late DataState _queryDataState;

  DataState _selectionDataState = DataState.pending;

  // ***************************************************************************
  // ***************************************************************************

  BlockData._(
    this.block,
    PageableData? pageable,
  )   : _pageable = pageable,
        _pagination = PaginationData.empty() {
    _queryDataState = block.isRoot ? DataState.pending : DataState.none;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({
    required DataState queryDataState,
  }) {
    _queryDataState = queryDataState;
    if (_queryDataState == DataState.error) {
      _lastQueryResultState = ActionResultState.fail;
      //
      // Update FilterCriteria:
      //
      __setNewFilterCriteria(null);
    }
    _items.clear();
    _selectedItems.clear();
    _checkedItems.clear();
    _setCurrentItemOnly(refreshedItem: null, refreshedItemDetail: null);
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
    if (newCurrentParentItemId != _currentParentItemId) {
      return true;
    }
    if (newFilterCriteria != _filterCriteria) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _sortItems() {
    try {
      if (block._itemSortCriteria != null) {
        _items.sort((a, b) => block._itemSortCriteria!._compare(a, b));
      }
    } catch (e) {
      print("Sort Error: $e");
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setToPending() {
    _queryDataState = DataState.pending;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Set item as current, and no more other actions (Insert, Update list).
  ///
  void _setCurrentItemOnly({
    required ITEM? refreshedItem,
    required ITEM_DETAIL? refreshedItemDetail,
  }) {
    final ITEM? oldItem = __current._item;
    final ITEM? newItem = refreshedItem;
    //
    __current = _CurrentCoupleItem(
      item: refreshedItem,
      itemDetail: refreshedItemDetail,
    );
    //
    final bool changed;
    if (oldItem == null && newItem == null) {
      changed = false;
    } else if (oldItem != null && newItem == null) {
      changed = true;
    } else if (oldItem == null && newItem != null) {
      changed = true;
    } else {
      changed = block.getItemId(oldItem!) == block.getItemId(newItem!);
    }
    if (changed) {
      if (block.formModel != null) {
        block.formModel!._triggerFilterCriteriaChanged();
      }
    }
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

  // ***************************************************************************
  // ***************************************************************************

  void _removeItem({
    required ITEM removeItem,
  }) {
    ItemsUtils.removeItemFromList(
      targetList: _items,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
    ItemsUtils.removeItemFromList(
      targetList: _checkedItems,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
    ItemsUtils.removeItemFromList(
      targetList: _selectedItems,
      removeItem: removeItem,
      getItemId: block.getItemId,
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
      getItemId: block.getItemId,
    );
    //
    _sortItems();
    //
    ItemsUtils.replaceItemInList(
      targetList: _checkedItems,
      replacementItem: item,
      getItemId: block.getItemId,
    );
    ItemsUtils.replaceItemInList(
      targetList: _selectedItems,
      replacementItem: item,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __appendItems({required List<ITEM> appendItems}) {
    ItemsUtils.appendItemsToList(
      appendItems: appendItems,
      targetList: _items,
      getItemId: block.getItemId,
    );
    //
    _sortItems();
    //
    ItemsUtils.replaceItemsInList(
      replacementItems: appendItems,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
    ItemsUtils.replaceItemsInList(
      replacementItems: appendItems,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateFrom({
    required ListBehavior forceListBehavior,
    required Object? currentParentItemId,
    required FILTER_CRITERIA? filterCriteria,
    required PageableData? pageable,
    required PageData<ITEM>? pageData,
    required DataState queryDataState,
    required ActionResultState queryResultState,
  }) {
    _lastQueryResultState = queryResultState;
    // Check if filterCriteria changed.
    if (forceListBehavior == ListBehavior.replace ||
        _currentParentItemId != currentParentItemId ||
        _filterCriteria != filterCriteria) {
      _items.clear();
    }
    //
    final PageData<ITEM> ap = pageData ?? DefaultPageData<ITEM>.empty();
    _pageable = pageable?.copy();
    if (_currentParentItemId != currentParentItemId ||
        _filterCriteria != filterCriteria) {
      _pagination = PaginationData.copy(ap.pagination);
    } else {
      // Query Error:
      if (queryResultState == ActionResultState.fail) {
        // No change _pagination:
      } else {
        _pagination = PaginationData.copy(ap.pagination);
      }
    }
    //
    _currentParentItemId = currentParentItemId;
    _lastQueryResult = pageData;
    _queryDataState = queryDataState;
    //
    // Update FilterCriteria:
    //
    __setNewFilterCriteria(filterCriteria);
    //
    // Append to _items:
    //
    __appendItems(appendItems: ap.items);
    // block.formModel?.data._formMode = FormMode.none;
  }
}
