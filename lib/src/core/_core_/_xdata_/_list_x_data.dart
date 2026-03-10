part of '../core.dart';

class ListXData<ID, ITEM> extends XData<ID, ITEM, List<ITEM>> {
  final List<ITEM> _items;

  List<ITEM> get items => List.unmodifiable(_items);

  bool valid = true;

  bool get invalid => !valid;

  List<ITEM>? _candidateSelectedItems;

  List<ITEM>? get candidateSelectedItems => _candidateSelectedItems;

  ListXData({
    required List<ITEM> items,
    required super.getItemId,
  }) : _items = items;

  ListXData.fromPageData({
    required PageData<ITEM>? pageData,
    required super.getItemId,
  }) : _items = pageData?.items ?? [];

  ListXData.ofItems({
    required List<ITEM> items,
    required super.getItemId,
  }) : _items = items;

  ListXData.ofItem({
    required ITEM item,
    required super.getItemId,
  }) : _items = [item];

  ListXData.empty({
    required super.getItemId,
  }) : _items = [];

  @override
  List<ITEM> get data {
    return _items;
  }

  @override
  ITEM? findInternalItemById(ID? id) {
    return ItemsUtils.findItemInListById(
      id: id,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  @override
  List<ITEM> findInternalItems({required List<ITEM?>? items}) {
    return ItemsUtils.findItemsInList(
      items: items,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  void _replaceOrInsertItem({
    required ITEM newItem,
  }) {
    ItemsUtils.replaceOrInsertItem(
      newItem: newItem,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  void _removeItemById(ID id) {
    ItemsUtils.removeItemById(
      id: id,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  void _removeItem({required ITEM removeItem}) {
    ID id = getItemId(removeItem);
    _removeItemById(id);
  }

  void _addItemIfNotExists({
    required ITEM item,
  }) {
    ItemsUtils.addItemIfNotExists(
      item: item,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  void _addItemsIfNotExists({
    required List<ITEM> items,
  }) {
    for (ITEM item in items) {
      _addItemIfNotExists(item: item);
    }
  }

  void _clear() {
    _items.clear();
  }

  @override
  void addOrphanItem(ITEM item) {
    ITEM? internalItem = findInternalItem(item: item);
    if (internalItem == null) {
      _items.add(item);
    }
  }

  @override
  void removeOrphanItem(ITEM item) {
    ITEM? internalItem = findInternalItem(item: item);
    if (internalItem != null) {
      _items.remove(internalItem);
    }
  }
}
