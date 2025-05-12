part of '../../flutter_artist.dart';

abstract class QuickCreateItemAction<ITEM_DETAIL extends Object>
    extends BaseAction {
  const QuickCreateItemAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiQuickCreateItem();
}
