part of '../flutter_artist.dart';

abstract class QuickCreateAction<ITEM_DETAIL extends Object>
    extends BaseAction {
  const QuickCreateAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickCreateItem();
}
