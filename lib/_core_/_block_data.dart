part of '../flutter_artist.dart';

abstract class BlockData<
    ID extends Object,
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria,
    EXTRA_INPUT extends ExtraInput> implements PageData<ITEM> {
  ///
  /// Owner block
  ///
  final Block<ID, ITEM, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA, EXTRA_INPUT>
      block;

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

  @override
  PaginationData? get pagination => PaginationData.copy(_pagination);

  _CurrentCoupleItem<ITEM, ITEM_DETAIL> __current = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );

  ITEM? get currentItem => __current._item;

  ITEM_DETAIL? get currentItemDetail => __current._itemDetail;

  DataState _dataState = DataState.pending;

  DataState get dataState => _dataState;

  BlockData({
    required this.block,
    required List<ITEM> items,
    required PaginationData? pagination,
    required PageableData? pageable,
  })  : _items = items,
        _pageable = pageable,
        _pagination = pagination;

  void _backup();

  void _restore();

  void _applyNewState();

  void setToPending() {
    print(" --> ${getClassName(block)} --> Set To Pending");
    _dataState = DataState.pending;
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
    FormUtils.insertOrReplaceItemInList(
      targetList: _checkedItems,
      item: item,
      getItemId: block.getItemId,
    );
    FormUtils.insertOrReplaceItemInList(
      targetList: _selectedItems,
      item: item,
      getItemId: block.getItemId,
    );
  }

  void __appendItems({required List<ITEM> appendItems}) {
    FormUtils.appendItemsToList(
      appendItems: appendItems,
      targetList: _items,
      getItemId: block.getItemId,
    );
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
    required PageData<ITEM>? pageData,
    required DataState dataState,
  }) {
    // Check if filterCriteria changed.
    if (forceListBehavior == ListBehavior.replace ||
        _currentParentItemId != currentParentItemId ||
        _filterCriteria != filterCriteria) {
      _items.clear();
    }
    //
    PageData<ITEM> ap = pageData ?? PageData<ITEM>.empty();
    //
    _currentParentItemId = currentParentItemId;
    _filterCriteria = filterCriteria;
    _lastQueryResult = pageData;
    _dataState = dataState;
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
  // ******* PUBLIC ITEM METHODS ***********************************************
  // ***************************************************************************

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

  // bool containsSelectedItems(List<ITEM> items) {
  //   return FormUtils.isListContainItems(
  //     targetList: _selectedItems,
  //     items: items,
  //     getItemId: block.getItemId,
  //   );
  // }
  //
  // bool containsCheckedItems(List<ITEM> items) {
  //   return FormUtils.isListContainItems(
  //     targetList: _checkedItems,
  //     items: items,
  //     getItemId: block.getItemId,
  //   );
  // }

  bool containsItem({
    required ITEM item,
  }) {
    return FormUtils.isListContainItem(
      targetList: _items,
      item: item,
      getItemId: block.getItemId,
    );
  }

  ITEM? findFirstItem() {
    return _items.isEmpty ? null : _items[0];
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
    FormUtils.findItemById(
      id: itemId,
      targetList: _items,
      getItemId: block.getItemId,
    );
  }

  // ***************************************************************************
  // ******* PRIVATE ITEM METHODS **********************************************
  // ***************************************************************************

  void _setCheckedItem(ITEM item) {
    _uncheckAllItems();
    _addCheckedItem(item);
  }

  void _setSelectedItem(ITEM item) {
    _uncheckAllItems();
    _addSelectedItem(item);
  }

  // ---------------------------------------------------------------------------

  void _setCheckedItems(List<ITEM> items) {
    _uncheckAllItems();
    _addCheckedItems(items);
  }

  void _setSelectedItems(List<ITEM> items) {
    _uncheckAllItems();
    _addSelectedItems(items);
  }

  // ---------------------------------------------------------------------------

  void _addCheckedItem(ITEM item) {
    FormUtils.insertOrReplaceItemInList(
      item: item,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  void _addSelectedItem(ITEM item) {
    FormUtils.insertOrReplaceItemInList(
      item: item,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ---------------------------------------------------------------------------

  void _addCheckedItems(List<ITEM> items) {
    FormUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  void _addSelectedItems(List<ITEM> items) {
    FormUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _selectedItems,
      getItemId: block.getItemId,
    );
  }

  // ---------------------------------------------------------------------------

  void _uncheckItem(ITEM item) {
    FormUtils.removeItemFromList(
      removeItem: item,
      targetList: _checkedItems,
      getItemId: block.getItemId,
    );
  }

  void _deselectItemItems(ITEM item) {
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

  void _deselectAll() {
    _selectedItems.clear();
  }

  // ---------------------------------------------------------------------------

  void _checkAllItems() {
    _setCheckedItems(_items);
  }

  void _selectAllItems() {
    _setSelectedItems(_items);
  }
}
