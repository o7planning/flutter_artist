part of '../flutter_artist.dart';

abstract class QuickUpdateAction<ITEM_DETAIL extends Object>
    extends BaseActionData {
  const QuickUpdateAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickUpdate();
}
