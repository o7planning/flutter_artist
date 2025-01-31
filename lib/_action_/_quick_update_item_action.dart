part of '../flutter_artist.dart';

abstract class QuickUpdateItemAction<ITEM extends Object,
    ITEM_DETAIL extends Object> extends BaseAction {
  const QuickUpdateItemAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickUpdateItem({required ITEM item});
}
