part of '../flutter_artist.dart';

class _CurrentCoupleItem<I, D> {
  final I? _item;
  final D? _itemDetail;

  _CurrentCoupleItem({required I? item, required D? itemDetail})
      : _item = item,
        _itemDetail = itemDetail,
        assert((item == null && itemDetail == null) ||
            (item != null && itemDetail != null));
}
