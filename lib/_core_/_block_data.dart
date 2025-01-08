part of '../flutter_artist.dart';

abstract class BlockData<I extends Object, D extends Object,
    S extends FilterSnapshot> implements PageData<I> {
  final Block<I, D, S> block;

  late final List<I> _items;

  ///
  /// return a copied list of items.
  ///
  @override
  List<I> get items {
    return [..._items];
  }

  String? _currentParentItemId;

  S? _currentFilterSnapshot;

  S? get currentFilterSnapshot => _currentFilterSnapshot;

  PageData<I>? _lastQueryResult;

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
  PageData<I>? get lastQueryResult => _lastQueryResult;

  late PageableData? _pageable;

  PageableData? get pageable => _pageable;

  late PaginationData? _pagination;

  @override
  PaginationData? get pagination => PaginationData.copy(_pagination);

  _CurrentCoupleItem<I, D> __current = _CurrentCoupleItem(
    item: null,
    itemDetail: null,
  );

  I? get currentItem => __current._item;

  D? get currentItemDetail => __current._itemDetail;

  DataState _dataState = DataState.pending;

  DataState get dataState => _dataState;

  final List<I> _checkedItems = [];

  ///
  /// return a copied list of checked items.
  ///
  List<I> get checkedItems {
    return [..._checkedItems];
  }

  BlockData({
    required this.block,
    required List<I> items,
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
    List<I> newCheckedItems = [];
    for (var it in _checkedItems) {
      I? newCheckItem = _findItemSameIdWith(
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
    required I item,
  }) {
    I? foundItem = _findItemSameIdWith(
      item: item,
    );
    int idx = _checkedItems.indexWhere(
        (it) => block.getItemIdAsString(it) == block.getItemIdAsString(item));
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
    required I? refreshedItem,
    required D? refreshedItemDetail,
  }) {
    __current = _CurrentCoupleItem(
      item: refreshedItem,
      itemDetail: refreshedItemDetail,
    );
  }

  void _removeItem({
    required I removeItem,
  }) {
    FormUtils.removeItemFromList(
      items: _items,
      removeItem: removeItem,
      getItemIdAsString: block.getItemIdAsString,
    );
    FormUtils.removeItemFromList(
      items: _checkedItems,
      removeItem: removeItem,
      getItemIdAsString: block.getItemIdAsString,
    );
  }

  void _insertOrReplaceItem({
    required D itemDetail,
    required I item,
  }) {
    FormUtils.insertOrReplaceItemInList(
      items: _items,
      item: item,
      getItemIdAsString: block.getItemIdAsString,
    );
    FormUtils.insertOrReplaceItemInList(
      items: _checkedItems,
      item: item,
      getItemIdAsString: block.getItemIdAsString,
    );
  }

  I? _findItemByIdString({
    required String idString,
  }) {
    for (var it in _items) {
      if (block.getItemIdAsString(it) == idString) {
        return it;
      }
    }
    return null;
  }

  bool _isContains({
    required I item,
  }) {
    return _isListContainItem(
      items: _items,
      item: item,
      getItemIdAsString: block.getItemIdAsString,
    );
  }

  bool isCurrentItem({
    required I item,
  }) {
    return __current._item != null &&
        block.getItemIdAsString(item) ==
            block.getItemIdAsString(__current._item!);
  }

  void __append({required List<I> appendItems}) {
    List<I> all = [];
    List<I> tailItems = [...appendItems];
    for (I item in _items) {
      I? it = _getItemBySameItemId(
        items: appendItems,
        sameItem: item,
        getItemIdAsString: block.getItemIdAsString,
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
    required String? currentParentItem,
    required S? filterSnapshot,
    required PageableData? pageable,
    required PageData<I>? pageData,
    required DataState dataState,
  }) {
    // Check if currentFilterSnapshot changed.
    if (forceListBehavior == ListBehavior.replace ||
        _currentParentItemId != currentParentItem ||
        _currentFilterSnapshot != filterSnapshot) {
      _items.clear();
    }
    //
    PageData<I> ap = pageData ?? PageData<I>.empty();
    //
    _currentParentItemId = currentParentItem;
    _currentFilterSnapshot = filterSnapshot;
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

  I? findFirstItem() {
    return _items.isEmpty ? null : _items[0];
  }

  I? _findSiblingItem({
    required I item,
  }) {
    return FormUtils.findSiblingItemInList(
      items: items,
      item: item,
      getItemIdAsString: block.getItemIdAsString,
    );
  }

  I? _findItemSameIdWith({
    required I item,
  }) {
    for (var it in _items) {
      if (block.getItemIdAsString(item) == block.getItemIdAsString(it)) {
        return it;
      }
    }
    return null;
  }

  I? findItemByIdString(String id) {
    for (I item in _items) {
      if (block.getItemIdAsString(item) == id) {
        return item;
      }
    }
    return null;
  }

  void setCheckedItem(I item) {
    I? foundItem = _findItemSameIdWith(
      item: item,
    );
    int idx = _checkedItems.indexWhere(
        (it) => block.getItemIdAsString(it) == block.getItemIdAsString(item));
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

  void setUncheckedItem(I item) {
    int idx = _checkedItems.indexWhere(
        (it) => block.getItemIdAsString(it) == block.getItemIdAsString(item));
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
