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

  late final List<ITEM> _items;
  final List<ITEM> _selectedItems = [];
  final List<ITEM> _checkedItems = [];

  ///
  /// return a copied list of items.
  ///
  List<ITEM> get items {
    return [..._items];
  }

  // ***************************************************************************

  List<ITEM> moveCurrentItemToEndOfList({
    required List<ITEM> itemList,
  }) {
    ITEM? currItem = this.currentItem;
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
    ITEM? currItem = this.currentItem;
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
    ITEM? currItem = this.currentItem;
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
    ITEM? currentItem = this.currentItem;
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
    ITEM? currentItem = this.currentItem;
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

  ///
  /// return a copied list of checked items.
  ///
  List<ITEM> get checkedItems {
    return [..._checkedItems];
  }

  ///
  /// return a copied list of selected items.
  ///
  List<ITEM> get selectedItems {
    return [..._selectedItems];
  }

  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  Object? _currentParentItemId;

  FILTER_CRITERIA? _filterCriteria;

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  PageData<ITEM>? _lastQueryResult;

  ///
  /// ```dart
  /// if(thisBlock.data.lastQueryResult == null) {
  ///   ...
  /// } else if(thisBlock.data.lastQueryResult is YourType) {
  ///   ...
  /// } else {
  ///   // Empty PageData<I>.
  ///   // Occurs if there is no "Item" currently selected on the parent Block
  ///   // or this Block was previously in Lazy Query State.
  /// }
  /// ```
  ///
  PageData<ITEM>? get lastQueryResult => _lastQueryResult;

  late PageableData? _pageable;

  PageableData? get pageable => _pageable;

  late PaginationData? _pagination;

  PaginationData? get pagination => PaginationData.copy(_pagination);

  _CurrentCoupleItem<ITEM, ITEM_DETAIL> __current = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );

  ITEM? get currentItem => __current._item;

  ITEM_DETAIL? get currentItemDetail => __current._itemDetail;

  late DataState _queryDataState  ;

  DataState get queryDataState => _queryDataState;

  DataState _selectionDataState = DataState.pending;

  DataState get selectionDataState => _selectionDataState;

  // ***************************************************************************
  // ***************************************************************************

  BlockData._(
    this.block,
    PageableData? pageable,
  )   : _items = [],
        _pageable = pageable,
        _pagination = PaginationData.empty() {
    _queryDataState = block.isRoot?  DataState.pending:DataState.none;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearWithDataState({
    required DataState queryDataState,
  }) {
    _queryDataState = queryDataState;
    _items.clear();
    _selectedItems.clear();
    _checkedItems.clear();
    _setCurrentItemOnly(refreshedItem: null, refreshedItemDetail: null);
    _lastQueryResult = null;
    // _filterCriteria = filterCriteria;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isXCriteriaChanged({
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

  void sort() {
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

  void setToPending() {
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
    __current = _CurrentCoupleItem(
      item: refreshedItem,
      itemDetail: refreshedItemDetail,
    );
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
    required ITEM_DETAIL itemDetail,
  }) {
    ItemsUtils.insertOrReplaceItemInList(
      targetList: _items,
      item: item,
      getItemId: block.getItemId,
    );
    //
    sort();
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
    sort();
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
  }) {
    // Check if filterCriteria changed.
    if (forceListBehavior == ListBehavior.replace ||
        _currentParentItemId != currentParentItemId ||
        _filterCriteria != filterCriteria) {
      _items.clear();
    }
    //
    PageData<ITEM> ap = pageData ?? DefaultPageData<ITEM>.empty();
    //
    _currentParentItemId = currentParentItemId;
    _filterCriteria = filterCriteria;
    _lastQueryResult = pageData;
    _queryDataState = queryDataState;
    //
    // Append to _items:
    //
    __appendItems(appendItems: ap.items);
    //
    _pageable = pageable?.copy();
    _pagination = PaginationData.copy(ap.pagination);
    //
    block.formModel?.data._formMode = FormMode.none;
  }

  // ***************************************************************************
  // ******* PUBLIC ITEM PROPERTIES ********************************************
  // ***************************************************************************

  bool isSame({
    required ITEM? item1,
    required ITEM? item2,
  }) {
    if (item1 == null && item2 == null) {
      return true;
    }
    if (item1 != null && item2 != null) {
      return block.getItemId(item1) == block.getItemId(item2);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? get firstItem {
    return _items.firstOrNull;
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? get lastItem {
    return _items.lastOrNull;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The next item of the current item.
  /// Return null if no current item or the current item is the last item.
  ///
  ITEM? get nextSiblingItem {
    if (currentItem == null) {
      return null;
    }
    return findNextSiblingItem(item: currentItem!);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The previous item of the current item.
  /// Return null if no current item or the current item is the first item.
  ///
  ITEM? get previousSiblingItem {
    if (currentItem == null) {
      return null;
    }
    return findPreviousSiblingItem(item: currentItem!);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get hasPreviousItem => previousSiblingItem != null;

  // ***************************************************************************
  // ***************************************************************************

  bool get hasNextItem => nextSiblingItem != null;

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check if the first item is current item.
  ///
  bool get isFirstItemCurrent {
    ITEM? first = firstItem;
    ITEM? current = currentItem;
    if (first == null || current == null) {
      return false;
    }
    return block.getItemId(first) == block.getItemId(current);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check if the last item is current item.
  ///
  bool get isLastItemCurrent {
    ITEM? last = lastItem;
    ITEM? current = currentItem;
    if (last == null || current == null) {
      return false;
    }
    return block.getItemId(last) == block.getItemId(current);
  }

  // ***************************************************************************
  // ******* PUBLIC ITEM METHODS ***********************************************
  // ***************************************************************************

  bool isSelectedIndex({required int index}) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isSelectedItem(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentIndex({required int index}) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCurrentItem(item: item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItem({
    required ITEM item,
  }) {
    ITEM? currIt = __current._item;
    return currIt != null && block.getItemId(item) == block.getItemId(currIt);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSelectedItem(ITEM item) {
    return ItemsUtils.isListContainItem(
      targetList: _selectedItems,
      item: item,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCheckedItem(ITEM item) {
    return ItemsUtils.isListContainItem(
      targetList: _checkedItems,
      item: item,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool containsItem({
    required ITEM item,
  }) {
    return ItemsUtils.isListContainItem(
      targetList: _items,
      item: item,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findNextSiblingItem({
    required ITEM item,
  }) {
    return ItemsUtils.findNextSiblingItemInList(
      item: item,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findPreviousSiblingItem({
    required ITEM item,
  }) {
    return ItemsUtils.findPreviousSiblingItemInList(
      item: item,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findSiblingItem({
    required ITEM item,
  }) {
    return ItemsUtils.findSiblingItemInList(
      item: item,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemSameIdWith({
    required ITEM item,
  }) {
    ID id = block.getItemId(item);
    return findItemById(id);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemById(ID itemId) {
    return ItemsUtils.findItemInListById(
      id: itemId,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemByIndex(int index) {
    if (index < 0 || index >= _items.length) {
      return null;
    }
    return _items[index];
  }

  // ***************************************************************************
  // ******* PRIVATE ITEM METHODS **********************************************
  // ***************************************************************************

  void _toggleCheckItem({required ITEM item}) {
    bool checked = isCheckedItem(item);
    _setCheckedItem(item: item, checked: !checked);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _toggleSelectItem({required ITEM item}) {
    bool selected = isSelectedItem(item);
    _setSelectedItem(item: item, selected: !selected);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setCheckedItem({required ITEM item, required bool checked}) {
    if (checked) {
      __checkItem(item);
    } else {
      __uncheckItem(item);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setSelectedItem({required ITEM item, required bool selected}) {
    if (selected) {
      __selectItem(item);
    } else {
      __deselectItem(item);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setCheckedItems({required List<ITEM> items}) {
    ItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setSelectedItems({required List<ITEM> items}) {
    ItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __checkItem(ITEM item) {
    ItemsUtils.insertOrReplaceItemInList(
      item: item,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __selectItem(ITEM item) {
    ItemsUtils.insertOrReplaceItemInList(
      item: item,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __uncheckItem(ITEM item) {
    ItemsUtils.removeItemFromList(
      removeItem: item,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __deselectItem(ITEM item) {
    ItemsUtils.removeItemFromList(
      removeItem: item,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _uncheckAllItems() {
    _checkedItems.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _deselectAllItems() {
    _selectedItems.clear();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _checkAllItems() {
    _setCheckedItems(items: _items);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _selectAllItems() {
    _setSelectedItems(items: _items);
  }
}
