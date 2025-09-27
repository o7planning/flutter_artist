part of '../core.dart';

class _CurrentItemWrap<ID, ITEM, ITEM_DETAIL> {
  final ID? _id;
  final ITEM? _item;
  final ITEM_DETAIL? _itemDetail;

  _CurrentItemWrap({
    required ID? id,
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  })  : _id = id,
        _item = item,
        _itemDetail = itemDetail,
        assert((id == null && item == null && itemDetail == null) ||
            (id != null && item != null && itemDetail != null));
}
