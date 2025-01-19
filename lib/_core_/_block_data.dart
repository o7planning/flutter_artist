part of '../flutter_artist.dart';

abstract class BlockData<
    ID extends Object,
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    SUGGESTED_CRITERIA extends SuggestedCriteria,
    FILTER_CRITERIA extends FilterCriteria,
    SUGGESTED_FORM_DATA extends SuggestedFormData> implements PageData<ITEM> {
  ///
  /// Owner block
  ///
  final Block<ID, ITEM, ITEM_DETAIL, SUGGESTED_CRITERIA, FILTER_CRITERIA,
      SUGGESTED_FORM_DATA> block;

  late final List<ITEM> _items;

  ///
  /// return a copied list of items.
  ///
  @override
  List<ITEM> get items {
    return [..._items];
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

  final List<ITEM> _checkedItems = [];

  ///
  /// return a copied list of checked items.
  ///
  List<ITEM> get checkedItems {
    return [..._checkedItems];
  }

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
    print(" --> Set to pending ${getClassName(block)}");
    _dataState = DataState.pending;
  }

  void _updateCheckedItems() {
    List<ITEM> newCheckedItems = [];
    for (var it in _checkedItems) {
      ITEM? newCheckItem = _findItemSameIdWith(
        item: it,
      );
      if (newCheckItem != null) {
        newCheckedItems.add(newCheckItem);
      }
    }
    _checkedItems
      ..clear()
      ..addAll(newCheckedItems);
  }

  void _setCheckedItem({
    required ITEM item,
  }) {
    ITEM? foundItem = _findItemSameIdWith(
      item: item,
    );
    int idx = _checkedItems
        .indexWhere((it) => block.getItemId(it) == block.getItemId(item));
    if (idx != -1) {
      if (foundItem != null) {
        _checkedItems[idx] = foundItem;
      }
    } else {
      if (foundItem != null) {
        _checkedItems.add(foundItem);
      }
    }
  }

  void _setCurrentItem({
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
      items: _items,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
    FormUtils.removeItemFromList(
      items: _checkedItems,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
  }

  void _insertOrReplaceItem({
    required ITEM_DETAIL itemDetail,
    required ITEM item,
  }) {
    FormUtils.insertOrReplaceItemInList(
      items: _items,
      item: item,
      getItemId: block.getItemId,
    );
    FormUtils.insertOrReplaceItemInList(
      items: _checkedItems,
      item: item,
      getItemId: block.getItemId,
    );
  }

  ITEM? _findItemById({
    required ID itemId,
  }) {
    for (var it in _items) {
      if (block.getItemId(it) == itemId) {
        return it;
      }
    }
    return null;
  }

  bool _isContains({
    required ITEM item,
  }) {
    return _isListContainItem(
      items: _items,
      item: item,
      getItemId: block.getItemId,
    );
  }

  bool isCurrentItem({
    required ITEM item,
  }) {
    return __current._item != null &&
        block.getItemId(item) == block.getItemId(__current._item!);
  }

  void __append({required List<ITEM> appendItems}) {
    List<ITEM> all = [];
    List<ITEM> tailItems = [...appendItems];
    for (ITEM item in _items) {
      ITEM? it = _getItemBySameItemId(
        items: appendItems,
        sameItem: item,
        getItemId: block.getItemId,
      );
      if (it != null) {
        all.add(it);
        tailItems.remove(it);
      } else {
        all.add(item);
      }
    }
    all.addAll(tailItems);
    //
    _items
      ..clear()
      ..addAll(all);
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
    __append(appendItems: ap.items);
    //
    _pageable = pageable?.copy();
    _pagination = PaginationData.copy(ap.pagination);
    //
    block.blockForm?.data._formMode = FormMode.none;
    //
    _updateCheckedItems();
  }

  ITEM? findFirstItem() {
    return _items.isEmpty ? null : _items[0];
  }

  ITEM? _findSiblingItem({
    required ITEM item,
  }) {
    return FormUtils.findSiblingItemInList(
      items: items,
      item: item,
      getItemId: block.getItemId,
    );
  }

  ITEM? _findItemSameIdWith({
    required ITEM item,
  }) {
    for (var it in _items) {
      if (block.getItemId(item) == block.getItemId(it)) {
        return it;
      }
    }
    return null;
  }

  ITEM? findItemById(ID id) {
    for (ITEM item in _items) {
      if (block.getItemId(item) == id) {
        return item;
      }
    }
    return null;
  }

  void setCheckedItem(ITEM item) {
    ITEM? foundItem = _findItemSameIdWith(
      item: item,
    );
    int idx = _checkedItems
        .indexWhere((it) => block.getItemId(it) == block.getItemId(item));
    if (idx != -1) {
      if (foundItem != null) {
        _checkedItems[idx] = foundItem;
      }
    } else {
      if (foundItem != null) {
        _checkedItems.add(foundItem);
      }
    }
    block.updateFragmentWidgets();
  }

  void setUncheckedItem(ITEM item) {
    int idx = _checkedItems
        .indexWhere((it) => block.getItemId(it) == block.getItemId(item));
    if (idx != -1) {
      _checkedItems.removeAt(idx);
    }
    block.updateFragmentWidgets();
  }

  void uncheckAll() {
    _checkedItems.clear();
    block.updateFragmentWidgets();
  }

  void checkAll() {
    _checkedItems
      ..clear()
      ..addAll(_items);
    block.updateFragmentWidgets();
  }
}
