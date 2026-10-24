part of '../core.dart';

class _BlockItem2Wrap<ID, ITEM, ITEM_DETAIL> {
  final ID? _id;
  final ITEM? _item;
  final ITEM_DETAIL? _itemDetail;

  _BlockItem2Wrap.ofNull()
      : _id = null,
        _item = null,
        _itemDetail = null;

  _BlockItem2Wrap({
    required ID id,
    required ITEM item,
    required ITEM_DETAIL itemDetail,
  })  : _id = id,
        _item = item,
        _itemDetail = itemDetail;
}
