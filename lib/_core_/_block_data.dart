part of '../flutter_artist.dart';

abstract class BlockData<
    ID extends Object,
    I extends Object,
    D extends Object,
    S extends FilterSnapshot,
    SF extends SuggestedFormData> implements PageData<I> {
  final Block<ID, I, D, S, SF> block;

  late final List<I> _items;

  ///
  /// return a copied list of items.
  ///
  @override
  List<I> get items {
    return [..._items];
  }

  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  Object? _currentParentItemId;

  S? _filterSnapshot;

  S? get filterSnapshot => _filterSnapshot;

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
      getItemId: block.getItemId,
    );
    FormUtils.removeItemFromList(
      items: _checkedItems,
      removeItem: removeItem,
      getItemId: block.getItemId,
    );
  }

  void _insertOrReplaceItem({
    required D itemDetail,
    required I item,
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

  I? _findItemById({
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
    required I item,
  }) {
    return _isListContainItem(
      items: _items,
      item: item,
      getItemId: block.getItemId,
    );
  }

  bool isCurrentItem({
    required I item,
  }) {
    return __current._item != null &&
        block.getItemId(item) == block.getItemId(__current._item!);
  }

  void __append({required List<I> appendItems}) {
    List<I> all = [];
    List<I> tailItems = [...appendItems];
    for (I item in _items) {
      I? it = _getItemBySameItemId(
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
    required S? filterSnapshot,
    required PageableData? pageable,
    required PageData<I>? pageData,
    required DataState dataState,
  }) {
    // Check if filterSnapshot changed.
    if (forceListBehavior == ListBehavior.replace ||
        _currentParentItemId != currentParentItemId ||
        _filterSnapshot != filterSnapshot) {
      _items.clear();
    }
    //
    PageData<I> ap = pageData ?? PageData<I>.empty();
    //
    _currentParentItemId = currentParentItemId;
    _filterSnapshot = filterSnapshot;
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
      getItemId: block.getItemId,
    );
  }

  I? _findItemSameIdWith({
    required I item,
  }) {
    for (var it in _items) {
      if (block.getItemId(item) == block.getItemId(it)) {
        return it;
      }
    }
    return null;
  }

  I? findItemById(ID id) {
    for (I item in _items) {
      if (block.getItemId(item) == id) {
        return item;
      }
    }
    return null;
  }

  void setCheckedItem(I item) {
    I? foundItem = _findItemSameIdWith(
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

  void setUncheckedItem(I item) {
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
