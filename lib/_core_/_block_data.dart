part of '../flutter_artist.dart';

abstract class BlockData<
    ID extends Object,
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_FORM_INPUT extends ExtraFormInput> {
  ///
  /// Owner block
  ///
  final Block<ID, ITEM, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA,
      EXTRA_FORM_INPUT> block;

  late final List<ITEM> _items;
  final List<ITEM> _selectedItems = [];
  final List<ITEM> _checkedItems = [];

  ///
  /// return a copied list of items.
  ///
  @override
  List<ITEM> get items {
    return [..._items];
  }

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

  PageData<ID, ITEM>? _lastQueryResult;

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
  PageData<ID, ITEM>? get lastQueryResult => _lastQueryResult;

  late PageableData? _pageable;

  PageableData? get pageable => _pageable;

  late PaginationData? _pagination;

  @override
  PaginationData? get pagination => PaginationData.copy(_pagination);

  _CurrentCoupleItem<ITEM, ITEM_DETAIL> __current = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );

  ITEM? get currentItem => __current._item;

  ITEM_DETAIL? get currentItemDetail => __current._itemDetail;

  DataState _queryDataState = DataState.pending;

  DataState get queryDataState => _queryDataState;

  DataState _selectionDataState = DataState.pending;

  DataState get selectionDataState => _selectionDataState;

  BlockData({
    required this.block,
    required List<ITEM> items,
    required PaginationData? pagination,
    required PageableData? pageable,
  })  : _items = items,
        _pageable = pageable,
        _pagination = pagination;

  // ***************************************************************************

  void _clearWithDataState({required DataState dataState}) {
    _items.clear();
    _selectedItems.clear();
    _checkedItems.clear();
    _setCurrentItemOnly(refreshedItem: null, refreshedItemDetail: null);
    _lastQueryResult = null;
  }

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

  void _backup();

  void _restore();

  void _applyNewState();

  void setToPending() {
    print(" --> ${getClassName(block)} --> Set To Pending");
    _queryDataState = DataState.pending;
  }

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

  void _removeItem({
    required ITEM removeItem,
  }) {
    FormUtils.removeItemFromList(
      targetList: _items,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
    FormUtils.removeItemFromList(
      targetList: _checkedItems,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
    FormUtils.removeItemFromList(
      targetList: _selectedItems,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
  }

  void _insertOrReplaceItem({
    required ITEM_DETAIL itemDetail,
    required ITEM item,
  }) {
    FormUtils.insertOrReplaceItemInList(
      targetList: _items,
      item: item,
      getItemId: block.getItemId,
    );
    //
    sort();
    //
    FormUtils.replaceItemInList(
      targetList: _checkedItems,
      replacementItem: item,
      getItemId: block.getItemId,
    );
    FormUtils.replaceItemInList(
      targetList: _selectedItems,
      replacementItem: item,
      getItemId: block.getItemId,
    );
  }

  void __appendItems({required List<ITEM> appendItems}) {
    FormUtils.appendItemsToList(
      appendItems: appendItems,
      targetList: _items,
      getItemId: block.getItemId,
    );
    //
    sort();
    //
    FormUtils.replaceItemsInList(
      replacementItems: appendItems,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
    FormUtils.replaceItemsInList(
      replacementItems: appendItems,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  void _updateFrom({
    required ListBehavior forceListBehavior,
    required Object? currentParentItemId,
    required FILTER_CRITERIA? filterCriteria,
    required PageableData? pageable,
    required PageData<ID, ITEM>? pageData,
    required DataState dataState,
  }) {
    // Check if filterCriteria changed.
    if (forceListBehavior == ListBehavior.replace ||
        _currentParentItemId != currentParentItemId ||
        _filterCriteria != filterCriteria) {
      _items.clear();
    }
    //
    PageData<ID, ITEM> ap = pageData ??
        DefaultPageData<ID, ITEM>.empty(
          getItemId: block.getItemId,
        );
    //
    _currentParentItemId = currentParentItemId;
    _filterCriteria = filterCriteria;
    _lastQueryResult = pageData;
    _queryDataState = dataState;
    //
    // Append to _items:
    //
    __appendItems(appendItems: ap.items);
    //
    _pageable = pageable?.copy();
    _pagination = PaginationData.copy(ap.pagination);
    //
    block.blockForm?.data._formMode = FormMode.none;
  }

  // ***************************************************************************
  // ******* PUBLIC ITEM PROPERTIES ********************************************
  // ***************************************************************************

  ITEM? get firstItem {
    return _items.firstOrNull;
  }

  ITEM? get lastItem {
    return _items.lastOrNull;
  }

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

  bool get hasPreviousItem => previousSiblingItem != null;

  bool get hasNextItem => nextSiblingItem != null;

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

  bool isCurrentIndex({required int index}) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCurrentItem(item: item);
  }

  bool isCurrentItem({
    required ITEM item,
  }) {
    ITEM? currIt = __current._item;
    return currIt != null && block.getItemId(item) == block.getItemId(currIt);
  }

  bool isSelectedItem(ITEM item) {
    return FormUtils.isListContainItem(
      targetList: _selectedItems,
      item: item,
      getItemId: block.getItemId,
    );
  }

  bool isCheckedItem(ITEM item) {
    return FormUtils.isListContainItem(
      targetList: _checkedItems,
      item: item,
      getItemId: block.getItemId,
    );
  }

  bool containsItem({
    required ITEM item,
  }) {
    return FormUtils.isListContainItem(
      targetList: _items,
      item: item,
      getItemId: block.getItemId,
    );
  }

  ITEM? findNextSiblingItem({
    required ITEM item,
  }) {
    return FormUtils.findNextSiblingItemInList(
      item: item,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  ITEM? findPreviousSiblingItem({
    required ITEM item,
  }) {
    return FormUtils.findPreviousSiblingItemInList(
      item: item,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  ITEM? findSiblingItem({
    required ITEM item,
  }) {
    return FormUtils.findSiblingItemInList(
      item: item,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  ITEM? findItemSameIdWith({
    required ITEM item,
  }) {
    ID id = block.getItemId(item);
    return findItemById(id);
  }

  ITEM? findItemById(ID itemId) {
    return FormUtils.findItemById(
      id: itemId,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

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

  void _toggleSelectItem({required ITEM item}) {
    bool selected = isSelectedItem(item);
    _setSelectedItem(item: item, selected: !selected);
  }

  void _setCheckedItem({required ITEM item, required bool checked}) {
    if (checked) {
      __checkItem(item);
    } else {
      __uncheckItem(item);
    }
  }

  void _setSelectedItem({required ITEM item, required bool selected}) {
    if (selected) {
      __selectItem(item);
    } else {
      __deselectItem(item);
    }
  }

  // ---------------------------------------------------------------------------

  void _setCheckedItems({required List<ITEM> items}) {
    FormUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  void _setSelectedItems({required List<ITEM> items}) {
    FormUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ---------------------------------------------------------------------------

  void __checkItem(ITEM item) {
    FormUtils.insertOrReplaceItemInList(
      item: item,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  void __selectItem(ITEM item) {
    FormUtils.insertOrReplaceItemInList(
      item: item,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ---------------------------------------------------------------------------

  void __uncheckItem(ITEM item) {
    FormUtils.removeItemFromList(
      removeItem: item,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  void __deselectItem(ITEM item) {
    FormUtils.removeItemFromList(
      removeItem: item,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ---------------------------------------------------------------------------

  void _uncheckAllItems() {
    _checkedItems.clear();
  }

  void _deselectAllItems() {
    _selectedItems.clear();
  }

  // ---------------------------------------------------------------------------

  void _checkAllItems() {
    _setCheckedItems(items: _items);
  }

  void _selectAllItems() {
    _setSelectedItems(items: _items);
  }
}
