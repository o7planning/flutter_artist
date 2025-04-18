part of '../flutter_artist.dart';

class XList<ID, ITEM> extends XData<ID, ITEM, List<ITEM>> {
  final List<ITEM> _items;

  List<ITEM> get items => [..._items];

  bool valid = true;

  bool get invalid => !valid;

  List<ITEM>? _candidateSelectedItems;

  List<ITEM>? get candidateSelectedItems => _candidateSelectedItems;

  XList({
    required List<ITEM> items,
    required super.getItemId,
  }) : _items = items;

  XList.fromPageData({
    required PageData<ITEM>? pageData,
    required super.getItemId,
  }) : _items = pageData?.items ?? [];

  XList.ofItems({
    required List<ITEM> items,
    required super.getItemId,
  }) : _items = items;

  XList.ofItem({
    required ITEM item,
    required super.getItemId,
  }) : _items = [item];

  XList.empty({
    required super.getItemId,
  }) : _items = [];

  @override
  List<ITEM> get data {
    return _items;
  }

  @override
  ITEM? findInternalItemByItemId(ID? id) {
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

  void replaceOrInsertItem({
    required ITEM newItem,
  }) {
    ItemsUtils.replaceOrInsertItem(
      newItem: newItem,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  void removeItemById(ID id) {
    ItemsUtils.removeItemById(
      id: id,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  void removeItem({required ITEM removeItem}) {
    ID id = getItemId(removeItem);
    removeItemById(id);
  }

  void addItemIfNotExists({
    required ITEM item,
  }) {
    ItemsUtils.addItemIfNotExists(
      item: item,
      targetList: _items,
      getItemId: _getItemId,
    );
  }

  void addItemsIfNotExists({
    required List<ITEM> items,
  }) {
    for (ITEM item in items) {
      addItemIfNotExists(item: item);
    }
  }

  void clear() {
    _items.clear();
  }

  @override
  void addNotFoundItem(ITEM item) {
    ITEM? internalItem = findInternalItem(item: item);
    if (internalItem == null) {
      _items.add(item);
    }
  }

  @override
  void removeNotFoundItem(ITEM item) {
    ITEM? internalItem = findInternalItem(item: item);
    if (internalItem != null) {
      _items.remove(internalItem);
    }
  }
}
