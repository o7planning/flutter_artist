part of '../../flutter_artist.dart';

class _CurrentCoupleItem<ITEM, ITEM_DETAIL> {
  final ITEM? _item;
  final ITEM_DETAIL? _itemDetail;

  _CurrentCoupleItem({required ITEM? item, required ITEM_DETAIL? itemDetail})
      : _item = item,
        _itemDetail = itemDetail,
        assert((item == null && itemDetail == null) ||
            (item != null && itemDetail != null));
}
