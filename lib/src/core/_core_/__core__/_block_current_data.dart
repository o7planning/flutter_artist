part of '../core.dart';

class _BlockCurrentData<ID, ITEM, ITEM_DETAIL> {
  final ID? _id;
  final ITEM? _item;
  final ITEM_DETAIL? _itemDetail;

  _BlockCurrentData.ofNull()
      : _id = null,
        _item = null,
        _itemDetail = null;

  _BlockCurrentData({
    required ID id,
    required ITEM item,
    required ITEM_DETAIL itemDetail,
  })  : _id = id,
        _item = item,
        _itemDetail = itemDetail;
}
