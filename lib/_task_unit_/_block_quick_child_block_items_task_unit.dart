part of '../flutter_artist.dart';

class _BlockQuickChildBlockItemsTaskUnit<
    ITEM extends Object, //
    ITEM_DETAIL extends Object> extends _TaskUnit {
  _XBlock xBlock;
  QuickChildBlockItemsAction<ITEM, ITEM_DETAIL> action;

  _BlockQuickChildBlockItemsTaskUnit({
    required this.xBlock,
    required this.action,
  });
}
